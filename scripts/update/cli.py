# -*- coding: utf-8 -*-

"""
Manager Command Line Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:copyright: © 2019 Crown Copyright (Government Digital Service)
:license: MIT, see LICENSE for more details.
"""

import os
import subprocess
from datetime import datetime
from pathlib import Path
import click
import requests
from requests.exceptions import RequestException
from registers import rsf, xsv, Register, Patch
from registers.exceptions import RegistersException
from registers.commands import utils
from registers import commands


PHASES = ["test", "discovery", "alpha", "beta"]


def stamp_time():
    """
    Stamps the current time in RFC3339.
    """

    now = datetime.utcnow()
    return f"{now.isoformat(timespec='seconds')}Z"


@click.group()
def cli():
    """
    'update' lets you manage Register updates to ORJ.
    """


@cli.command(name="init")
@click.argument("rsf_file", type=click.Path(exists=True))
@click.option("--phase", default="beta", type=click.Choice(PHASES))
def init_command(rsf_file, phase):
    """
    Uploads the given RSF_FILE to an empty ORJ register.
    """

    try:
        cmds = rsf.read(rsf_file)
        register = Register(cmds)

        utils.check_readiness(register)

        publish_register(register, rsf_file, phase)

    except RegistersException as err:
        utils.error(str(err))

    except RequestException as err:
        utils.error(str(err))


@cli.command(name="empty")
@click.argument("register_id")
@click.option("--phase", default="test",
              type=click.Choice(["test", "discovery", "alpha"]))
def empty_command(register_id, phase):
    """
    Empties a register. This command can't be used with beta registers.
    """

    try:
        headers = {
            "Content-Type": "application/uk-gov-rsf",
            "User-Agent": "update-tool"
        }

        path = pass_path(phase, register_id)
        url = orj_url(register_id, phase)
        default_message = (f"If left empty it will attempt to get it "
                           f"from pass({path})")
        password = click.prompt((f"Please enter the password for {url}\n"
                                 f"[{default_message}]"),
                                hide_input=True,
                                default='',
                                show_default=False)
        if not password:
            password = passwordstore(path)

        auth = ("openregister", password)

        resp = requests.delete(f"{url}/delete-register-data",
                               auth=auth,
                               headers=headers)

        if resp.status_code != requests.codes.ok:
            click.secho("Something went wrong while emptyng ORJ.",
                        fg="bright_red")

            click.echo(f"Status code: {resp.status_code}\n")
            click.echo(f"Response:\n\n{resp.text}")
            raise click.Abort

    except RegistersException as err:
        utils.error(str(err))

    except RequestException as err:
        utils.error(str(err))


@cli.command(name="data")
@click.argument("xsv_file")
@click.option("--timestamp", default=stamp_time(),
              help="A timestamp (RFC3339) to set for all entries in the \
patch.")
@click.option("--rsf", "rsf_file", required=True, type=click.Path(exists=True),
              help="An RSF file with valid metadata")
@click.option("--phase", default="beta", type=click.Choice(PHASES))
def data_command(xsv_file, rsf_file, timestamp, phase):
    """
    Creates an RSF patch from XSV_FILE.

    XSV_FILE is expected to be either a TSV (Tab Separated Value) or a CSV
    (Comma Separated Value). The parser will try to determine the separator
    automatically.

    You MUST NOT use `;` as separator as it will conflict with cardinality 'n'
    value separator.
    """

    try:
        cmds = rsf.read(rsf_file)
        register = Register(cmds)

        utils.check_readiness(register)

        schema = register.schema()

        with open(xsv_file, "r", newline="") as stream:
            blobs = xsv.deserialise(stream, schema)
            patch = Patch(schema, blobs, timestamp)

            publish_patch(patch, register, rsf_file, phase)

    except RegistersException as err:
        utils.error(str(err))

    except RequestException as err:
        utils.error(str(err))


@cli.command(name="context")
@click.argument("key", type=click.Choice(["custodian",
                                          "title",
                                          "description"]))
@click.argument("value")
@click.option("--rsf", "rsf_file", required=True, type=click.Path(exists=True),
              help="An RSF file with valid metadata")
@click.option("--phase", default="beta", type=click.Choice(PHASES))
@click.pass_context
def context_command(ctx, key, value, rsf_file, phase):
    """
    Creates an RSF patch from VALUE for the given KEY.

    For example, to create a patch for the custodian:

        context --rsf web-colors.rsf custodian "John Doe"


    To create a patch for changing the registers title:

        context --rsf web-colors.rsf title "The Web Colour Register"


    To create a patch for changing the registers description:

        context --rsf web-colors.rsf description "Lorem Ipsum dolor sit amet"
    """

    try:
        cmds = rsf.read(rsf_file)
        register = Register(cmds)

        utils.check_readiness(register)

        stamp = stamp_time()

        patch = ctx.invoke(commands.context.create_patch,
                           key, value, stamp, register)

        publish_patch(patch, register, rsf_file, phase)

    except RegistersException as err:
        utils.error(str(err))

    except RequestException as err:
        utils.error(str(err))


@cli.command(name="schema")
@click.argument("attr_id")
@click.argument("value")
@click.option("--rsf", "rsf_file", required=True, type=click.Path(exists=True),
              help="An RSF file with valid metadata")
@click.option("--phase", default="beta", type=click.Choice(PHASES))
@click.pass_context
def schema_command(ctx, attr_id, value, rsf_file, phase):
    """
    Creates an RSF patch that modifies ATTR_ID description with the given
    VALUE.

    For example, to create a patch for the attribute ``name``:

        schema --rsf web-colors.rsf name "The W3C name of the colour."
    """

    try:
        cmds = rsf.read(rsf_file)
        register = Register(cmds)

        utils.check_readiness(register)

        stamp = stamp_time()
        cmds = ctx.invoke(commands.schema.patch_attr,
                          attr_id, value, stamp, register)
        patch = Patch(register.schema(), cmds)

        publish_patch(patch, register, rsf_file, phase)

    except RegistersException as err:
        utils.error(str(err))

    except RequestException as err:
        utils.error(str(err))


def publish_patch(patch: Patch, register: Register, rsf_file: str, phase: str):
    """
    Attempts to publish the given patch to ORJ and to the local RSF.
    """

    for cmd in patch.commands:
        click.secho(repr(cmd), fg="green")

    url = orj_url(register.uid, phase)
    click.confirm(f"Do you want to push this patch to {url}?",
                  abort=True)

    push_patch(patch, url, pass_path(phase, register.uid))

    if click.confirm(f"Do you want to apply this patch to {rsf_file}?"):
        apply_patch(patch, rsf_file)


def publish_register(register: Register, rsf_file: str, phase: str):
    """
    Attempts to publish the given register to ORJ.
    """

    cmds = register.commands

    url = orj_url(register.uid, phase)
    click.confirm(f"Do you want to push this register to {url}?",
                  abort=True)

    path = pass_path(phase, register.uid)
    push_patch(Patch(cmds), url, path)


def orj_url(uid: str, phase: str) -> str:
    """
    Composes the ORJ url.
    """

    if phase in ("test", "alpha", "beta"):
        return f"https://{uid}.{phase}.openregister.org"

    if phase == "discovery":
        return f"https://{uid}.cloudapps.digital"

    raise RegistersException("Unexpected phase")


def push_patch(patch: Patch, url: str, path: str):
    """
    Pushes the given patch to the given URL.

    Note that the URL must be a ORJ instance with the endpoint
    ``POST /load-rsf`` enabled.
    """

    default_message = (f"If left empty it will attempt to get it "
                       f"from pass({path})")
    password = click.prompt((f"Please enter the password for {url}\n"
                             f"[{default_message}]"),
                            hide_input=True,
                            default='',
                            show_default=False)
    if not password:
        password = passwordstore(path)

    click.secho(f"Loading patch to {url} ...", fg="bright_yellow")

    data = rsf.dump(patch.commands)
    headers = {
        "Content-Type": "application/uk-gov-rsf",
        "User-Agent": "update-tool"
    }
    auth = ("openregister", password)

    resp = requests.post(f"{url}/load-rsf",
                         auth=auth,
                         data=data.encode("utf-8"),
                         headers=headers)

    if resp.status_code != requests.codes.ok:
        click.secho("Something went wrong while loading a patch to ORJ.",
                    fg="bright_red")

        click.echo(f"Status code: {resp.status_code}\n")
        click.echo(f"Response:\n\n{resp.text}")
        raise click.Abort


def passwordstore(path: str) -> str:
    """
    Wrapper for the ``pass`` command.

    See: https://www.passwordstore.org/
    """

    try:
        home = str(Path.home())
        os.environ["PASSWORD_STORE_DIR"] = f"{home}/.registers-pass"
        result = subprocess.run(["pass", path], capture_output=True)

        if result.stdout:
            return result.stdout.decode("utf-8").strip()

        raise RegistersException(result.stderr.decode("utf-8").strip())

    except FileNotFoundError:
        raise RegistersException(("Couldn't find `pass`. "
                                  "Make sure it is installed."))


def pass_path(phase: str, uid: str) -> str:
    """
    Composes a pass path.
    """

    return f"{phase}/app/mint/{uid}"


def apply_patch(patch: Patch, rsf_file: str):
    """
    Appends the RSF commands in ``patch`` to the given file.
    """

    cmds = patch.commands

    with open(rsf_file, "a") as stream:
        stream.writelines([f"{cmd}\n" for cmd in cmds])

    msg = f"Appended {len(cmds)} changes to {rsf_file}"

    utils.success(msg)


if __name__ == '__main__':
    cli(prog_name="pipenv run update")

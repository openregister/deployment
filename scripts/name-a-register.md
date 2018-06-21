# Name a register

Registers already have names (which are also their unique ID) ... but now they can also have a 'title' (or whatever you want to call it).

You need to know:

1. The name of the register, e.g. `school-eng`
2. The title to give the register, e.g. `Schools in England`
3. The password for the register, from `registers-pass`, e.g. `registers-pass discovery/app/mint/school-eng`.
4. The URL for the register, e.g. `https://school-eng.cloudapps.digital/`
5. The current date and time in ISO8601 format, e.g. `2018-04-24T15:48:52Z`

You need to construct a JSON string like `{"register-name":"Schools in England"}`, and then get its SHA256 hash by pasting the whole string (including the curly braces) into an [online hash generator](https://emn178.github.io/online-tools/sha256.html), e.g. `0a07dc71614c3aeee29557e22c97e53b2390e79c6976e468c7e4292d984ba28a`.

Be in the directory `deployment/scripts`.

Run in the shell:

```
echo -e 'add-item\t{"register-name":"Schools in England"}\nappend-entry\tsystem\tregister-name\t2018-04-24T15:48:52Z\tsha-256:0a07dc71614c3aeee29557e22c97e53b2390e79c6976e468c7e4292d984ba28a' | ./rsf-load.sh https://school-eng.cloudapps.digital openregister as897sdf98sdf987
```

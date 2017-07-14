function update_registers_pass()
{
  if [ -e ~/.registers-pass ]
  then
    echo "updating repo ~/.registers-pass"
    cd ~/.registers-pass
    git checkout master && git pull --rebase
  else
    echo "cloning credentials repo to ~/.registers-pass"
    cd ~
    git clone git@github.com:openregister/credentials.git .registers-pass
  fi
  cd -
}

function update_data_repo()
{
  echo ""
  local repo="$OPENREGISTER_BASE/$1"
  if [ -e $repo ]
  then
    echo "$repo repo: checkout master && pull"
    cd $repo
    git checkout master && git pull --rebase
  else
    echo "cloning repo"
    cd $OPENREGISTER_BASE
    git clone git@github.com:openregister/$repo.git
  fi
  cd -
}

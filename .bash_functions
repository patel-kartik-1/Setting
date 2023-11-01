#!/bin/bash

phpmode() {

  PHP_VER="$1"

  sudo a2dismod php7.3
  sudo a2dismod php7.4
  sudo a2dismod php8.0
  sudo a2enmod php"$PHP_VER"
  sudo service apache2 restart
  sudo update-alternatives --set php /usr/bin/php"$PHP_VER"
}

co() {
  git checkout "$1"
}

con() {
  git checkout -b "$1"
}

commit() {
  MESSAGE="$1"

  if [ "$MESSAGE" = "" ]; then
    MESSAGE="wip"
  fi
  git add .
  eval "git commit -a -m '${MESSAGE}'"
}

clsgit() {
  git gc
  git trim
}

setdsm() {
  mkdir -p ./bootstrap/cache
  mkdir -p ./storage/app/public
  mkdir -p ./storage/framework/cache
  mkdir -p ./storage/framework/sessions
  mkdir -p ./storage/framework/views
  mkdir -p ./storage/logs
}

setmdj() {
  mkdir -p ./bootstrap/cache
  mkdir -p ./storage/app/public
  mkdir -p ./storage/framework/cache
  mkdir -p ./storage/framework/sessions
  mkdir -p ./storage/framework/views
  mkdir -p ./storage/logs
}

amend() {
  git add .
  git commit -a --amend
  git push -f
}

rebase() {
  git add .
  git stash
  git rebase -i "$1"
  git stash pop
  git add .
  git commit --amend
  git push -f
}

clslara() {
  php artisan cache:clear
  php artisan view:clear
  php artisan config:clear
  php artisan route:clear
  php artisan debugbar:clear
  php artisan optimize:clear

  sudo rm -rf storage/logs/*.log
}

pullrebase() {
  git add .
  git stash
  git pull --rebase
  git stash pop
}

#!/bin/bash

function run {
  printf "$1\n"
  eval $1
  printf "\n\n"
}

run "heroku ps"

run "heroku ps -a max"

run "heroku ps:resize -a max"

run "heroku ps:resize web=1 -a max"

run "heroku ps:resize web=1x -a max"

run "heroku ps:resize web=1X -a max"

run "heroku ps:resize web=2 -a max"

run "heroku ps:resize web=2x -a max"

run "heroku ps:resize web=2X -a max"

run "heroku ps:resize web=3 -a max"

run "heroku ps:resize web=4x -a max"

run "heroku ps:resize web=1x worker=2x -a max"

run "heroku ps:resize worker=2x web=2x -a max"

run "heroku ps:resize web=2x foo -a max"

run "heroku ps:resize foo web=2x -a max"

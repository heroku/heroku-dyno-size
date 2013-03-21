#!/bin/bash

function run {
  printf "$1\n"
  eval $1
  printf "\n\n"
}

run "heroku ps:size"

run "heroku ps:size web=1"

run "heroku ps:size web=1x"

run "heroku ps:size web=1X"

run "heroku ps:size web=2"

run "heroku ps:size web=2x"

run "heroku ps:size web=2X"

run "heroku ps:size web=3"

run "heroku ps:size web=4x"

run "heroku ps:size worker=2X"

run "heroku ps:size web=2x worker=2x"

run "heroku ps:size worker=2x web=2x"
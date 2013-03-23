# heroku-dyno-size

A Heroku CLI plugin to resize dynos to a given size.

## Installation

```sh
heroku plugins:install https://github.com/heroku/heroku-dyno-size.git
```

## Usage

```
Usage: heroku ps:resize PROCESS1=1x|2x [PROCESS2=1x|2x ...]

 resize dynos to the given size

Examples:

  $ heroku ps:resize web=2x worker=1x
  Resizing web dynos to 2X ($0.10/dyno-hour)... done, now 2X
  Resizing worker dynos to 1X ($0.05/dyno-hour)... done, now 1X
```

## Development

```sh
git clone https://github.com/heroku/heroku-dyno-size.git
ln -s ~/.heroku/plugins path/to/heroku-dyno-size
cd path/to/heroku-dyno-size
./test.sh
```

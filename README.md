# heroku-2x-dynos

A Heroku CLI plugin to resize processes to a given size.

## Installation

```sh
heroku plugins:install https://github.com/heroku/heroku-2x-dynos.git
```

## Usage

```
Usage: heroku ps:resize PROCESS1=SIZE1 [PROCESS2=SIZE2 ...]

 resize processes to the given size

Examples:

  $ heroku ps:resize web=2x worker=1x
  Resizing web processes to 2X ($0.10/dyno-hour)... done, now 2X
  Resizing worker processes to 1X ($0.05/dyno-hour)... done, now 1X
```

## Development

```sh
git clone https://github.com/heroku/heroku-2x-dynos.git
ln -s ~/.heroku/plugins path/to/heroku-2x-dynos
cd path/to/heroku-2x-dynos
./test.sh
```

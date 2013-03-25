# heroku-dyno-size

A Heroku CLI plugin to resize dynos to a given size.

## Installation

```bash
$ heroku plugins:install https://github.com/heroku/heroku-dyno-size.git
```

## Usage

```
Usage: heroku ps:resize PROCESS1=1X|2X [PROCESS2=1X|2X ...]

 resize dynos to the given size

Examples:

  $ heroku ps:resize web=2X worker=1X
  Resizing web dynos to 2X ($0.10/dyno-hour)... done, now 2X
  Resizing worker dynos to 1X ($0.05/dyno-hour)... done, now 1X
```

## Development

```bash
$ git clone https://github.com/heroku/heroku-dyno-size.git
$ ln -s path/to/heroku-dyno-size ~/.heroku/plugins/heroku-dyno-size
$ cd path/to/heroku-dyno-size
$ ./test.sh
```

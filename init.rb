# require File.expand_path("../lib/ps", __FILE__)

require "heroku/command"
require "heroku/command/ps"

# resize your processes
#
class Heroku::Command::Ps

  # ps
  #
  # display ps sizes
  #
  def index
    puts "ps: coming to a stdout near you"

    if optional_app
      puts "ps for #{optional_app}"
    else
      puts "app-less ps"
    end
  end

  def size
    case args.first
    when "1", "1x", "1X" then hputs "1!"
    when "2", "2x", "2X" then hputs "2!"
    else
      raise(Heroku::Command::CommandFailed, "Usage: heroku ps:size [<1X | 2X>]\nMust specify SIZE to resize.")
    end
  end

private

  def optional_app
    app rescue nil
  end

end

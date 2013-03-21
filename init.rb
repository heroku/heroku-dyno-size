# require File.expand_path("../lib/ps", __FILE__)

require "heroku/command"
require "heroku/command/ps"

# resize your processes
#
class Heroku::Command::Ps


  # ps:size web=SIZE
  #
  # set the size of your web worker
  #
  def size
    if args.empty? || args.size > 1
      styled_array [["web", "2X ($0.10/dyno-hour)"],["worker", "1X ($0.05/dyno-hour)"]]
      exit
    end

    unless args.first =~ /web=/
      raise(Heroku::Command::CommandFailed, "\"web\" is currently the only sizeable type.")
    end

    if optional_app == "one-dyno-app" && args.first =~ /2/
      raise(Heroku::Command::CommandFailed, "Resizing to 2X... failed\n2X is only available for paid apps.\nScale app to 2 or more processes\nExample: heroku ps:scale web=2")
    end

    if optional_app == "free-app-in-app-tiers-experiment" && args.first =~ /2/
      raise(Heroku::Command::CommandFailed, "Resizing to 2X... failed\n2X is only available for paid apps.\nUpgrade app to production\nExample: heroku ")
    end

    size = args.first.split("=").last
    case size
    when "1", "1x", "1X" then hputs "Resizing web to 1X ($0.05/dyno-hour)... done\nRestarting app... done"
    when "2", "2x", "2X" then hputs "Resizing web to 2X ($0.10/dyno-hour)... done\nRestarting app... done"
    else
      raise(Heroku::Command::CommandFailed, "#{size} is not a valid size.\nValid sizes are 1X and 2X.")
    end

  end

private

  def optional_app
    app rescue nil
  end

  def usage_msg
    "Usage: heroku ps:size web=[1X|2X]"
  end

end

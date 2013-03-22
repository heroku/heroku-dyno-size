require "heroku/command"
require "heroku/command/ps"

class Heroku::Command::Ps

  # ps:size PROCESS1=SIZE1 [PROCESS2=SIZE2 ...]
  #
  # resize processes to the given size
  #
  # Examples:
  #
  # $ heroku ps:size web=2x worker=1x
  # Resizing web processes to 2X ($0.10/dyno-hour)... done, now 2X
  # Resizing worker processes to 1X ($0.05/dyno-hour)... done, now 1X
  #
  def size
    app
    dyno_price = 0.05

    if args.empty?
      styled_array [
        ["web:", "2X ($0.10/dyno-hour)"],
        ["worker:", "1X ($0.05/dyno-hour)"],
        ["qcworker:", "1X ($0.05/dyno-hour)"],
        ["clock:", "1X ($0.05/dyno-hour)"],
      ]
      exit
    end

    if app == "app-by-unconfirmed-owner"
      raise(Heroku::Command::CommandFailed, "Resizing web to 2X $(0.10/dyno-hour)... failed\nYou need to confirm your account first.")
    end

    # heroku ps:size web=2x zookeeper=1x
    # Resizing web processes to 2X ($0.10/dyno-hour)... done, now 2X
    # Resizing zookeeper processes... failed
    #  !    No such type as zookeeper

    # heroku ps:size web=2x fudge
    # Resizing web processes to 2X ($0.10/dyno-hour)... done, now 2X

    changes = {}
    args.each do |arg|
      if arg =~ /^([a-zA-Z0-9_]+)(=\d+)([xX]?)$/
        changes[$1] = $2
      end
    end

    if changes.empty?
      error("Usage: heroku ps:size PROCESS1=SIZE1 [PROCESS2=SIZE2 ...]\nMust specify PROCESS and SIZE to resize.")
    end

    changes.keys.sort.each do |process|
      size = changes[process].gsub!("=", "")
      action("Resizing #{process} processes to #{size}X $(#{sprintf("%.2f", dyno_price * size.to_i)}/dyno-hour)") do
        status("now running #{size}X")
      end
    end

  end

end

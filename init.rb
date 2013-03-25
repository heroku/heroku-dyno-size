require "heroku/command"
require "heroku/command/ps"

# resize dynos (dynos, workers)
#
class Heroku::Command::Ps

  # ps
  #
  # list processes for an app
  #
  # Example:
  #
  # $ heroku ps
  # === run: one-off processes (1X - $0.05/dyno-hour)
  # run.1: up for 5m: `bash`
  #
  # === web: `bundle exec thin start -p $PORT` (2X - $0.10/dyno-hour)
  # web.1: created for 30s
  #
  def index
    validate_arguments!
    processes = api.get_ps(app).body

    processes_by_command = Hash.new {|hash,key| hash[key] = []}
    processes.each do |process|
      name    = process["process"].split(".").first
      elapsed = time_ago(Time.now - process['elapsed'])
      size    = [*1..2].sample

      if name == "run"
        key  = "run: one-off processes"
        item = "%s: %s %s: `%s`" % [ process["process"], process["state"], elapsed, process["command"] ]
      else
        key  = "#{name}: `#{process["command"]}` (#{size}X - $#{sprintf("%.2f", 0.05 * size.to_i)}/dyno-hour)"
        item = "%s: %s %s" % [ process["process"], process["state"], elapsed ]
      end

      processes_by_command[key] << item
    end

    processes_by_command.keys.each do |key|
      processes_by_command[key] = processes_by_command[key].sort do |x,y|
        x.match(/\.(\d+):/).captures.first.to_i <=> y.match(/\.(\d+):/).captures.first.to_i
      end
    end

    processes_by_command.keys.sort.each do |key|
      styled_header(key)
      styled_array(processes_by_command[key], :sort => false)
    end
  end

  # ps:resize PROCESS1=1X|2X [PROCESS2=1X|2X ...]
  #
  # resize dynos to the given size
  #
  #Examples:
  #
  #  $ heroku ps:resize web=2X worker=1X
  #  Resizing web dynos to 2X ($0.10/dyno-hour)... done, now 2X
  #  Resizing worker dynos to 1X ($0.05/dyno-hour)... done, now 1X
  #

  def resize
    app
    dyno_price = 0.05

    if app == "app-by-unconfirmed-owner"
      message = [
        "Resizing web dynos to 2X $(0.10/dyno-hour)... failed",
        "You must add a credit card to resize dynos to 2X.",
        "http://heroku.com/billing",
        "",
        "Read more: http://devcenter.heroku.com/articles/dyno-size",
      ]
      raise(Heroku::Command::CommandFailed, message.join("\n"))
    end

    if app == "unavailable-size"
      message = [
        "Resizing web dynos to 3X $(0.15/dyno-hour)... failed",
        "No such size as 3X. Available dyno sizes are 1X and 2X.",
      ]
      raise(Heroku::Command::CommandFailed, message.join("\n"))
    end

    changes = {}
    args.each do |arg|
      if arg =~ /^([a-zA-Z0-9_]+)(=\d+)([xX]?)$/
        changes[$1] = $2
      end
    end

    if changes.empty?
      error("Usage: heroku ps:resize PROCESS1=1X|2X [PROCESS2=1X|2X ...]\nMust specify PROCESS and SIZE to resize.")
    end

    changes.keys.sort.each do |process|
      size = changes[process].gsub!("=", "")
      action("Resizing #{process} dynos to #{size}X $(#{sprintf("%.2f", dyno_price * size.to_i)}/dyno-hour)") do
        status("now running #{size}X")
      end
    end
  end

end

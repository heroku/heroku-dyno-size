require "heroku/command"
require "heroku/command/ps"

class Heroku::Command::Ps

  DYNO_PRICE = 0.05

  # ps
  #
  # list processes for an app
  #
  # Example:
  #
  # $ heroku ps
  # === run (1X): one-off processes
  # run.1: up for 5m: `bash`
  #
  # === web (2X): `bundle exec thin start -p $PORT`
  # web.1: created for 30s
  #
  def index
    validate_arguments!
    formation = {}
    api.get_formation(app).body.each{ |p| formation[p["type"]] = p }
    processes = api.get_ps(app).body

    processes_by_command = Hash.new {|hash,key| hash[key] = []}
    processes.each do |process|
      name    = process["process"].split(".").first
      elapsed = time_ago(Time.now - process['elapsed'])
      size    = process.fetch("size", 1)

      if name == "run"
        key  = "run: one-off processes"
        item = "%s (%sX): %s %s: `%s`" % [ process["process"], size, process["state"], elapsed, process["command"] ]
      else
        key  = "#{name} (#{size}X): `#{process["command"]}`"
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
  # Example:
  #
  # $ heroku ps:resize web=2X worker=1X
  # Resizing web dynos to 2X ($0.10/dyno-hour)... done, now 2X
  # Resizing worker dynos to 1X ($0.05/dyno-hour)... done, now 1X
  #
  def resize
    app
    changes = {}
    args.each do |arg|
      if arg =~ /^([a-zA-Z0-9_]+)=(\d+)([xX]?)$/
        changes[$1] = { "size" => $2.to_i }
      end
    end

    if changes.empty?
      message = [
          "Usage: heroku ps:resize PROCESS1=1X|2X [PROCESS2=1X|2X ...]",
          "Must specify PROCESS and SIZE to resize."
      ]
      error(message.join("\n"))
    end

    action("Resizing dynos and restarting specified processes") do
      api.put_formation(app, json_encode(changes))
    end
    changes.each do |type, options|
      size  = options["size"]
      price = sprintf("%.2f", 0.05 * size)
      display "#{type} dynos now #{size}X ($#{price}/dyno-hour)"
    end
  end

  alias_command "resize", "ps:resize"


private

  def price_for_size size
    sprintf("%.2f", size * DYNO_PRICE)
  end

end

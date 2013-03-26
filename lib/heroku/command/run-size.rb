require "heroku/command"
require "heroku/command/run"

class Heroku::Command::Run

  # run COMMAND
  #
  # run an attached process
  #
  # -s, --size SIZE      # specifiy dyno size for process
  #
  # Example:
  #
  # $ heroku run bash
  # Running `bash` attached to terminal... up, run.1
  # ~ $
  #
  def index
    command = args.join(" ")
    error("Usage: heroku run COMMAND") if command.empty?
    run_attached(command)
  end

  # run:detached COMMAND
  #
  # run a detached process, where output is sent to your logs
  #
  # -s, --size SIZE      # specifiy dyno size for process
  # -t, --tail           # stream logs for the process
  #
  #Example:
  #
  # $ heroku run:detached ls
  # Running `ls` detached... up, run.1
  # Use `heroku logs -p run.1` to view the output.
  #
  def detached
    command = args.join(" ")
    error("Usage: heroku run COMMAND") if command.empty?
    
    opts = {
      :attach => false
    }
    opts[:size] = get_size if options[:size]

    app_name = app
    process_data = action("Running `#{command}` detached", :success => "up") do
      process_data = api.post_ps(app_name, command, opts).body
      status(process_data['process'])
      process_data
    end
    display("Use `heroku logs -p #{process_data['process']}` to view the output.")
  end

protected

  def run_attached(command)
    opts = {
      :attach => true,
      :ps_env => get_terminal_environment
    }
    opts[:size] = get_size if options[:size]

    app_name = app
    process_data = action("Running `#{command}` attached to terminal", :success => "up") do
      process_data = api.post_ps(app_name, command, opts).body
      status(process_data["process"])
      process_data
    end
    rendezvous_session(process_data["rendezvous_url"])
  end

  def get_size
    size = options[:size].to_i
    error("Must specify SIZE in format '1X' or '2X'.") if size <= 0
    size
  end

end
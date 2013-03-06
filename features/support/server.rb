require 'background_process'

class ApiServer
  TEST_SERVER_ENVIRONMENT = 'cucumber'
  PORT = '54101'
  REPO_URL = 'git@github.com:thinkcodelearn/solweb.git'

  attr :server_path

  def initialize
    @server_path = File.expand_path(File.dirname(__FILE__) + '/../../tmp/solweb')
    @show_web_server_output = true
  end

  def wrap(command)
    cmd = %{bash -lc 'cd "#{server_path}" && #{command}'}
    puts cmd
    cmd
  end

  def server(command)
    Bundler.with_clean_env do
      BackgroundProcess.run(wrap(command))
    end
  end

  def run(command)
    Bundler.with_clean_env do
      system wrap(command)
    end
  end

  def start_server
    install_server
    @server = server("RACK_ENV=#{TEST_SERVER_ENVIRONMENT} bundle exec rackup -p #{PORT}")
    @server.detect {|line| out << line; line =~ /#start/ }
  end

  def get_code
    code_parent_path = File.expand_path(server_path + "/../")
    `mkdir -p "#{code_parent_path}"`
    cmd = %{cd "#{code_parent_path}" && git clone #{REPO_URL}}
    puts cmd
    `#{cmd}`
  end

  def install_server
    if (File.exists?(server_path))
      unless run("git pull --rebase")
        puts "CANNOT GET LATEST CODE!"
        exit 1
      end
      stop!
    else
      get_code
    end
    run("bundle install")
  end

  def out
    @out ||= []
  end

  def stop!
    puts "STOPPING SERVER"
    cmd = %{ps ax | grep -e "54101" | grep -v grep | awk '{ print $1; }' | xargs kill -trap}
    puts cmd
    `#{cmd}`
  end

  def stop_server
    if (@server && @server.running?)
      stop!
      # only reliable way I've found to kill it, as it's in a subshell
      out << @server.stdout.read
      out << @server.stderr.read
    end
    puts "\nTest server output:\n" + out.join if @show_web_server_output
  end
end


@api = ApiServer.new
@api.start_server

at_exit do
  @api.stop_server
end

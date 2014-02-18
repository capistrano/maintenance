namespace :maintenance do
  desc "Turn on maintenance mode"
  task :enable do
    on roles(:web) do
      require 'erb'
      on_rollback { run "rm -f #{shared_path}/system/#{maintenance_basename}.html" }

      reason = ENV['REASON']
      deadline = ENV['UNTIL']

      template = File.read(maintenance_template_path)
      result = ERB.new(template).result(binding)

      put result, "#{shared_path}/system/#{maintenance_basename}.html", :mode => 0644
    end
  end

  desc "Turn off maintenance mode"
  task :disable do
    on roles(:web) do
      run "rm -f #{shared_path}/system/#{maintenance_basename}.html"
    end
  end
end

namespace :maintenance do
  desc "Turn on maintenance mode"
  task :enable do
    require 'erb'

    on roles(:web) do
      reason = ENV['REASON']
      deadline = ENV['UNTIL']

      template = ERB.new(File.read(fetch(:maintenance_template_path)))
      stream = StringIO.new(template.result(binding))

      upload! stream, "#{shared_path}/system/#{fetch(:maintenance_basename, 'maintenance')}.html"
    end
  end

  desc "Turn off maintenance mode"
  task :disable do
    on roles(:web) do
      execute :rm, "-f", "#{shared_path}/system/#{fetch(:maintenance_basename, 'maintenance')}.html"
    end
  end
end

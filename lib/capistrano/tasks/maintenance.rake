namespace :maintenance do
  desc "Turn on maintenance mode"
  task :enable do
    on roles(:web) do
      require 'erb'

      reason = ENV['REASON']
      deadline = ENV['UNTIL']

      default_template = File.join(File.expand_path('../../templates', __FILE__), 'maintenance.html.erb')
      template = fetch(:maintenance_template_path, default_template)
      result = ERB.new(File.read(template)).result(binding)

      rendered_path = "#{shared_path}/public/system/#{fetch(:maintenance_basename, 'maintenance')}.html"
      upload!(StringIO.new(result), rendered_path)
      execute "chmod 644 #{rendered_path}"
    end
  end

  desc "Turn off maintenance mode"
  task :disable do
    on roles(:web) do
      execute "rm -f #{shared_path}/public/system/#{fetch(:maintenance_basename, 'maintenance')}.html"
    end
  end
end

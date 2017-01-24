namespace :maintenance do
  desc "Turn on maintenance mode"
  task :enable do
    on fetch(:maintenance_roles, roles(:web)) do
      require 'erb'

      reason = ENV['REASON']
      deadline = ENV['UNTIL']

      default_template = File.join(File.expand_path('../../templates', __FILE__), 'maintenance.html.erb')
      template = fetch(:maintenance_template_path, default_template)
      result = ERB.new(File.read(template)).result(binding)

      rendered_path = "#{shared_path}/public/system/"
      rendered_name = "#{fetch(:maintenance_basename, 'maintenance')}.html"

      if test "[ ! -d #{rendered_path} ]"
        info 'Creating missing directories.'
        execute :mkdir, '-pv', rendered_path
      end

      upload!(StringIO.new(result), rendered_path + rendered_name)
      execute "chmod 644 #{rendered_path + rendered_name}"
    end
  end

  desc "Turn off maintenance mode"
  task :disable do
    on fetch(:maintenance_roles, roles(:web)) do
      execute "rm -f #{shared_path}/public/system/#{fetch(:maintenance_basename, 'maintenance')}.html"
    end
  end
end

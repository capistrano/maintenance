namespace :maintenance do
  def template_basename(template_path)
    File.basename(template_path).gsub(/\.erb$/, '')
  end

  desc "Turn on maintenance mode"
  task :enable do
    on fetch(:maintenance_roles) do
      require 'erb'

      rendered_dirname = fetch(:maintenance_dirname)

      if test "[ ! -d #{rendered_dirname} ]"
        info 'Creating missing directories.'
        execute :mkdir, '-pv', rendered_dirname
      end

      reason = ENV.fetch('REASON', 'maintenance')
      start = Time.now.strftime("%F %H:%M %Z")
      deadline = ENV.fetch('UNTIL', 'shortly')

      fetch(:maintenance_templates).each do |template_path|
        result = ERB.new(File.read(template_path)).result(binding)

        rendered_path = "#{rendered_dirname}/#{template_basename(template_path)}"
        upload! StringIO.new(result), rendered_path
        execute "chmod 644 #{rendered_path}"
      end
    end
  end

  desc "Turn off maintenance mode"
  task :disable do
    on fetch(:maintenance_roles) do
      fetch(:maintenance_templates).each do |template_path|
        execute "rm -f #{fetch(:maintenance_dirname)}/#{template_basename(template_path)}"
      end
    end
  end
end

namespace :load do
  task :defaults do
    set_if_empty :maintenance_roles, -> { roles(:web) }
    set_if_empty :maintenance_templates, -> do
      [
        # Backwards compatibility with old :maintenance_template_path variable
        fetch(:maintenance_template_path, File.expand_path('../../templates/maintenance.html.erb', __FILE__))
      ]
    end
    set_if_empty :maintenance_dirname, -> { "#{shared_path}/public/system" }
  end
end

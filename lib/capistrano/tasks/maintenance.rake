namespace :maintenance do
  desc "Turn on maintenance mode"
  task :enable do
    on fetch(:maintenance_roles) do
      require 'erb'

      def inline_image_src(image)
        file = File.open(image, "rb").read
        b64 = Base64.encode64(file)
        extension = File.extname(image)[1..-1]
        "data:image/#{extension};base64,#{b64}"
      end

      reason = ENV['REASON']
      deadline = ENV['UNTIL']

      result = ERB.new(File.read(fetch(:maintenance_template_path))).result(binding)

      rendered_path = fetch(:maintenance_dirname)
      rendered_name = "#{fetch(:maintenance_basename)}.html"

      if test "[ ! -d #{rendered_path} ]"
        info 'Creating missing directories.'
        execute :mkdir, '-pv', rendered_path
      end

      rendered_fullpath = "#{rendered_path}/#{rendered_name}"
      upload! StringIO.new(result), rendered_fullpath
      execute "chmod 644 #{rendered_fullpath}"
    end
  end

  desc "Turn off maintenance mode"
  task :disable do
    on fetch(:maintenance_roles) do
      execute "rm -f #{fetch(:maintenance_dirname)}/#{fetch(:maintenance_basename)}.html"
    end
  end
end

namespace :load do
  task :defaults do
    set_if_empty :maintenance_roles, -> { roles(:web) }
    set_if_empty :maintenance_template_path,
      File.join(File.expand_path('../../templates', __FILE__), 'maintenance.html.erb')
    set_if_empty :maintenance_dirname, -> { "#{shared_path}/public/system" }
    set_if_empty :maintenance_basename, 'maintenance'
  end
end

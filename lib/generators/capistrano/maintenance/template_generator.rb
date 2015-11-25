module Capistrano
  module Maintenance
    module Generators
      class TemplateGenerator < Rails::Generators::Base

        desc "Create local maintenance.html.erb (database.yml on the server) template file for customization"
        source_root File.expand_path('../../../../capistrano/templates', __FILE__)
        argument :templates_path, type: :string,
          default: "config/deploy/templates",
          banner: "path to templates"

        def copy_template
          copy_file "maintenance.html.erb", "#{templates_path}/maintenance.html.erb"
        end

      end
    end
  end
end

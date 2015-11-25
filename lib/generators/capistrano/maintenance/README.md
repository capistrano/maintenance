To create a local maintenance.html.erb template in a default path "config/deploy/templates" type this in your shell:

bundle exec rails generate capistrano:maintenance:template

To override the default path:

bundle exec rails generate capistrano:maintenance:template "config/templates"

Add the template path to deploy.rb:

set :maintenance_template_path, 'config/deploy/templates/maintenance.html.erb' # or your custom path

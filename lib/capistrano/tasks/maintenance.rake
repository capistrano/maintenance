namespace :maintenance do

  task :enable do
    on roles(:web) do
      require 'erb'
      # Do we really need it? I see situations where removing maintenance page on rollback is wrong thing.
      # on_rollback { execute "rm -f #{release_path}/public/#{fetch(:maintenance_basename, 'maintenance')}.html" }

      reason = ENV['REASON']
      deadline = ENV['UNTIL']

      template = File.read(fetch(:maintenance_template_path))
      result = ERB.new(template).result(binding)

      upload! StringIO.new(result), "#{release_path}/public/#{fetch(:maintenance_basename, 'maintenance')}.html", :mode => 0644
    end
  end

  task :disable do
    on roles(:web) do
      execute "rm -f #{release_path}/public/#{fetch(:maintenance_basename, 'maintenance')}.html"
    end
  end
end

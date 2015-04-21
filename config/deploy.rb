require 'capistrano/bundler'
set :application,      'diskotappi'
set :deploy_to,        '/home/diskotappi'
set :ruby_version,     "#{File.read('./.ruby-version').strip}"
set :ruby_gemset,      "#{File.read('./.ruby-gemset').strip}"
set :rvm_ruby_version, "#{fetch(:ruby_version)}@#{fetch(:ruby_gemset)}"

set :ssh_options, { forward_agent: false }

namespace :config do
  desc 'Deploy config files from shared/config to current release'
  task :deploy do
    on roles(:app) do
      fetch(:config_files).each do |f|
        execute :cp, "/home/diskotappi/shared/config/#{f}", "#{release_path}/config/"
      end
    end
  end
end

namespace :supervisord do
  desc 'Reload supervisord configuration'
  task :reload do
    on roles(:app) do
      execute 'supervisorctl reread &>/dev/null'
    end
  end

  desc 'Restart workers'
  task :restart => [:reload] do
    on roles(:app) do
      execute 'supervisorctl restart all &>/dev/null'
    end
  end
end

namespace :deploy do
  desc "Displays the commits since your last deploy."
  task pending: :'git:update' do
    on roles(:notification) do |h|
      within repo_path do
        from = capture(:cat, '../current/REVISION')
        log = capture(:git, '--no-pager', :log, "#{from}..HEAD --pretty=format:'%Cgreen%h%Creset %Cblue[%cr]%Creset (%an) %s'")
        if log.lines.count > 1
          puts log
        else
          puts "#{fetch(:stage)} is up-to-date"
        end
      end
    end
  end

  desc "Writes REVISION file to the release folder"
  task :mark_revision do
    on roles :app do
      within repo_path do
        execute(:echo, '`git log -1 --pretty=format:%H` >> ../current/REVISION')
      end
    end
  end

  after  :updated,    'config:deploy'
  after  :publishing, 'deploy:mark_revision'
  after  :publishing, 'deploy:restart'
  before :finishing,  'supervisord:restart'
  after  :finishing,  'deploy:cleanup'
end

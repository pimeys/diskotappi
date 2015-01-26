set :stage,        :production
set :repo_url,     'https://github.com/pimeys/diskotappi.git'
set :branch,       'master'
set :config_files, ['database.yml', 'diskotappi.yml']
set :megahal_libs, ['ruby/Hal.so', 'megahal.h', 'ruby/megahal.o', 'ruby/ruby-interface.o']

server 'irc.entropy.fi', user: 'diskotappi', roles: %w{app}

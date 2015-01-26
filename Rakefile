namespace :bot do
  namespace :schema do
    desc 'Load database schema'
    task :load do
      require './lib/database'

      Database.connection.create_table! :urllog do
        primary_key :id

        String :url, size: 2 ** 10
        DateTime :entrydate
        String :nick
        String :userhost
        Text :comment
        String :channel

        index :url
      end
    end
  end

  desc  'Build the MegaHAL library'
  task :build_hal do
    Dir.chdir('./ext/hal') do
      %x( make clean rubymodule )
      Dir.chdir('./ruby') do
        %x( cp Hal.so megahal.h megahal.o ruby-interface.o ../../../lib/megahal )
      end
      %x( make clean )
    end
  end
end

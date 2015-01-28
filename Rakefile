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
end

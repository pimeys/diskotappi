require 'sequel'
require 'yaml'

module Database
  extend self

  def connection
    @connection ||= Sequel.connect(connection_string, max_connections: 5)
  end

  private

  def connection_string
    config = YAML.load_file('./config/database.yml')

    "#{config['adapter']}://" +
      "#{config['username']}:" +
      "#{config['password']}@" +
      "#{config['hostname']}:" +
      "#{config['port']}/" +
      "#{config['schema']}"
  end
end

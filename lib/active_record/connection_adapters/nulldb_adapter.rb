require 'logger'
require 'stringio'
require 'active_record/connection_adapters/abstract_adapter'

class ActiveRecord::Base
  def self.nulldb_connection(config)
    ActiveRecord::ConnectionAdapters::NullDB.new
  end
end

class ActiveRecord::ConnectionAdapters::NullDB <
    ActiveRecord::ConnectionAdapters::AbstractAdapter

  def self.execution_log
    (@@execution_log ||= [])
  end

  def initialize
    @log            = StringIO.new
    @logger         = Logger.new(@log)
    @tables         = {}
    @last_unique_id = 0
    super(nil, @logger)
  end

  def create_table(table_name, options = {})
    table_definition = ActiveRecord::ConnectionAdapters::TableDefinition.new(self)
    unless options[:id] == false
      table_definition.primary_key(options[:primary_key] || "id")
    end

    yield table_definition

    @tables[table_name] = table_definition
  end

  def columns(table_name, name = nil)
    @tables[table_name].columns.map do |col_def|
      ActiveRecord::ConnectionAdapters::Column.new(col_def.name.to_s,
                                                   col_def.default,
                                                   col_def.type,
                                                   col_def.null)
    end
  end

  def execute(statement, name = nil)
    self.class.execution_log << statement
  end

  def insert(statement, name, primary_key, object_id, *args)
    execute(statement, name)
    object_id || next_unique_id
  end

  private

  def next_unique_id
    @last_unique_id += 1
  end
end

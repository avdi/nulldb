require 'logger'
require 'stringio'
require 'singleton'
require 'active_record/connection_adapters/abstract_adapter'

class ActiveRecord::Base
  # Instantiate a new NullDB connection.  Used by ActiveRecord internally.
  def self.nulldb_connection(config)
    ActiveRecord::ConnectionAdapters::NullDB.new(config)
  end
end

class ActiveRecord::ConnectionAdapters::NullDB <
    ActiveRecord::ConnectionAdapters::AbstractAdapter

  TableDefinition = ActiveRecord::ConnectionAdapters::TableDefinition

  # A convenience method for integratinginto RSpec.  See README for example of
  # use.
  def self.insinuate_into_spec(config)
    config.before :all do
      ActiveRecord::Base.establish_connection(:adapter => :nulldb)
    end

    config.after :all do
      ActiveRecord::Base.establish_connection(:test)
    end
  end

  def self.execution_log
    (@@execution_log ||= [])
  end

  # Recognized options:
  #
  # [+:schema+] path to the schema file, relative to RAILS_ROOT
  def initialize(config={})
    @log            = StringIO.new
    @logger         = Logger.new(@log)
    @last_unique_id = 0
    @tables         = {'schema_info' =>  TableDefinition.new(nil)}
    @schema_path    = config.fetch(:schema){ "db/schema.rb" }
    super(nil, @logger)
  end

  def adapter_name
    "NullDB"
  end

  def supports_migrations?
    true
  end

  def create_table(table_name, options = {})
    table_definition = ActiveRecord::ConnectionAdapters::TableDefinition.new(self)
    unless options[:id] == false
      table_definition.primary_key(options[:primary_key] || "id")
    end

    yield table_definition

    @tables[table_name] = table_definition
  end

  def tables
    @tables.keys.map(&:to_s)
  end

  def columns(table_name, name = nil)
    if @tables.size <= 1
      ActiveRecord::Migration.verbose = false
      Kernel.load(File.join(RAILS_ROOT, @schema_path))
    end
    table = @tables[table_name]
    table.columns.map do |col_def|
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

  def select(statement, name)
    []
  end

  private

  def next_unique_id
    @last_unique_id += 1
  end
end

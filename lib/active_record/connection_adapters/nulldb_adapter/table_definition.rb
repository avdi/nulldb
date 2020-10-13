class ActiveRecord::ConnectionAdapters::NullDBAdapter

  class TableDefinition < ActiveRecord::ConnectionAdapters::TableDefinition
    attr_accessor :name
    alias_method :citext, :text
    alias_method :interval, :text
    alias_method :geometry, :text
    alias_method :jsonb, :json if method_defined? :json
  end
end

class ActiveRecord::ConnectionAdapters::NullDBAdapter

  class EmptyResult < Array
    attr_reader :column_types
    
    def bind_column_meta(columns)
      @columns = columns
      return if columns.empty?

      @column_types = begin
        names = columns.map(&:name)
        Hash[names.zip(table_def.columns)]
      end
    end

    def columns
      @columns ||= []
    end

    def column_types
      @column_types ||= {}
    end

    def cast_values(type_overrides = nil)
      rows
    end

    def rows
      []
    end

    def >(num)
      rows.size > num
    end

  end

end

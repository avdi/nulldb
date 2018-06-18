class ActiveRecord::ConnectionAdapters::NullDBAdapter

  class EmptyResult < Array
    attr_writer :columns
    
    def rows
      []
    end

    def columns
      @columns ||= []
    end

    def cast_values(type_overrides = nil)
      rows
    end

    def >(num)
      rows.size > num
    end

    alias_method :column_types, :columns
  end

end

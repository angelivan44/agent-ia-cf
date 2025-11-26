module McpTools
  class BaseTool
    def self.name
      raise NotImplementedError, "Subclass must implement name"
    end

    def self.description
      raise NotImplementedError, "Subclass must implement description"
    end

    def self.input_schema
      raise NotImplementedError, "Subclass must implement input_schema"
    end

    def self.execute(args = {})
      raise NotImplementedError, "Subclass must implement execute"
    end
  end
end


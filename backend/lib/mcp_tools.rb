require 'mcp'
require_relative 'mcp_tools/base_tool'

module McpTools
  TOOLS_DIR = File.join(__dir__, 'mcp_tools')

  def self.load_tools
    return if @tools_loaded
    
    Dir[File.join(TOOLS_DIR, '*_tool.rb')].sort.each do |file|
      require file
    end
    
    @tools_loaded = true
  end

  def self.available_tools
    load_tools
    
    ObjectSpace.each_object(Class).select do |klass|
      klass < BaseTool && klass != BaseTool
    end
  end

  def self.server
    @server ||= begin
      server = MCP::Server.new(
        name: 'rails-mcp-server',
        version: '1.0.0'
      )

      available_tools.each do |tool_class|
        server.define_tool(
          name: tool_class.name,
          description: tool_class.description
        ) do |args, server_context:|
          result = tool_class.execute(args)
          MCP::Result.new(
            content: [
              MCP::Content::Text.new(text: result.to_json)
            ]
          )
        end
      end

      server
    end
  end

  def self.call_tool(tool_name, arguments = {})
    tool_name_str = tool_name.to_s
    tool_class = available_tools.find { |t| t.name == tool_name_str }
    
    unless tool_class
      Rails.logger.error("Tool '#{tool_name_str}' not found. Available: #{available_tools.map(&:name).inspect}")
      return { error: "Tool #{tool_name_str} not found", isError: true }
    end

    begin
      result = tool_class.execute(arguments)
      
      if result.is_a?(Hash)
        {
          content: [result.to_json],
          isError: false
        }
      else
        {
          content: [result.to_s],
          isError: false
        }
      end
    rescue => e
      Rails.logger.error("Error executing tool #{tool_name_str}: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      {
        error: e.message,
        isError: true
      }
    end
  end

  def self.list_tools
    available_tools.map do |tool_class|
      {
        name: tool_class.name,
        description: tool_class.description,
        input_schema: tool_class.input_schema
      }
    end
  end
end

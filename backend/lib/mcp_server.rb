require_relative '../config/environment'
require_relative 'mcp_tools'

server = McpTools.server
server.run

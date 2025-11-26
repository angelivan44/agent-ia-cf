require 'mcp'

class GetUserInfoTool
  include MCP::Tool

  define_tool(
    name: 'get_user_info',
    description: 'Obtiene información de un usuario por su ID'
  ) do |args, server_context:|
    user_id = args['user_id']
    user = User.find_by(id: user_id)

    if user
      result = {
        id: user.id,
        name: user.name,
        email: user.email,
        national_id: user.national_id,
        birth_date: user.birth_date&.to_s,
        age: user.age
      }
      MCP::Result.new(
        content: [
          MCP::Content::Text.new(text: result.to_json)
        ]
      )
    else
      MCP::Result.new(
        content: [
          MCP::Content::Text.new(text: "Usuario con ID #{user_id} no encontrado")
        ],
        isError: true
      )
    end
  end

  define_input_schema(
    type: 'object',
    properties: {
      user_id: {
        type: 'integer',
        description: 'El ID del usuario'
      }
    },
    required: ['user_id']
  )
end



server = MCP::Server.new(
  name: 'rails-mcp-server',
  version: '1.0.0',
  tools: [
    GetUserInfoTool,
  ]
)

server.run

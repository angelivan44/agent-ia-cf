module McpTools
  class HelloWorldTool < BaseTool
    def self.name
      'get_hello_world'
    end

    def self.description
      'Usa esta herramienta cuando el usuario haga un saludo, se presente, o diga hola. Genera un saludo personalizado con el nombre de la persona. Si el usuario menciona su nombre, extráelo y úsalo. Si no hay nombre, usa "Usuario" por defecto.'
    end

    def self.input_schema
      {
        type: 'object',
        properties: {
          name: {
            type: 'string',
            description: 'El nombre de la persona a saludar'
          }
        },
        required: []
      }
    end

    def self.execute(args = {})
      name = args['name'] || args[:name] || 'Usuario'
      { message: "Hola #{name}" }
    end
  end
end


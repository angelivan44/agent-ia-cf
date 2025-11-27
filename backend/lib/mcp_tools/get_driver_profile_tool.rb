module McpTools
  class GetDriverProfileTool < BaseTool
    def self.name
      'get_driver_profile'
    end

    def self.description
      'Obtiene información fecha de nacimiento + listado de infracciones del conductor. Requiere el número de identificación del conductor.'
    end

    def self.input_schema
      {
        type: 'object',
        properties: {
          national_id: {
            type: 'string',
            description: 'Número de identificación del conductor',
          }
        },
        required: ['national_id']
      }
    end

    def self.execute(args = {})
      national_id = args['national_id'] || args[:national_id]
      user = User.find_by(national_id: national_id)

      {
        found: true,
        birth_date: user.birth_date&.to_s,
        infractions: user.infractions
      }
    end

    
  end
end


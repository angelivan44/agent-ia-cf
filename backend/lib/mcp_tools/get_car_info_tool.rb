module McpTools
  class GetCarInfoTool < BaseTool
    def self.name
      'get_car_info'
    end

    def self.description
      'Obtiene año de fabricación, modelo del auto, identificador nacional del dueño. Requiere el número de placa del vehículo.'
    end

    def self.input_schema
      {
        type: 'object',
        properties: {
          plate_number: {
            type: 'string',
            description: 'Número de placa del vehículo',
          }
        },
        required: ['plate_number']
      }
    end

    def self.execute(args = {})
      plate_number = args['plate_number'] || args[:plate_number]
      vehicle = Vehicle.find_by(plate_number: plate_number)

      {
        found: true,
        year: vehicle.year&.to_s,
        model: vehicle.model,
        owner_national_id: vehicle.user.national_id
      }
    end
  end
end


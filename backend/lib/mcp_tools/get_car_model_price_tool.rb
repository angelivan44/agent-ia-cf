module McpTools
  class GetCarModelPriceTool < BaseTool
    def self.name
      'get_car_model_price'
    end

    def self.description
      'Obtiene modelo del auto, precio del auto en la moneda del vehículo. Requiere el número de placa del vehículo.'
    end

    def self.input_schema
      {
        type: 'object',
        properties: {
          model: {
            type: 'string',
            description: 'Modelo del vehículo',
          }
        },
        required: ['model']
      }
    end

    def self.execute(args = {})
      model = args['model'] || args[:model]
      vehicle = Vehicle.find_by(model: model)

      {
        found: true,
        year: vehicle.year&.to_s,
        mode: 'ToDo',
        owner_national_id: vehicle.user.national_id
      }
    end
  end
end


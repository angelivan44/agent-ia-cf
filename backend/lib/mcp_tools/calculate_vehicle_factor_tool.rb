module McpTools
  class CalculateVehicleFactorTool < BaseTool
    def self.name
      'calculate_vehicle_factor'
    end

    def self.description
      'Calcula el factor del vehículo. Requiere año de fabricación, precio del vehículo'
    end

    def self.input_schema
      {
        type: 'object',
        properties: {
          year: {
            type: 'string',
            description: 'Año de fabricación del vehículo como número de 4 dígitos. Ejemplos válidos: "1980", "2020", "2015". NO uses timestamps ni números grandes.',
          },
          price: {
            type: 'number',
            description: 'Precio del vehículo en números',
          }
        },
        required: ['year', 'price']
      }
    end

    def self.execute(args = {})
      year = args['year'] || args[:year]
      price = args['price'] || args[:price]


      vehicle_factor = Vehicle.calculate_vehicle_factor(year, price)
      {
        vehicle_factor: vehicle_factor.to_f
      }
    end
  end
end


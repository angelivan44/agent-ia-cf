module McpTools
  class GetCarModelPriceTool < BaseTool
    def self.name
      'get_car_model_price'
    end

    def self.description
      'Obtiene modelo del auto, precio del auto en la moneda del vehículo. Requiere el modelo del vehículo.'
    end

    def self.input_schema
      {
        type: 'object',
        properties: {
          model: {
            type: 'string',
            description: 'Modelo del vehículo',
            enum: ['Toyota', 'Ford', 'Chevrolet', 'Honda', 'Mercedes', 'Nissan']
          }
        },
        required: ['model']
      }
    end

    def self.execute(args = {})
      model = args['model'] || args[:model]
      response = ApiModelPriceService.get_model_price(model)
      {
        found: true,
        price: response
      }
    end
  end
end


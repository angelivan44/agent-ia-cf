module McpTools
  class CalculateInsurancePremiumTool < BaseTool
    def self.name
      'calculate_insurance_premium'
    end

    def self.description
      'Calcula el precio de la prima de seguro en unidad monetaria smartcars. Requiere factor de riesgo, factor del vehículo'
    end

    def self.input_schema
      {
        type: 'object',
        properties: {
          risk_factor: {
            type: 'string',
            description: 'Factor de riesgo del individuo',
          },
          vehicle_factor: {
            type: 'number',
            description: 'Factor del vehículo',
          }
        },
        required: ['risk_factor', 'vehicle_factor']
      }
    end

    def self.execute(args = {})
      risk_factor = args['risk_factor'] || args[:risk_factor]
      vehicle_factor = args['vehicle_factor'] || args[:vehicle_factor]

      insurance_premium = InsuranceRequest.calculate_insurance_premium(risk_factor, vehicle_factor)
      {
        insurance_premium: insurance_premium.to_f
      }
    end
  end
end


module McpTools
  class CalculateRiskTool < BaseTool
    def self.name
      'calculate_risk'
    end

    def self.description
      'Calcula el riesgo del individuo. Requiere edad, numero de infracciones'
    end

    def self.input_schema
      {
        type: 'object',
        properties: {
          age: {
            type: 'integer',
            description: 'Edad del individuo',
          },
          infractions: {
            type: 'integer',
            description: 'Número de infracciones del individuo',
          }
        },
        required: ['age', 'infractions']
      }
    end

    def self.execute(args = {})
      age = args['age'] || args[:age]
      infractions = args['infractions'] || args[:infractions]
      risk = User.calculate_risk(age, infractions)
      {
        risk: risk.to_f
      }
    end
  end
end


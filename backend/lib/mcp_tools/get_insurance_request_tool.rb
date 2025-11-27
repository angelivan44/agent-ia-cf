module McpTools
  class GetInsuranceRequestTool < BaseTool
    def self.name
      'get_insurance_request'
    end

    def self.description
      'Obtiene información básica de una solicitud de seguro. Busca por correo electrónico del solicitante o por ID de la solicitud.'
    end

    def self.input_schema
      {
        type: 'object',
        properties: {
          email: {
            type: 'string',
            description: 'Correo electrónico del solicitante'
          },
          id: {
            type: 'integer',
            description: 'ID de la solicitud de seguro'
          }
        },
        required: []
      }
    end

    def self.execute(args = {})
      email = args['email'] || args[:email]
      id = args['id'] || args[:id]

      if id.present?
        request = InsuranceRequest.find_by(code: id)
      elsif email.present?
        request = InsuranceRequest.find_by(email: email)
      else
        return {
          error: 'Debes proporcionar un email o un ID para buscar la solicitud',
          found: false
        }
      end

      if request.nil?
        return {
          error: 'Solicitud no encontrada',
          found: false
        }
      end

      validation_errors = request.validation_errors

      {
        found: true,
        id: request.id,
        email: request.email,
        full_name: request.full_name,
        national_id: request.national_id,
        vehicle_plate_number: request.vehicle_plate_number,
        birth_date: request.birth_date&.to_s,
        created_at: request.created_at.to_s,
        user_id: request.user_id,
        vehicle_id: request.vehicle_id,
        valid: request.valid?,
        validation_errors: validation_errors
      }
    end
  end
end


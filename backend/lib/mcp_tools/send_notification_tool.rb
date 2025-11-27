module McpTools
  class SendNotificationTool < BaseTool
    def self.name
      'send_notification'
    end

    def self.description
      'Envía una notificación a un usuario. Requiere email del usuario, mensaje de notificación, en el mensaje debe incluir los motivos porque fueron rechazados los seguros, o si es satisfactorio el proceso'
    end

    def self.input_schema
      {
        type: 'object',
        properties: {
          email: {
            type: 'string',
            description: 'Email del usuario',
          },
          message: {
            type: 'string',
            description: 'Mensaje de notificación',
          }
        },
        required: ['email', 'message']
      }
    end

    def self.execute(args = {})
      email = args['email'] || args[:email]
      message = args['message'] || args[:message]

      NotificationMailer.notification_email(email, message).deliver_later
      {
        success: true
      }
    end
  end
end


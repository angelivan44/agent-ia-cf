class Api::AiAgentController < ApplicationController
  def ai_agent
    prompt = params[:prompt]
    tools = McpTools.list_tools
    
    system_instruction = <<~INSTRUCTION
      Eres un asistente inteligente. SIEMPRE debes usar una de las herramientas MCP disponibles.
      
      Revisa las herramientas disponibles y elige las más adecuadas según el mensaje del usuario.
      Puedes usar múltiples herramientas en secuencia si es necesario para obtener toda la información requerida.
      Extrae los parámetros necesarios del mensaje y ejecuta la herramienta.
      
      IMPORTANTE:
      - NO ejecutes la misma herramienta dos veces con los mismos argumentos
      - Si ya ejecutaste una herramienta y obtuviste la información, usa otra herramienta diferente o responde con la información
      - Revisa el historial de herramientas ejecutadas antes de ejecutar una nueva
      - Cuando tengas toda la información necesaria, responde directamente sin ejecutar más herramientas
      
      Luego integra todos los resultados en tu respuesta de forma natural.
      Si no hay suficiente información, indica al usuario que necesita más información.
    INSTRUCTION

    executed_tools = []
    max_iterations = 10
    iteration = 0

    loop do
      break if iteration >= max_iterations

      if iteration == 0
        gemini_response = GeminiApiService.chat_with_tools(prompt, tools, system_instruction: system_instruction)
      else
        conversation_context = build_conversation_context(prompt, executed_tools)
        
        gemini_response = GeminiApiService.chat_with_tools_and_history(
          conversation_context,
          executed_tools,
          tools: tools,
          system_instruction: system_instruction
        )
      end

      if gemini_response[:wants_tool]
        tool_name = gemini_response[:tool_name]
        tool_arguments = gemini_response[:arguments] || {}
        
        if tool_already_executed?(executed_tools, tool_name, tool_arguments)
          Rails.logger.warn("Tool #{tool_name} already executed with same arguments, forcing response")
          final_response = "Ya he ejecutado la herramienta #{tool_name} con estos argumentos. Tengo la información necesaria."
          
          render json: { 
            message: final_response, 
            tools_used: executed_tools.map { |t| t[:name] },
            tools_details: executed_tools,
            available_tools: tools.map { |t| t[:name] },
            warning: "Se detectó repetición de herramienta"
          }
          return
        end
        
        tool_result = McpTools.call_tool(tool_name, tool_arguments)
        
        if tool_result[:isError]
          render json: { 
            error: tool_result[:error] || 'Error ejecutando herramienta',
            tool_attempted: tool_name,
            executed_tools: executed_tools
          }, status: :unprocessable_entity
          return
        end

        function_result = tool_result[:content].first
        parsed_result = begin
          JSON.parse(function_result)
        rescue
          { result: function_result }
        end

        executed_tools << {
          name: tool_name,
          arguments: tool_arguments,
          result: parsed_result
        }

        iteration += 1
      else
        final_response = gemini_response[:text]
        
        render json: { 
          message: final_response, 
          tools_used: executed_tools.map { |t| t[:name] },
          tools_details: executed_tools,
          available_tools: tools.map { |t| t[:name] }
        }
        return
      end
    end

    render json: { 
      error: 'Se alcanzó el límite máximo de iteraciones',
      tools_used: executed_tools.map { |t| t[:name] },
      tools_details: executed_tools
    }, status: :unprocessable_entity
  end

  def ai_agent_with_tools
    prompt = params[:prompt]
    tool_name = params[:tool_name]
    tool_arguments = params[:tool_arguments] || {}

    if tool_name.present?
      tool_result = McpTools.call_tool(tool_name, tool_arguments)
      
      if tool_result[:isError]
        render json: { error: tool_result[:error] || 'Error ejecutando herramienta' }, status: :unprocessable_entity
        return
      end

      enhanced_prompt = <<~PROMPT
        #{prompt}

        Resultado de la herramienta #{tool_name}:
        #{tool_result[:content].join("\n")}
      PROMPT

      response = GeminiApiService.chat(enhanced_prompt)
      render json: { 
        message: response, 
        tool_used: tool_name,
        tool_result: tool_result[:content]
      }
    else
      tools = McpTools.list_tools
      response = GeminiApiService.chat(prompt)
      render json: { 
        message: response, 
        available_tools: tools.map { |t| t[:name] },
        hint: "Puedes usar el parámetro 'tool_name' para ejecutar una herramienta MCP"
      }
    end
  end

  private

  def ai_agent_params
    params.permit(:prompt, :tool_name, tool_arguments: {})
  end

  def build_conversation_context(original_prompt, executed_tools)
    context = <<~CONTEXT
      Mensaje original del usuario: #{original_prompt}

      HISTORIAL DE HERRAMIENTAS EJECUTADAS:
    CONTEXT

    if executed_tools.any?
      executed_tools.each_with_index do |tool, index|
        context += <<~TOOL
          #{index + 1}. Herramienta: #{tool[:name]}
             Argumentos: #{tool[:arguments].to_json}
             Resultado: #{tool[:result].to_json}

        TOOL
      end
      
      context += <<~WARNING
        ⚠️ IMPORTANTE:
        - Ya ejecutaste #{executed_tools.length} herramienta(s)
        - NO ejecutes la misma herramienta otra vez con los mismos argumentos
        - Si necesitas más información, usa una herramienta DIFERENTE
        - Si ya tienes toda la información necesaria, RESPONDE directamente sin ejecutar más herramientas
        - Revisa los resultados anteriores antes de decidir qué hacer
      WARNING
    else
      context += "Ninguna herramienta ejecutada aún.\n"
    end
    
    context
  end

  def tool_already_executed?(executed_tools, tool_name, arguments)
    executed_tools.any? do |tool|
      tool[:name] == tool_name && tool[:arguments].to_json == arguments.to_json
    end
  end
end

class Api::AiAgentController < ApplicationController
  def ai_agent
    prompt = params[:prompt]
    tools = McpTools.list_tools
    
    system_instruction = <<~INSTRUCTION
      Eres un asistente inteligente. SIEMPRE debes usar una de las herramientas MCP disponibles.
      
      Revisa las herramientas disponibles y elige la más adecuada según el mensaje del usuario.
      Extrae los parámetros necesarios del mensaje y ejecuta la herramienta.
      Luego integra el resultado en tu respuesta de forma natural.
    INSTRUCTION

    gemini_response = GeminiApiService.chat_with_tools(prompt, tools, system_instruction: system_instruction)
    
    if gemini_response[:wants_tool]
      tool_name = gemini_response[:tool_name]
      tool_arguments = gemini_response[:arguments] || {}
      
      tool_result = McpTools.call_tool(tool_name, tool_arguments)
      
      if tool_result[:isError]
        render json: { 
          error: tool_result[:error] || 'Error ejecutando herramienta',
          tool_attempted: tool_name
        }, status: :unprocessable_entity
        return
      end

      function_result = tool_result[:content].first
      
      final_response = GeminiApiService.chat_with_function_response(
        prompt,
        tool_name,
        JSON.parse(function_result),
        system_instruction: system_instruction
      )

      render json: { 
        message: final_response, 
        tool_used: tool_name,
        tool_result: tool_result[:content],
        available_tools: tools.map { |t| t[:name] }
      }
    else
      render json: { 
        message: gemini_response[:text], 
        tool_used: nil,
        tool_result: nil,
        available_tools: tools.map { |t| t[:name] }
      }
    end
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

end

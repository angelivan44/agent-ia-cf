require 'net/http'
require 'uri'
require 'json'

class GeminiApiService
  MODEL = 'gemini-2.5-flash'
  BASE_URL = "https://generativelanguage.googleapis.com/v1beta/models/#{MODEL}:generateContent"
  API_KEY = ENV['GEMINI_API_KEY']

  def self.chat(prompt, system_instruction: nil)
    uri = URI("#{BASE_URL}?key=#{API_KEY}")
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'

    body = { contents: [{ parts: [{ text: prompt }] }] }
    body[:systemInstruction] = { parts: [{ text: system_instruction }] } if system_instruction.present?
    
    request.body = body.to_json
    response = http.request(request)
    
    data = JSON.parse(response.body)
    puts data
    data['candidates'].first['content']['parts'].first['text']
  end

  def self.chat_with_tools(prompt, tools, system_instruction: nil)
    uri = URI("#{BASE_URL}?key=#{API_KEY}")
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'

    gemini_tools = tools.map do |tool|
      {
        functionDeclarations: [{
          name: tool[:name],
          description: tool[:description],
          parameters: convert_schema_to_gemini_format(tool[:input_schema])
        }]
      }
    end

    body = { 
      contents: [{ parts: [{ text: prompt }] }],
      tools: gemini_tools
    }
    body[:systemInstruction] = { parts: [{ text: system_instruction }] } if system_instruction.present?
    
    Rails.logger.info("Sending to Gemini: #{body.to_json}")
    request.body = body.to_json
    response = http.request(request)
    
    data = JSON.parse(response.body)
    Rails.logger.info("Gemini response: #{data.inspect}")
    candidate = data['candidates'].first
    
    function_call_part = candidate['content']['parts'].find { |part| part['functionCall'] }
    
    if function_call_part
      Rails.logger.info("Gemini wants to use tool: #{function_call_part['functionCall']['name']}")
      {
        wants_tool: true,
        tool_name: function_call_part['functionCall']['name'],
        arguments: function_call_part['functionCall']['args'] || {}
      }
    else
      text_part = candidate['content']['parts'].find { |part| part['text'] }
      Rails.logger.info("Gemini responded with text, no tool call")
      {
        wants_tool: false,
        text: text_part ? text_part['text'] : ''
      }
    end
  end

  def self.chat_with_function_response(prompt, function_name, function_result, tools: nil, system_instruction: nil)
    chat_with_function_response_and_context(prompt, function_name, function_result, tools: tools, system_instruction: system_instruction)
  end

  def self.chat_with_function_response_and_context(context, function_name, function_result, tools: nil, system_instruction: nil)
    chat_with_tools_and_history(context, [{ name: function_name, result: function_result }], tools: tools, system_instruction: system_instruction)
  end

  def self.chat_with_tools_and_history(context, executed_tools, tools: nil, system_instruction: nil)
    uri = URI("#{BASE_URL}?key=#{API_KEY}")
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'

    contents = [{ parts: [{ text: context }] }]

    executed_tools.each do |tool|
      contents << {
        parts: [
          {
            functionResponse: {
              name: tool[:name],
              response: tool[:result]
            }
          }
        ]
      }
    end

    body = { contents: contents }
    body[:systemInstruction] = { parts: [{ text: system_instruction }] } if system_instruction.present?
    
    if tools && tools.any?
      gemini_tools = tools.map do |tool|
        {
          functionDeclarations: [{
            name: tool[:name],
            description: tool[:description],
            parameters: convert_schema_to_gemini_format(tool[:input_schema])
          }]
        }
      end
      body[:tools] = gemini_tools
    end
    
    Rails.logger.info("Sending context with #{executed_tools.length} tool(s) to Gemini")
    request.body = body.to_json
    response = http.request(request)
    
    data = JSON.parse(response.body)
    candidate = data['candidates'].first
    
    function_call_part = candidate['content']['parts'].find { |part| part['functionCall'] }
    
    if function_call_part && tools && tools.any?
      Rails.logger.info("Gemini wants to use tool: #{function_call_part['functionCall']['name']}")
      {
        wants_tool: true,
        tool_name: function_call_part['functionCall']['name'],
        arguments: function_call_part['functionCall']['args'] || {}
      }
    else
      text_part = candidate['content']['parts'].find { |part| part['text'] }
      Rails.logger.info("Gemini responded with text, no tool call")
      {
        wants_tool: false,
        text: text_part ? text_part['text'] : ''
      }
    end
  end

  private

  def self.convert_schema_to_gemini_format(schema)
    {
      type: schema[:type] || 'object',
      properties: (schema[:properties] || {}).transform_values do |prop|
        {
          type: prop[:type],
          description: prop[:description]
        }
      end,
      required: schema[:required] || []
    }
  end
end


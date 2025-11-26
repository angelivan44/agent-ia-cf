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
end


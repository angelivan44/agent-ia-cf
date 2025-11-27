require 'net/http'
require 'uri'
require 'json'

class ApiModelPriceService
  def self.get_model_price(model)
    url = "#{ENV['POLICE_API_URL']}/car/#{model}"
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)['price']
  end
end


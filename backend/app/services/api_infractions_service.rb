require 'net/http'
require 'uri'
require 'json'

class ApiInfractionsService
  def self.get_infractions(national_id)
    url = "#{ENV['POLICE_API_URL']}/#{national_id}"
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)['infractions']
  end
end


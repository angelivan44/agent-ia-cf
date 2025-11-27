require 'net/http'
require 'uri'
require 'json'

class ApiInfractionsService
  def self.get_infractions(national_id)
    url = "#{ENV['POLICE_API_URL']}/clients/#{national_id}"
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    data = JSON.parse(response.body)
    {
      infractions: data['infractions'] || 0,
      details: data['details'] || []
    }
  end
end


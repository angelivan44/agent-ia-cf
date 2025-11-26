require 'net/http'
require 'uri'
require 'json'

class ApiInfractionsService
  def self.get_infractions(national_id)
    url = "#{ENV['POLICE_API_URL']}/clients/#{national_id}"
    response = ApiClientService.get(url)
    response['infractions']
  end
end


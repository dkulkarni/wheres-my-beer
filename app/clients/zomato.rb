class Zomato

  attr_reader :user_key

  def initialize
    @user_key = '64815befecc38198cf7cbfd7ffc37d4f'
    @base_url = 'https://developers.zomato.com/api/v2.1'
  end

  def city_code_for(name = 'Bangalore')
    url = @base_url + '/cities?' + {q: name}.to_query
    response = execute { RestClient.get(url, headers) }
    JSON.parse(response, :symbolize_names => true)[:location_suggestions].first
  end

  def establishments_in(city_id)
    url = @base_url + '/establishments?' + {city_id: city_id}.to_query
    response = execute { RestClient.get(url, headers) }
    JSON.parse(response, :symbolize_names => true)[:establishments]
  end

  def search_restaurants(offset, options = {})
    url = @base_url + '/search?' + options.merge!(start: offset).to_query
    response = execute { RestClient.get(url, headers) }
    JSON.parse(response, :symbolize_names => true)
  end

  private
  def headers
    {user_key: user_key, 'Content-Type': 'application/json'}
  end

  def execute &http_call
    begin
      yield http_call
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError => e
      raise ZomatoError.new({:service => command}, 503)
    rescue RestClient::Forbidden, RestClient::Unauthorized => e
      raise ZomatoError.new({:code => e.http_code, :params => {}, :message => "Authentication Failed"}, e.http_code)
    rescue Exception => e
      raise ZomatoError.new
    end
  end

end
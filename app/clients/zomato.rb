class Zomato

  attr_reader :user_key

  def initialize
    @user_key = '64815befecc38198cf7cbfd7ffc37d4f'
    @base_url = 'https://developers.zomato.com/api/v2.1'
  end

  def city_code_for(name = 'Bangalore')
    url = @base_url + '/cities?' + {q: name}.to_query
    JSON.parse(RestClient.get(url, headers), :symbolize_names => true)[:location_suggestions].first
  end

  def establishments_in(city_id)
    url = @base_url + '/establishments?' + {city_id: city_id}.to_query
    JSON.parse(RestClient.get(url, headers), :symbolize_names => true)
  end

  def search_restaurants(options = {})
    url = @base_url + '/search?' + options.to_query
    JSON.parse(RestClient.get(url, headers), :symbolize_names => true)[:restaurants]
  end

  private
  def headers
    {user_key: user_key, 'Content-Type': 'application/json'}
  end

end
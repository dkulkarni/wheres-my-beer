class ZomatoIngestor
  def initialize
    @zomato_client = Zomato.new
    @index = 'beer_party'
    @document = 'pubs'
  end


  def ingest
    city = @zomato_client.city_code_for 'Bangalore'
    establishments = @zomato_client.establishments_in city[:id]
    restaurants = @zomato_client.search_restaurants({entity_id: city[:id], entity_type: 'city', establishment_type: 6})
    toit = restaurants.first

    Pub.new(name: toit[:restaurant][:name]).save!
  end



end
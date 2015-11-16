class ZomatoIngestor
  def initialize
    @zomato = Zomato.new
  end


  def ingest
    @city = @zomato.city_code_for 'Bangalore'
    establishments = @zomato.establishments_in @city[:id]
    establishments.collect! { |e|
      {id: e[:establishment][:id], name: e[:establishment][:name]} if e[:establishment][:name].eql? 'Pub' or e[:establishment][:name].eql? 'Lounge' or e[:establishment][:name].eql? 'Bar'
    }.compact!

    establishments.each do |establishment|
      restaurants = search_restaurants(establishment[:id])
      restaurants.each do |restaurant|
        venue = restaurant[:restaurant]

        cost = Cost.new(
            for_two: venue[:average_cost_for_two],
            pint: venue[:average_cost_for_two]/10
        )

        location = Location.new(
            locality: venue[:location][:locality],
            city: @city[:name],
            country: @city[:country_name]
        )

        rating = Rating.new(
            avg_rating: venue[:user_rating][:aggregate_rating],
            votes: venue[:user_rating][:votes]
        )

        Pub.new(
            id: venue[:id],
            name: venue[:name],
            link: venue[:url],
            type: establishment[:name],
            cost: cost,
            location: location,
            rating: rating
        ).save
      end
    end
  end

  private
  def search_restaurants(establishment_type, offset=0, result=[])
    response = @zomato.search_restaurants(offset, {entity_id: @city[:id], entity_type: 'city', establishment_type: establishment_type})
    if response[:results_shown] != 0
      result.concat(response[:restaurants])
      offset = response[:results_start].to_i + response[:results_shown]
      search_restaurants establishment_type, offset, result
    end
    result
  end


end
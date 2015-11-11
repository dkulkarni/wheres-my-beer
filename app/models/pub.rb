require 'elasticsearch/persistence/model'

class Pub
  include Elasticsearch::Persistence::Model
  include Virtus.model

  index_name [Rails.application.engine_name, Rails.env].join('-')

  attribute :id, String

  attribute :name, String
  attribute :type, String
  attribute :link, String

  attribute :cost, Cost, mapping: {type: 'object'}
  attribute :location, Location, mapping: {type: 'object'}
  attribute :rating, Rating, mapping: {type: 'object'}
end
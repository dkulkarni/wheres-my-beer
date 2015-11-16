class Location
  include Virtus.model

  attribute :locality, String
  attribute :city, String
  attribute :country, String
end
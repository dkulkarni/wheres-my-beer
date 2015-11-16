class Rating
  include Virtus.model

  attribute :avg_rating, String
  attribute :votes, String
  # attribute :reviews_count, Integer
end
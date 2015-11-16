class Rating
  include Virtus.model

  attribute :avg_rating, Float
  attribute :votes, Integer
  # attribute :reviews_count, Integer
end
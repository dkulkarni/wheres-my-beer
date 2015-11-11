require 'virtus'

class Pub < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include Virtus.model

  attribute :name, String
end
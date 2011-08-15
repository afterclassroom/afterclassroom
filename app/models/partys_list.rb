class PartysList < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :post_party
end

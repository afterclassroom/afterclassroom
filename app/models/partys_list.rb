class PartysList < ActiveRecord::Base
  belongs_to :user
  belongs_to :post_party
end

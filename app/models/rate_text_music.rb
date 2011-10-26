class RateTextMusic < ActiveRecord::Base
  belongs_to :user
  belongs_to :music_album
end

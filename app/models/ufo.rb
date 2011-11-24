class Ufo < ActiveRecord::Base
  belongs_to :user
  has_one :ufo_custom, :dependent => :destroy
  has_many :ufo_cmts, :dependent => :destroy

  has_one :rating_statistic
  has_many :ratings
  has_many :ufo_members, :dependent => :destroy


  has_attached_file :ufo_attach, {
    :bucket => 'afterclassroom_ufo'
  }.merge(PAPERCLIP_STORAGE_OPTIONS)
  
  validates_attachment_size :ufo_attach, :less_than => FILE_SIZE_POST

  # Rating for Good or Bad
  acts_as_rated :rating_range => 0..1, :with_stats_table => true

  def total_good
    self.ratings.count(:conditions => ["rating = ?", 1])
  end

  def total_bad
    self.ratings.count(:conditions => ["rating = ?", 0])
  end

  def score_good
    total = self.total_good + self.total_bad
    (total) == 0 ? 0 : (self.total_good.to_f/(total))*100
  end

  def score_bad
    total = self.total_good + self.total_bad
    (total) == 0 ? 0 : (self.total_bad.to_f/(total))*100
  end


end

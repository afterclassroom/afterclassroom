class Phoneapplication < ActiveRecord::Base
  belongs_to :phoneappcategory

  has_attached_file :photo,
    :default_url => "/images/pictures/phone2.png",
    :styles => { :medium => "161x119>",
    :thumb => "90x66#" }

  def self.search(category,curpage)
    paginate :per_page => 5, :page => curpage,
      :conditions => ['phoneappcategory_id like ?', "%#{category}%"]
  end

  def self.alliphoneapp()
    Phoneapplication.find(:all, :conditions => ['phoneappcategory_id like ?', "1"])
  end

  def self.totalpage(category)

  end


end

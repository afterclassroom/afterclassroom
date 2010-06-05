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

  def self.allbberryapp()
    Phoneapplication.find(:all, :conditions => ['phoneappcategory_id like ?', "2"])
  end
  
  def self.allgoogleapp()
    Phoneapplication.find(:all, :conditions => ['phoneappcategory_id like ?', "3"])
  end

  def self.allapp(curpage)
    if (curpage == nil || curpage == '')
      Phoneapplication.find(:all)
    else
      paginate :per_page => 5, :page => curpage
    end
  end


end

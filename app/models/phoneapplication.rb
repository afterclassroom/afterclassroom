class Phoneapplication < ActiveRecord::Base
  belongs_to :phoneappcategory

  acts_as_state_machine :initial => :recentlyadded, :column => 'state'
  # These are all of the states for the phone-applications.
  state :recentlyadded
  state :verified
  state :rejected

  event :accept do
    transitions :from => :recentlyadded, :to => :verified
  end

  event :reject do
    transitions :from => :recentlyadded, :to => :rejected
  end



  has_attached_file :photo,
    :default_url => "/images/pictures/phone2.png",
    :styles => { :medium => "161x119>",
    :thumb => "90x66#" }
  validates_attachment_content_type :photo, :content_type => ['image/jpg', 'image/jpeg', 'image/gif', 'image/png']

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
    if (curpage == nil || curpage == '')#this part of code is to find all the item support for calculating the number of page
      Phoneapplication.find(:all)
    else
      paginate :per_page => 5, :page => curpage
    end
  end

  def self.recentlyaddedapp(curpage)
    if (curpage == 'all')
      #this part of code is to find all the item that recently added support for calculating the number of page
      Phoneapplication.find(:all, :conditions => ['state like ?', "recentlyadded"])
    else
      paginate :per_page => 5, :page => curpage,
        :conditions => ['state like ?', "recentlyadded"]
    end
  end

  def self.verifiedapp(curpage)
    if (curpage == 'all')
      #this part of code is to find all the item that recently added support for calculating the number of page
      Phoneapplication.find(:all, :conditions => ['state like ?', "verified"])
    else
      paginate :per_page => 5, :page => curpage,
        :conditions => ['state like ?', "verified"]
    end
  end

  def self.popularapp(curpage)
    if (curpage == 'all')
      #this part of code is to find all the item that recently added support for calculating the number of page
      Phoneapplication.find(:all)
    else
      paginate :per_page => 5, :page => curpage, :order => 'popular_rank DESC'
    end
  end


end

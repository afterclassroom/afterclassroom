class Gameapp < ActiveRecord::Base
  acts_as_state_machine :initial => :recentlyadded, :column => 'state'
  # These are all of the states for the game-applications.
  state :recentlyadded
  state :verified
  state :rejected

  event :accept do
    transitions :from => :recentlyadded, :to => :verified
  end

  event :reject do
    transitions :from => :recentlyadded, :to => :rejected
  end

  has_attached_file :gamephoto,
    :default_url => "/images/pictures/phone2.png",
    :styles => { :medium => "161x119>",
    :thumb => "90x66#" }
  validates_attachment_content_type :gamephoto, :content_type => ['image/jpg', 'image/jpeg', 'image/gif', 'image/png']
  
  def self.allapp(curpage)
    puts"-===================================="
    puts"-===================================="
    puts"-===================================="
    puts"-===================================="
    puts"-===================================="
    puts"-===================================="
    puts"-===================================="
    puts"-===================================="
    if (curpage == nil || curpage == '')#this part of code is to find all the item support for calculating the number of page
      Gameapp.find(:all)
    else
      paginate :per_page => 5, :page => curpage
    end
  end

  def self.popularapp(curpage)
    if (curpage == 'all')
      #this part of code is to find all the item that most popular support for calculating the number of page
      Gameapp.find(:all)
    else
      paginate :per_page => 5, :page => curpage, :order => 'popular_rank DESC'
    end
  end
  
  def self.verifiedapp(curpage)
    if (curpage == 'all')
      #this part of code is to find all the item that had been verified, support for calculating the number of page
      Gameapp.find(:all, :conditions => ['state like ?', "verified"])
    else
      paginate :per_page => 5, :page => curpage,
        :conditions => ['state like ?', "verified"]
    end
  end

  def self.recentlyaddedapp(curpage)
    if (curpage == 'all')
      #this part of code is to find all the item that recently added support for calculating the number of page
      Gameapp.find(:all, :conditions => ['state like ?', "recentlyadded"])
    else
      paginate :per_page => 5, :page => curpage,
        :conditions => ['state like ?', "recentlyadded"]
    end
  end


end

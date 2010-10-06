# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class City < ActiveRecord::Base
  # Validations
  validates_presence_of :country_id
  validates_presence_of :name

  # Relations
  belongs_to :country
  belongs_to :state
  has_many :schools, :dependent => :destroy

  #Named scopes
  #SQL: select count(*) from schools where schools.city_id = cities.id) > 0
  cond = "(select count(*) from schools where schools.city_id = cities.id) > 0"
  named_scope :has_schools, :conditions => cond
  
  def full_address_city
    address = self.name
    if self.state
      address += ", " + self.state.name + "-" + self.state.country.printable_name
    else
      address += ", " + self.state.country.printable_name
    end
  end
  
  def self.paginated_cities_conditions_with_search(params)
    search = {}
    search['name'] = params[:city][:name] || nil if params[:city]
    search['country_id'] = params[:city][:country_id] || nil if params[:city]
    search['state_id'] = params[:city][:state_id] || nil if params[:city]
    cond = Caboose::EZ::Condition.new :cities do
      if search['name'] 
        name =~ "%#{search['name']}%"
      end
      if country_id
        country_id == search['country_id']
      end
      if state_id
        state_id == search['state_id']
      end
    end
  end

  def self.search_by_country_code(options = {})
    cond = Caboose::EZ::Condition.new :cities do
      condition :countries do
        iso == options[:country_code]
      end
    end
    City.find :first, :joins => :country, :conditions => cond.to_sql
  end

end

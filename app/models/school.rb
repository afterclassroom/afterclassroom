# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class School < ActiveRecord::Base
  # Validations
  validates_presence_of :city_id
  validates_presence_of :name

  # Relations
  belongs_to :city
  has_many :users
  has_many :posts, :dependent => :destroy
  has_and_belongs_to_many :departments

  # Named Scope
  named_scope :list_school, lambda {|*args| {:conditions => ["city_id = ? AND SUBSTR(LOWER(name), 1, 1) LIKE ?", args[0], args[1]]}}

  def address
    @city = City.find(city_id)
    @countryname = Country.find(@city.country_id).name
    @statename = State.find(@city.state_id).name
    name + ', ' + @city.name + ', ' +  @countryname +  ', ' + @statename
    #name+', '+self.city.name+', '+ self.city.country.name+', '+ self.city.state.name
  end

  def self.paginated_schools_conditions_with_search(params)
    search = {}
    search['name'] = params[:school][:name] || nil if params[:school]
    search['country_id'] = params[:state][:country_id] || nil if params[:state]
    search['state_id'] = params[:city][:state_id] || nil if params[:city]
    search['city_id'] = params[:school][:city_id] || nil if params[:school]
    cond = Caboose::EZ::Condition.new :schools do
      if search['name']
        name =~ "%#{search['name']}%"
      end
      
      if search['city_id']
        city_id == search['city_id']
      end

      if search['state_id']
        condition :states do
          id == search['state_id']
        end
      end

      if search['country_id']
        condition :countries do
          id == search['country_id']
        end
      end
    end
    return cond
  end
end

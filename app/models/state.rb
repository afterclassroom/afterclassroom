# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class State < ActiveRecord::Base
  # Validations
  validates_presence_of :country_id
  validates_presence_of :name
  
  # Relations
  belongs_to :country
  has_many :cities, :dependent => :destroy

  #Named scopes
  cond = "(select count(*) from cities where cities.state_id = states.id) > 0"
  named_scope :has_cities, :conditions => cond
  
  def self.paginated_states_conditions_with_search(params)
    search = {}
    search['name'] = params[:state][:name] || nil if params[:state]
    search['country_id'] = params[:state][:country_id] || nil if params[:state]
    cond = Caboose::EZ::Condition.new :states do
      if search['name']
        name =~ "%#{search['name']}%"
      end
      if country_id
        country_id == search['country_id']
      end
    end
    return cond
  end
end

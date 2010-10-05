class InsertStates < ActiveRecord::Migration
  def self.up
    #Insert State for US
    State.reset_column_information
    # State of USA
    usa_country = usa_country.find_by_iso3('USA')
    State.create(:country_id => usa_country.id, :name => 'Alabama', :alias => 'AL')
    State.create(:country_id => usa_country.id, :name => 'Alaska', :alias => 'AK')
    State.create(:country_id => usa_country.id, :name => 'Arizona', :alias => 'AZ')
    State.create(:country_id => usa_country.id, :name => 'Arkansas', :alias => 'AR')
    State.create(:country_id => usa_country.id, :name => 'California', :alias => 'CA')
    State.create(:country_id => usa_country.id, :name => 'Colorado', :alias => 'CO')
    State.create(:country_id => usa_country.id, :name => 'Connecticut', :alias => 'CT')
    State.create(:country_id => usa_country.id, :name => 'Delaware', :alias => 'DE')
    State.create(:country_id => usa_country.id, :name => 'District Of Columbia', :alias => 'DC')
    State.create(:country_id => usa_country.id, :name => 'Florida', :alias => 'FL')
    State.create(:country_id => usa_country.id, :name => 'Georgia', :alias => 'GA')
    State.create(:country_id => usa_country.id, :name => 'Hawaii', :alias => 'HI')
    State.create(:country_id => usa_country.id, :name => 'Idaho', :alias => 'ID')
    State.create(:country_id => usa_country.id, :name => 'Illinois', :alias => 'IL')
    State.create(:country_id => usa_country.id, :name => 'Indiana', :alias => 'IN')
    State.create(:country_id => usa_country.id, :name => 'Iowa', :alias => 'IA')
    State.create(:country_id => usa_country.id, :name => 'Kansas', :alias => 'KS')
    State.create(:country_id => usa_country.id, :name => 'Kentucky', :alias => 'KY')
    State.create(:country_id => usa_country.id, :name => 'Louisiana', :alias => 'LA')
    State.create(:country_id => usa_country.id, :name => 'Maine', :alias => 'ME')
    State.create(:country_id => usa_country.id, :name => 'Maryland', :alias => 'MD')
    State.create(:country_id => usa_country.id, :name => 'Massachusetts', :alias => 'MA')
    State.create(:country_id => usa_country.id, :name => 'Michigan', :alias => 'MI')
    State.create(:country_id => usa_country.id, :name => 'Minnesota', :alias => 'MN')
    State.create(:country_id => usa_country.id, :name => 'Mississippi', :alias => 'MS')
    State.create(:country_id => usa_country.id, :name => 'Missouri', :alias => 'MO')
    State.create(:country_id => usa_country.id, :name => 'Montana', :alias => 'MT')
    State.create(:country_id => usa_country.id, :name => 'Nebraska', :alias => 'NE')
    State.create(:country_id => usa_country.id, :name => 'Nevada', :alias => 'NV')
    State.create(:country_id => usa_country.id, :name => 'New Hampshire', :alias => 'NH')
    State.create(:country_id => usa_country.id, :name => 'New Jersey', :alias => 'NJ')
    State.create(:country_id => usa_country.id, :name => 'New Mexico', :alias => 'NM')
    State.create(:country_id => usa_country.id, :name => 'New York', :alias => 'NY')
    State.create(:country_id => usa_country.id, :name => 'North Carolina', :alias => 'NC')
    State.create(:country_id => usa_country.id, :name => 'North Dakota', :alias => 'ND')
    State.create(:country_id => usa_country.id, :name => 'Ohio', :alias => 'OH')
    State.create(:country_id => usa_country.id, :name => 'Oklahoma', :alias => 'OK')
    State.create(:country_id => usa_country.id, :name => 'Oregon', :alias => 'OR')
    State.create(:country_id => usa_country.id, :name => 'Pennsylvania', :alias => 'PA')
    State.create(:country_id => usa_country.id, :name => 'Rhode Island', :alias => 'RI')
    State.create(:country_id => usa_country.id, :name => 'South Carolina', :alias => 'SC')
    State.create(:country_id => usa_country.id, :name => 'South Dakota', :alias => 'SD')
    State.create(:country_id => usa_country.id, :name => 'Tennessee', :alias => 'TN')
    State.create(:country_id => usa_country.id, :name => 'Texas', :alias => 'TX')
    State.create(:country_id => usa_country.id, :name => 'Utah', :alias => 'UT')
    State.create(:country_id => usa_country.id, :name => 'Vermont', :alias => 'VT')
    State.create(:country_id => usa_country.id, :name => 'Virginia', :alias => 'VA')
    State.create(:country_id => usa_country.id, :name => 'Washington', :alias => 'WA')
    State.create(:country_id => usa_country.id, :name => 'West Virginia', :alias => 'WV')
    State.create(:country_id => usa_country.id, :name => 'Wisconsin', :alias => 'WI')
    State.create(:country_id => usa_country.id, :name => 'Wyoming', :alias => 'WY')

    # State of CANADA
    cad_country = cad_country.find_by_iso3('CAD')
    State.create(:country_id => cad_country.id, :name => 'Alabama', :alias => 'AL')
  end

  def self.down
  end
end

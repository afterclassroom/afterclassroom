class TagPhoto < ActiveRecord::Base
  belongs_to :tag_info
  
  def as_json(options={})
#    {:name          => self.name,
#      :title         => self.title,
#      :isbn          => self.isbn,
#      :publisher     => self.publisher,
#      :monthly_views => self.monthly_views
#    }

    arr = [{
              :id=>500, #user id
              :text=>"Peter Parker",
              :left=>55,
              :top=>40,
              :width=>120,
              :height=>120,
              :url=> "http://google.com",
              :isDeleteEnable=> true
            },
            {
              :id=>500, #user id
              :text=>"123123 Parker",
              :left=>200,
              :top=>40,
              :width=>120,
              :height=>120,
              :url=> "http://google.com",
              :isDeleteEnable=> true
            }
    ]
    
    
    {
      :Image => [
        {
          :id=> "123",
          :Tags=> arr
        }
      ],
      :options=>{
        :literals=> {
          :removeTag=> "Remove tag"
        },
        :tag=>{
          :flashAfterCreation=> true
        }
      }
    }    
  end
  
end

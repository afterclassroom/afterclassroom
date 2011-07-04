# © Copyright 2009 AfterClassroom.com — All Rights Reserved
module StoriesHelper
  def display_image(story)   
    @web_doc= Hpricot(story.content)
    @arr_img = []
    @web_doc.search("img").each{ |e| @arr_img << e.attributes['src'] }
    image_link = "/images/noimg2.png"
    image_link = @arr_img[0] if @arr_img.size > 0
    image_link == "" ? "" : image_tag(image_link, :style => "margin-left: -10px;")
  end
end

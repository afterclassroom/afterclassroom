# © Copyright 2009 AfterClassroom.com — All Rights Reserved
module PhotosHelper
  def get_first_photo(album)
    album.photos.size > 0 ? raw("<div>#{image_tag album.photos.first.photo_attach.url(:thumb)}</div>") : raw("<div><img src='/images/noimg2.png' /></div>")
  end
end

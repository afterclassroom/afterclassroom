module Postwall
  include ActiveSupport
  include TruncateHtmlHelper
  include ApplicationHelper
  
  protected
  def post_wall(post, path)
    user_wall = UserWall.new
    user_wall_link = UserWallLink.new()
    user_wall.user_id = post.user.id
    user_wall.user_id_post = post.user.id
    user_wall.content = "A new post on #{post.post_category.name}"
    user_wall.save
    user_wall_link.link = path
    user_wall_link.title = post.title
    user_wall_link.sub_content = truncate_html(post.description, :length => 100, :omission => '...')
    user_wall.user_wall_link = user_wall_link
    user_wall.save
  end
  
  def image_wall(img)
    user_wall = UserWall.new
    user_wall_photo = UserWallPhoto.new()
    user_wall.user_id = img.user.id
    user_wall.user_id_post = img.user.id
    user_wall.content = "Add new photo to album: #{link_to img.photo_album.name, show_album_user_photos_path(img.photo_album.user, :photo_album_id => img.photo_album), :target => "_blank"}"
    user_wall.save
    user_wall_photo.link = img.photo_attach.url
    user_wall_photo.title = img.title
    user_wall_photo.sub_content = user_photo_url(img.user, img)
    user_wall.user_wall_photo = user_wall_photo
    user_wall.save
  end
  
  def photo_album_wall(pa)
    user_wall = UserWall.new
    user_wall_link = UserWallLink.new()
    user_wall.user_id = pa.user.id
    user_wall.user_id_post = pa.user.id
    user_wall.content = "Add new photo album #{link_to pa.name, show_album_user_photos_path(pa.user, :photo_album_id => pa), :target => "_blank"}"
    user_wall.save
    user_wall_link.link = show_photo_album_user_url(pa.user, :photo_album_id => pa)
    user_wall_link.title = pa.name
    user_wall_link.sub_content = truncate_html(pa.name, :length => 100, :omission => '...')
    user_wall.user_wall_link = user_wall_link
    user_wall.save
  end
  
  def music_album_wall(ma)
    user_wall = UserWall.new
    user_wall_link = UserWallLink.new()
    user_wall.user_id = ma.user.id
    user_wall.user_id_post = ma.user.id
    user_wall.content = "Add new music album #{link_to ma.name, play_list_user_musics_path(ma.user, :music_album_id => ma), :target => "_blank"}"
    user_wall.save
    user_wall_link.link = show_music_album_user_url(ma.user, :music_album_id => ma)
    user_wall_link.image_link = ma.music_album_attach.url(:thumb)
    user_wall_link.title = ma.name
    user_wall_link.sub_content = truncate_html(ma.name, :length => 100, :omission => '...')
    user_wall.user_wall_link = user_wall_link
    user_wall.save
  end
  
  def music_wall(mc)
    user_wall = UserWall.new
    user_wall_music = UserWallMusic.new()
    user_wall.user_id = mc.user.id
    user_wall.user_id_post = mc.user.id
    user_wall.content = "Add new music to album: #{link_to mc.music_album.name, play_list_user_musics_path(mc.music_album.user, :music_albumds_id => mc.music_album), :target => "_blank"}"
    user_wall.save
    user_wall_music.link = mc.music_attach.url
    user_wall_music.title = mc.title
    user_wall_music.sub_content = user_music_url(mc.user, mc)
    user_wall.user_wall_music = user_wall_music
    user_wall.save
  end
  
  def story_wall(st)
    user_wall = UserWall.new
    user_wall_link = UserWallLink.new()
    user_wall.user_id = st.user.id
    user_wall.user_id_post = st.user.id
    user_wall.content = "Post a story"
    user_wall.save
    user_wall_link.link = user_story_path(st.user, st)
    user_wall_link.title = st.title
    user_wall_link.sub_content = truncate_html(st.content, :length => 100, :omission => '...')
    user_wall.user_wall_link = user_wall_link
    user_wall.save
  end 
end
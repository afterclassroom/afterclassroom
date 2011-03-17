module Postwall
  include ActiveSupport
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
    user_wall_link.sub_content = post.description
    user_wall.user_wall_link = user_wall_link
    user_wall.save
  end
  
  def image_wall(img)
    user_wall = UserWall.new
    user_wall_photo = UserWallPhoto.new()
    user_wall.user_id = img.user.id
    user_wall.user_id_post = img.user.id
    user_wall.content = "Add new photo to album #{img.photo_album.name}"
    user_wall.save
    user_wall_photo.link = img.photo_attach.url
    user_wall_photo.title = img.photo_album.name
    user_wall_photo.sub_content = img.title
    user_wall.user_wall_photo = user_wall_photo
    user_wall.save
  end
  
  def music_wall(mc)
    user_wall = UserWall.new
    user_wall_music = UserWallMusic.new()
    user_wall.user_id = mc.user.id
    user_wall.user_id_post = mc.user.id
    user_wall.content = "Add new music on #{mc.music_album.name}"
    user_wall.save
    user_wall_music.link = mc.music_attach.url
    user_wall_music.title = mc.music_album.name
    user_wall_music.sub_content = mc.title
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
    user_wall_link.sub_content = st.content
    user_wall.user_wall_link = user_wall_link
    user_wall.save
  end 
end
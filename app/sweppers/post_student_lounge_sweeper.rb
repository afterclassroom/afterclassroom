class PostStudentLoungeSweeper < ActionController::Caching::Sweeper
  observe PhotoAlbum, Photo, MusicAlbum, Music, Video
  
  def after_save(p)
    clear_posts_cache(p)
  end
  
  def after_update(p)
    clear_posts_cache(p)
  end
  
  def after_destroy(p)
    clear_posts_cache(p)
  end
  
  def clear_posts_cache(p)
    class_name = p.class.name
  end
end
class RateCmtsController < ApplicationController
  def load_bk_like

    @str_cur_page = params[:str_page_no] ? params[:str_page_no] : "1"
    case params[:rated_type]
    when "Video"
      @post = Video.find(params[:post_id])
      @rating_texts = @post.rate_text_videos.where(["rating=? and rated_type=?","1","#{params[:rated_type]}"]).order('created_at DESC').paginate(:page => @str_cur_page, :per_page => params[:str_perpage])
      @like_size = @post.rate_text_videos.where('rating="1"').size
    when "MusicAlbum"
      @post = MusicAlbum.find(params[:post_id])
      @rating_texts = @post.rate_text_musics.where(["rating=? and rated_type=?","1","#{params[:rated_type]}"]).order('created_at DESC').paginate(:page => @str_cur_page, :per_page => params[:str_perpage])
      @like_size = @post.rate_text_musics.where('rating="1"').size
    when "Photo"
      @post = Photo.find(params[:post_id])
      @rating_texts = @post.rate_text_photos.where(["rating=? and rated_type=?","1","#{params[:rated_type]}"]).order('created_at DESC').paginate(:page => @str_cur_page, :per_page => params[:str_perpage])
      @like_size = @post.rate_text_photos.where('rating="1"').size
    when "Story"
      @post = Story.find(params[:post_id])
      @rating_texts = @post.rate_text_stories.where(["rating=? and rated_type=?","1","#{params[:rated_type]}"]).order('created_at DESC').paginate(:page => @str_cur_page, :per_page => params[:str_perpage])
      @like_size = @post.rate_text_stories.where('rating="1"').size
    else
      @post = Post.find(params[:post_id])

      str_rating_number = "1"
    if ( params[:rated_type] == "PostFood" || params[:rated_type] == "PostMyx" || params[:rated_type] == "PostParty" )
      str_rating_number = 2
    end

      @rating_texts = @post.rating_texts.where(["rating=? and rated_type=?",str_rating_number,"#{params[:rated_type]}"]).order('created_at DESC').paginate(:page => @str_cur_page, :per_page => params[:str_perpage])
      @like_size = @post.rating_texts.where('rating="1"').size
    end

    @perpage = params[:str_perpage]
    @rated_type = params[:rated_type]
    render :layout => false
  end


  def add_like_cmt

    case params[:rated_type]
    when "Video"
      @post = Video.find(params[:post_id])
      @cmt = RateTextVideo.new()
      @cmt.video = @post
    when "MusicAlbum"
      @post = MusicAlbum.find(params[:post_id])
      @cmt = RateTextMusic.new()
      @cmt.music_album = @post
    when "Photo"
      @post = Photo.find(params[:post_id])
      @cmt = RateTextPhoto.new()
      @cmt.photo = @post
    when "Story"
      @post = Story.find(params[:post_id])
      @cmt = RateTextStory.new()
      @cmt.story = @post
    else
      @post = Post.find(params[:post_id])
      @cmt = RatingText.new()
      @cmt.post = @post
    end

    @cmt.user = current_user
    @cmt.rated_type = params[:rated_type]
    @cmt.rating = 1

    if ( @cmt.rated_type == "PostFood" || @cmt.rated_type == "PostMyx" || @cmt.rated_type == "PostParty" )
      @cmt.rating = 2
    end

    @cmt.content = params[:cmt_cnt]
    @cmt.save

    
    render :layout => false
  end


  def load_bk_dislike
    @str_cur_page = params[:str_page_no] ? params[:str_page_no] : "1"
    case params[:rated_type]
    when "Video"
      @post = Video.find(params[:post_id])
      @rating_texts = @post.rate_text_videos.where(["rating=? and rated_type=?","0","#{params[:rated_type]}"]).order('created_at DESC').paginate(:page => @str_cur_page, :per_page => params[:str_perpage])
      @dislike_size = @post.rate_text_videos.where('rating = "0"').size
    when "MusicAlbum"
      @post = MusicAlbum.find(params[:post_id])
      @rating_texts = @post.rate_text_musics.where(["rating=? and rated_type=?","0","#{params[:rated_type]}"]).order('created_at DESC').paginate(:page => @str_cur_page, :per_page => params[:str_perpage])
      @dislike_size = @post.rate_text_musics.where('rating = "0"').size
    when "Photo"
      @post = Photo.find(params[:post_id])
      @rating_texts = @post.rate_text_photos.where(["rating=? and rated_type=?","0","#{params[:rated_type]}"]).order('created_at DESC').paginate(:page => @str_cur_page, :per_page => params[:str_perpage])
      @dislike_size = @post.rate_text_photos.where('rating = "0"').size
    when "Story"
      @post = Story.find(params[:post_id])
      @rating_texts = @post.rate_text_stories.where(["rating=? and rated_type=?","0","#{params[:rated_type]}"]).order('created_at DESC').paginate(:page => @str_cur_page, :per_page => params[:str_perpage])
      @dislike_size = @post.rate_text_stories.where('rating = "0"').size
    else
      @post = Post.find(params[:post_id])
      @rating_texts = @post.rating_texts.where(["rating=? and rated_type=?","0","#{params[:rated_type]}"]).order('created_at DESC').paginate(:page => @str_cur_page, :per_page => params[:str_perpage])
      @dislike_size = @post.rating_texts.where('rating = "0"').size
    end

    @rated_type = params[:rated_type]
    @perpage = params[:str_perpage]
    render :layout => false
  end


  def add_dislike_cmt
    case params[:rated_type]
    when "Video"
      @post = Video.find(params[:post_id])
      @cmt = RateTextVideo.new()
      @cmt.video = @post
    when "MusicAlbum"
      @post = MusicAlbum.find(params[:post_id])
      @cmt = RateTextMusic.new()
      @cmt.music_album = @post
    when "Photo"
      @post = Photo.find(params[:post_id])
      @cmt = RateTextPhoto.new()
      @cmt.photo = @post
    when "Story"
      @post = Story.find(params[:post_id])
      @cmt = RateTextStory.new()
      @cmt.story = @post
    else
      @post = Post.find(params[:post_id])
      @cmt = RatingText.new()
      @cmt.post = @post
    end
    @cmt.user = current_user
    @cmt.rated_type = params[:rated_type]
    @cmt.rating = 0
    @cmt.content = params[:cmt_dcnt]
    @cmt.save
    
    render :layout => false
  end


  def load_other
    ##Load_other action is applied for food,party, and myx where they have the 3rd type of rating
    ##in these cases, sequentially, they are, "Cheap but good", "it's ok", "bored"
    ##they all have the rating value as 1
    @post = Post.find(params[:post_id])
    @str_cur_page = params[:str_page_no] ? params[:str_page_no] : "1"
    @rating_texts = @post.rating_texts.where(["rating=? and rated_type=?","1","#{params[:rated_type]}"]).order('created_at DESC').paginate(:page => @str_cur_page, :per_page => params[:str_perpage])
    @other_size = @post.rating_texts.where('rating = "1"').size
    @rated_type = params[:rated_type]
    @perpage = params[:str_perpage]
    render :layout => false
  end

  def add_other_cmt
    @post = Post.find(params[:post_id])
    @cmt = RatingText.new()
    @cmt.user = current_user
    @cmt.post = @post
    @cmt.rated_type = params[:rated_type]
    @cmt.rating = 1
    @cmt.content = params[:cmt_ocnt]
    @cmt.save
    
    render :layout => false
  end

end

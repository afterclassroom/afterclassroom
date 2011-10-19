class RateCmtsController < ApplicationController
  def load_bk_like
    @post = Post.find(params[:post_id])
    @str_cur_page = params[:str_page_no] ? params[:str_page_no] : "1"
    @rating_texts = @post.rating_texts.where(["rating=? and rated_type=?","1","#{params[:rated_type]}"]).order('created_at DESC').paginate(:page => @str_cur_page, :per_page => params[:str_perpage])
    @perpage = params[:str_perpage]
    @like_size = @post.rating_texts.where('rating="1"').size
    @rated_type = params[:rated_type]
    render :layout => false
  end
  def add_like_cmt
    @post = Post.find(params[:post_id])
    @cmt = RatingText.new()
    @cmt.user = current_user
    @cmt.post = @post
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
    @post = Post.find(params[:post_id])
    @str_cur_page = params[:str_page_no] ? params[:str_page_no] : "1"
    @rating_texts = @post.rating_texts.where(["rating=? and rated_type=?","0","#{params[:rated_type]}"]).order('created_at DESC').paginate(:page => @str_cur_page, :per_page => params[:str_perpage])
    @dislike_size = @post.rating_texts.where('rating = "0"').size
    @rated_type = params[:rated_type]
    @perpage = params[:str_perpage]
    render :layout => false
  end

  def add_dislike_cmt
    @post = Post.find(params[:post_id])
    @cmt = RatingText.new()
    @cmt.user = current_user
    @cmt.post = @post
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

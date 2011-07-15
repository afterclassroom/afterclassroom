# © Copyright 2009 AfterClassroom.com — All Rights Reserved
module VideosHelper
  def display_image_video(video)   
    if video.video_file
      raw("<div>#{image_tag video.video_file.video_attach.url(:thumb)}</div>")
    else
      raw("<div>#{image_tag "/images/no-video.gif"}</div>")
    end
  end
end
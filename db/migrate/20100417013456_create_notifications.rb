class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|

      t.boolean :sms_allow

      t.boolean :email_allow

      t.string :name

      t.string :label

      t.string :notify_type


      t.timestamps

    end

    [
      ["AfterClassroom", "Sends me a message", "sends_me_a_message", true, true],
      ["AfterClassroom","Adds me as a friend","adds_me_as_a_friend",true,true],
      ["AfterClassroom","Confirms a friendship request","confirms_a_friendship_request",true,false],
      ["AfterClassroom","Posts on My Lounge","posts_on_my_lounge",true,true],
      ["AfterClassroom","Pokes me","pokes_me",true,true],
      ["AfterClassroom","Has a birthday coming up (weekly email)","has_a_birthday_coming_up_(weekly_email)",true,false],
      ["AfterClassroom","Asks me to confirm friend detail","asks_me_to_confirm_friend_detail",true,false],
      ["AfterClassroom","Requests to list me as family","requests_to_list_me_as_family",true,false],
      ["AfterClassroom","Suggests a friend to me","suggests_a_friend_to_me",true,false],
      ["AfterClassroom","Adds a friend I suggested","adds_a_friend_I_suggested",true,false],
      ["AfterClassroom","I invited joins AfterClassroom","I_invited_joins_AfterClassroom",true,false],
      ["AfterClassroom","Tags me in a post","tags_me_in_a_post",true,true],
      ["AfterClassroom","Comments on a post I was tagged in","comments_on_a_post_I_was_tagged_in",true,true],
      ["AfterClassroom","Suggests a profile picture for me","suggests_a_profile_picture_for_me",true,true],
      ["Photos","Tags me in a photo","tags_me_in_a_photo",true,true],
      ["Photos","Tags one of my photos","tags_one_of_my_photos",true,false],
      ["Photos","Comments on my photos","comments_on_my_photos",true,true],
      ["Photos","Comments on a photo of me","comments_on_a_photo_of_me",true,false],
      ["Photos","Comments after me in a photo","comments_after_me_in_a_photo",true,false],
      ["Photos","When I upload a photo via email","when_I_upload_a_photo_via_email",true,false],
      ["Photos","Comments on my photo albums","comments_on_my_photo_albums",true,false],
      ["Photos","Comments after me in a photo album","comments_after_me_in_a_photo_album",true,false],
      ["Groups","Invites me to join a group","invites_me_to_join_a_group",true,false],
      ["Groups","Promotes me to be an officer","promotes_me_to_be_an_officer",true,false],
      ["Groups","Makes me a group admin","makes_me_a_group_admin",true,false],
      ["Groups","Requests to join a group of which I am an admin","requests_to_join_a_group_of_which_I_am_an_admin",true,false],
      ["Groups","Replies to my discussion board post","replies_to_my_discussion_board_post",true,false],
      ["Groups","Changes the name of a group to which I belong","changes_the_name_of_a_group_to_which_I_belong",true,false],
      ["Pages"," Makes me a page admin","makes_me_a_page_admin",true,false],
      ["Pages","Suggests a page to me","suggests_a_page_to_me",true,false],
      ["Events","Invites me to an event","invites_me_to_an_event",true,false],
      ["Events","Changes the date or time of an event","changes_the_date_or_time_of_an_event",true,false],
      ["Events","Cancels an event","cancels_an_event",true,false],
      ["Events","Makes me an event admin","makes_me_an_event_admin",true,false],
      ["Events","Requests to join an event of which I am an admin","requests_to_join_an_event_of_which_I_am_an_admin",true,false],
      ["Events","Posts on the wall of an event I admin","posts_on_the_wall_of_an_event_I_admin",true,false],
      ["Events","Changes the name of an event to which I was invited","changes_the_name_of_an_event_to which_I_was_invited",true,false],
      ["Share a Story","Tags me in share a story","tags_me_in_share_a_story",true,false],
      ["Share a Story","Comments on my share a story","comments_on_my_share_a_story",true,true],
      ["Share a Story","Comments after me in share a story","comments_after_me_in_share_a_story",true,false],
      ["Links","Comments on my links","comments_on_my_links",true,false],
      ["Links","Comments after me in a link","comments_after_me_in_a_link",true,true],
      ["Music","Tags me in a music","tags_me_in_a_music",true,false],
      ["Music","Tags one of my musics","tags_one_of_my_musics",true,false],
      ["Music","Comments on my musics","comments_on_my_musics",true,false],
      ["Music","Comments on a music of me","comments_on_a_music_of_me",true,false],
      ["Music","Comments after me in a music","comments_after_me_in_a_music",true,false],
      ["Video","Tags me in a video","tags_me_in_a_video",true,false],
      ["Video","Tags one of my videos","tags_one_of_my_videos",true,false],
      ["Video","Comments on my videos","comments_on_my_videos",true,false],
      ["Video","Comments on a video of me","comments_on_a_video_of_me",true,false],
      ["Video","Comments after me in a video","comments_after_me_in_a_video",true,false],
      ["Gifts","Sends me a gift","sends_me_a_gift",true,false],
      ["Help Center","Replies to my Help Center questions","replies_to my_help_center_questions",true,false],
      ["Help Center","Marks my answer as Best Answer","marks_my_answer_as_best_answer",true,false],
      ["Other updates from AfterClassroom","Updates about my Friends on AfterClassroom","updates_about_my_friends_on_AfterClassroom",true,false],
      ["Other updates from AfterClassroom","Updates about AfterClassroom product news","updates_about_AfterClassroom_product_news",true,false],
      ["Other updates from AfterClassroom","Invitations to participate in research about AfterClassroom","invitations_to_participate_in_research_about_AfterClassroom",true,false]
    ].each do |s|
      Notification.new(:notify_type => s[0], :name => s[1], :label => s[2], :sms_allow => s[3], :email_allow => s[4]).save
    end

  end

  def self.down
    drop_table :notifications
  end
end

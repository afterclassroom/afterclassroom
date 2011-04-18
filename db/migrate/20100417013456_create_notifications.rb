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
      ["AfterClassroom", "Sends me a message", "sends_me_a_message", true, false],
      ["AfterClassroom","Adds me as a friend","adds_me_as_a_friend",true,false],
      ["AfterClassroom","Confirms a friendship request","confirms_a_friendship_request",true,false],
      ["AfterClassroom","Has a birthday coming up (weekly email)","has_a_birthday_coming_up_(weekly_email)",true,false],
      ["AfterClassroom","Requests to list me as family","requests_to_list_me_as_family",true,false],
      ["AfterClassroom","Suggests a friend to me","suggests_a_friend_to_me",true,false],
      ["Share a Story","Comments on my share a story","comments_on_my_story",true,false],
      ["Photos","Comments on my photos","comments_on_my_photos",true,false],
      ["Music","Comments on my musics","comments_on_my_musics",true,false],
      ["My Lounge","Posts on My Lounge","posts_on_my_lounge",true,true],
      ["My Lounge","Comments on a story in my lounge","comments_on_my_lounge",true,false]
    ].each do |s|
      Notification.new(:notify_type => s[0], :name => s[1], :label => s[2], :email_allow => s[3], :sms_allow => s[4]).save
    end

  end

  def self.down
    drop_table :notifications
  end
end

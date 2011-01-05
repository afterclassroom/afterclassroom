# © Copyright 2009 AfterClassroom.com — All Rights Reserved
module FriendsHelper
  def display_mailtype(mail_type)
    case mail_type
    when MailAccount::GMAIL
      "@gmail.com"
    when MailAccount::YAHOOMAIL
      "@yahoo.com"
    when MailAccount::AOL
      "@aol.com"
    when MailAccount::HOTMAIL
      hotmail_suffix = [
        ["hotmail.com", "hotmail.com"], ["hotmail.co.il", "hotmail.co.il"], ["hotmail.co.jp", "hotmail.co.jp"], ["hotmail.co.th", "hotmail.co.th"],
        ["hotmail.co.uk", "hotmail.co.uk"], ["hotmail.com.ar", "hotmail.com.ar"], ["hotmail.com.tr", "hotmail.com.tr"], ["hotmail.es", "hotmail.es"],
        ["hotmail.de","hotmail.de"], ["hotmail.fr", "hotmail.fr"], ["hotmail.it", "hotmail.it"], ["live.at", "live.at"], ["live.be", "live.be"],
        ["live.ca", "live.ca"], ["live.cl", "live.cl"], ["live.cn", "live.cn"], ["live.co.in", "live.co.in"],["live.co.kr", "live.co.kr"],
        ["live.co.uk", "live.co.uk"], ["live.co.za", "live.co.za"], ["live.com", "live.com"], ["live.com.ar", "live.com.ar"], ["live.com.au", "live.com.au"],
        ["live.com.co", "live.com.co"], ["live.com.mx", "live.com.mx"], ["live.com.my", "live.com.my"], ["live.com.pe", "live.com.pe"], ["live.com.ph", "live.com.ph"],
        ["live.com.pk", "live.com.pk"], ["live.com.pt", "live.com.pt"], ["live.com.sg", "live.com.sg"], ["live.com.ve", "live.com.ve"], ["live.de", "live.de"],
        ["live.dk", "live.dk"], ["live.fr", "live.fr"], ["live.hk", "live.hk"], ["live.ie", "live.ie"], ["live.in", "live.in"], ["live.it", "live.it"], ["live.jp", "live.jp"],
        ["live.nl", "live.nl"], ["live.no", "live.no"], ["live.ph", "live.ph"], ["live.ru", "live.ru"], ["br.live.com", "br.live.com"], ["live.se", "live.se"],
        ["livemail.com.br", "livemail.com.br"], ["livemail.tw", "livemail.tw"], ["messengeruser.com", "messengeruser.com"], ["msn.com", "msn.com"], ["passport.com", "passport.com"],
        ["sympatico.ca", "sympatico.ca"], ["tw.live.com", "tw.live.com"], ["webtv.net", "webtv.net"], ["windowslive.com", "windowslive.com"], ["windowslive.es", "windowslive.es"]
      ]
      "@" + select_tag("suffix", options_for_select(hotmail_suffix))
    end
  end
end

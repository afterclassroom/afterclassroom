module SettingHelper
	def show_status_and_link_social_connect(user, provider)
		omnitauth = user.omnitauths.where(:provider => provider).first
		if omnitauth
			return "You have connected your #{provider} account.", link_to(raw("<span>Unlink</span>"), omnitauth, :method => :delete)
		else
			return "Link your Afterclassroom account to your #{provider} profile", link_to(raw("<span>Link</span>"), "/auth/#{provider}")
		end
	end
end

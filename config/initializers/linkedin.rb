module LinkedInConfig
  CONFIG = YAML.load_file(Rails.root.join("config/linkedin.yml"))[Rails.env]
  APP_ID = CONFIG['app_id']
  SECRET = CONFIG['secret_key']
	CALL_BACK = CONFIG['call_back']
end

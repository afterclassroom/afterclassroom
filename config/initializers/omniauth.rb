Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, "8VFiOPrVrh6s3pDOPEZEjA", "tLN93NsBLt5c7wpy6uL8yZIWgp3QcAUCWCsqD2tQ" 
	provider :facebook, '181815955248907', '2b729f219e09904eccbc9840d2c540fc'
end

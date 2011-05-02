# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Afterclassroom::Application.initialize!

# ThinkingSphinx
ThinkingSphinx.suppress_delta_output = true
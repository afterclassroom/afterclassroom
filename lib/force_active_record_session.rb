module Rack
  class ForceActiveRecordSession
    def initialize(app, options = {})
      @app = app
    end
    def call(env)
      request = Rack::Request.new(env)
      sid = request.cookies[env['rack.session.options'][:key]]
      env['rack.session.record'] = 
        ActiveRecord::SessionStore::Session.find_by_session_id(sid) || 
        ActiveRecord::SessionStore::Session.new(:session_id => sid, :data => {})
      @app.call(env)
    end
  end
end
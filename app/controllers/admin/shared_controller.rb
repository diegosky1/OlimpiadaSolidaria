class Admin::SharedController < ApplicationController
	before_filter :require_admin_session
	layout 'backend'

end

class Master::SharedController < ApplicationController
	layout 'backend'
	before_filter :require_master_session
end

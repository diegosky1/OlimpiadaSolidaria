require 'params_for'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  extend ParamsFor

  before_filter :get_current_user

  protected
  	def get_current_user
  		@current_user = User.where(id: session[:user_id]).first if session[:session_id]
  	end

    def require_admin_session
      unless @current_user and @current_user.admin?
        flash[:warning] = "Por favor inicia sesi&oacute;n"
        redirect_to root_url
      end
    end

  	def require_master_session
  		unless @current_user and @current_user.master?
        flash[:warning] = "Por favor inicia sesi&oacute;n"
  			redirect_to root_url
  		end
  	end

    def require_student_session
      unless @current_user and @current_user.student?
        flash[:warning] = "Por favor inicia sesi&oacute;n"
        redirect_to root_url
      end
    end
end


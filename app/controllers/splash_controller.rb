class SplashController < ApplicationController
	def index
		@university_series = University.all.map do |university|
			{ name: university.name, data: [university.total_hours] }
		end
         
         @university_names = University.all.map do |university| university.name 
        end

        @university_index_chart = University.all.map do |university|
			university.total_hours
		end
	end

	def logout
		session[:user_id] = nil
		redirect_to root_url, notice: 'Tu sesi&oacute;n ha terminado'
	end

	def authenticate
		@user = User.authenticate(params[:login][:email],params[:login][:password])
		if @user
			session[:user_id] = @user.id
			redirect_to root_url_for(@user)
		else
			flash[:alert] = 'Usuario / Contrase&ntilde;a Inv&aacute;lidos'.html_safe
			redirect_to action: :index
		end
	end

	protected
		def root_url_for(user)
			case 
				when user.master? then master_root_url				
				when user.admin? then admin_root_url
				when user.student? then user_url(user)
			end
		end
end

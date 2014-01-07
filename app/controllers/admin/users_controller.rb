class Admin::UsersController < Admin::SharedController
	def index
		@users = User.students.where(university_id: @current_user.university_id)
		if params[:query]
			@query = params[:query]
			@users = @users.search(params[:query]) 
		end
	end
end

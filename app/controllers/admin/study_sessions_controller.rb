class Admin::StudySessionsController < Admin::SharedController
	before_filter :get_user

	def index
		@study_sessions = @user.study_sessions.order("created_at DESC")
	end

	def edit
		@study_session = @user.study_sessions.find(params[:id])
	end

	def update
		@study_session = @user.study_sessions.find(params[:id])
		@study_session.admin_editing = true 
		if @study_session.update_attributes(study_session_params)
			redirect_to admin_user_study_sessions_url(@user), notice: 'El registro se ha actualizado'
		else
			render action: 'edit'
		end
	end

	def destroy
		@study_session = @user.study_sessions.find(params[:id])		
		@study_session.destroy
		redirect_to admin_user_study_sessions_url(@user), notice: 'El registro se ha eliminado'
	end

	params_for :study_session, :hours

	protected
		def get_user
			@user = User.find(params[:user_id])
		end
end

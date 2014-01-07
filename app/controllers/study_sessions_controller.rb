class StudySessionsController < ApplicationController
	before_filter :require_student_session

	def create
		@study_session = @current_user.study_sessions.build(study_session_params)

		if @study_session.save
			redirect_to user_url(@current_user), notice: 'Las horas se han registrado'
		else
			redirect_to user_url(@current_user), alert: @study_session.errors.full_messages.join
		end
	end

	params_for :study_session, :hours
end

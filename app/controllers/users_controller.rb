class UsersController < ApplicationController
	
  before_filter :require_student_session, only: [:edit, :update, :follow, :unfollow]

  def show
    @user = User.find(params[:id])
    @study_sessions = @user.study_sessions.select("sum(hours) AS hours, created_at").order(:created_at)
    @daily_sessions = @study_sessions.group("date(created_at)")
    @monthly_sessions = @study_sessions.group("month(created_at)")
    @monthly_hours = (1..12).map do |month|
      monthly_session = @monthly_sessions.detect { |session| session.created_at.month.eql? month }
      (monthly_session and monthly_session.hours * 20) or 0
    end

    following_ids = @user.following_relations.pluck(:following_id)

    @top_users = User.where("users.id IN (?)", following_ids << @user.id).ordered_by_hours.limit(10) 
  end

  def new
    @user = User.new
    @universities = University.order(:name)
  end

  def create
    @user = User.new(user_params)
    @user.user_type = User::TYPES[:student]
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Bienvenido a la Olimpiada Solidaria!"
      redirect_to @user
    else
      @universities = University.order(:name)
      render 'new'
    end
  end

  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user
    if @user.update_attributes(user_params)
      flash[:success] = "Perfil editado"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def search
    @query = params[:query]
    @users = User.students.search(params[:query]).includes(:university)
  end

  def follow
    @other_user = User.find(params[:id])
    @current_user.following_relations.create!(following_id: @other_user.id)
    redirect_to user_url(@current_user), notice: "Ahora sigues a #{@other_user.full_name}"
  end

  def unfollow
    @other_user = User.find(params[:id])
    @current_user.following_relations.where(following_id: params[:id]).destroy_all
    redirect_to user_url(@current_user), notice: "Ya no sigues a #{@other_user.full_name}"
  end

 #  def destroy
 #    User.find(params[:id]).destroy
 #    flash[:success] = "Usuario eliminado exitosamente"
 #    redirect_to users_url
 #  end

  params_for :user, :name, :surname, :email, :university_id, :age, :gender, :password, :password_confirmation, :avatar

 #    # Before filters

 #    def correct_user
 #      @user = User.find(params[:id])
 #      redirect_to(root_url) unless current_user?(@user)
 #    end

 #    def admin_user
 #      redirect_to(root_url) unless current_user.admin?
 #    end
end

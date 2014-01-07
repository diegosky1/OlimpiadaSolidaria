class Master::AdminsController < Master::SharedController
	before_filter :get_universities, only: [:new, :edit]

	def index
		@admins = User.admins.includes(:university)
	end

	def new
		@admin = User.new		
	end

	def edit
		@admin = User.admins.find(params[:id])
	end

	def create
		@admin = User.new(user_params)
		@admin.user_type = User::TYPES[:admin]
		if @admin.save
			redirect_to master_admins_url, notice: 'El administrador ha sido creado'
		else
			get_universities
			render action: 'new'
		end
	end

	def update
		@admin = User.admins.find(params[:id])		
		if @admin.update_attributes(user_params)
			redirect_to master_admins_url, notice: 'El administrador ha sido actualizado'
		else
			get_universities
			render action: 'edit'
		end
	end

	def destroy
		@admin = User.admins.find(params[:id])
		@admin.destroy
		redirect_to master_admins_url, notice: 'El administrador ha sido eliminado'	
	end

	params_for :user, :name, :surname, :email, :password, :password_confirmation, :university_id, :gender, :age

	protected
		def get_universities
			@universities = University.order(:name)
		end
end

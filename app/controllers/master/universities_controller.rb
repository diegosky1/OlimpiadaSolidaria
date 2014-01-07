class Master::UniversitiesController < Master::SharedController

	def index
		@universities = University.order(:name)
	end

	def new
		@university = University.new
	end

	def edit 
		@university = University.find(params[:id])
	end

	def show
		@university = University.find(params[:id])
	end

	def create
		@university = University.new(university_params)
		if @university.save
			redirect_to master_universities_url, notice: 'La universidad se ha creado'
		else
			render action: 'new'
		end
	end

	def update
		@university = University.find(params[:id])
		if @university.update_attributes(university_params)
			redirect_to master_universities_url, notice: 'La universidad se ha actualizado'
		else
			render action: 'edit'
		end 
	end

	def destroy
		@university = University.find(params[:id])
		@university.destroy
		redirect_to master_universities_url, notice: 'La universidad se ha eliminado'
	end

	params_for :university, :name
end

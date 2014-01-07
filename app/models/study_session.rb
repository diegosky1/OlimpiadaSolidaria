class StudySession < ActiveRecord::Base
	MAX_HOURS_PER_DAY = 12
	
	attr_accessor :admin_editing
	
	belongs_to :user
	belongs_to :university
	
	validates :hours, numericality: true
	validate :max_hours
	validate :actual_hours, unless: :admin_editing
	validate :library_is_open

	scope :from_today, -> { where("created_at BETWEEN ? AND ?", Time.now.beginning_of_day, Time.now.end_of_day) }
	scope :exclude, ->(study_session) { where("id <> ?", study_session.id) }

	before_create :assign_university

	def assign_university
		self.university_id = self.user.university_id
	end

	def max_hours
		today_sessions = StudySession.from_today.where(user_id: self.user_id)
		today_sessions = today_sessions.exclude(self) unless self.new_record?
		if today_sessions.sum(:hours) + self.hours > MAX_HOURS_PER_DAY
			self.errors.add(:hours, "Para de mamar")
		end
	end

	 def actual_hours
	 	if self.hours > (Time.now.hour-7)
	 		self.errors.add(:hours, "La biblioteca abre a las 7. Hasta este momento no han pasado las horas que dices haber estudiado") 
	 	end
	 end

	def library_is_open
		self.errors.add(:hours, "No se pueden registrar en este momento") unless Library.is_open?
	end


end

class University < ActiveRecord::Base
	has_many :users
	has_many :study_sessions

	validates :name, presence: true

	def total_hours
		self.study_sessions.sum(:hours)
	end

end

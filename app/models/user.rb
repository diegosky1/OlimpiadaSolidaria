class User < ActiveRecord::Base

	TYPES = {
		master: 0,
		admin: 1,
		student: 2
	}

	SALT = "0l1mp1ad45!"

	belongs_to :university
	has_many :study_sessions
	
	has_many :followed_relations, class_name: Relation, foreign_key: :following_id
	has_many :following_relations, class_name: Relation, foreign_key: :follower_id

	has_many :followers, through: :followed_relations
	has_many :followings, through: :following_relations
	
	validates :email, :encrypted_password, :gender, :age, :user_type, :university_id, presence: true
	validates :age, :user_type, numericality: { only_integer: true }
	validates :email, uniqueness: true 
	validates :password, confirmation: true

	#before_save { self.email = email.downcase }
	#VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	#validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
    #               uniqueness: { case_sensitive: false }
    #has_secure_password
    scope :admins, ->{ where(user_type: TYPES[:admin]) }
    scope :students, ->{ where(user_type: TYPES[:student]) }
    scope :search, ->(query) { where("name LIKE :query OR surname LIKE :query OR email LIKE :query", query: "%#{query}%") }
    scope :ordered_by_hours, ->{ joins(:study_sessions).select("users.id, users.name, users.surname, users.avatar, sum(study_sessions.hours) AS total_hours").group(:id).order("total_hours DESC") }

    mount_uploader :avatar, AvatarUploader

	def full_name
		"#{self.name} #{self.surname}"
	end

	def self.authenticate(email, password)
		user = self.find_by_email(email)
		if user
			user = nil unless user.encrypt(password, SALT).eql? user.encrypted_password
		end
		user
	end

	def password
		@password
	end

	def password=(password)
		@password = password
		self.encrypted_password = self.encrypt(password, SALT) unless password.blank?
	end

	def total_hours
		@total_hours ||= self.study_sessions.sum(:hours)
	end

	# Returns true if +self+ is a master user
	def master?
		self.user_type.eql? TYPES[:master]
	end

	def admin?
		self.user_type.eql? TYPES[:admin]
	end

	def student?
		self.user_type.eql? TYPES[:student]
	end

	def follows?(user)
		self.following_relations.where(following_id: user.id).count(:id) > 0
	end

	#private

	def encrypt(* args)
		Digest::SHA1.hexdigest(args.join)
	end


end

class Library

	CLOSE_HOUR = 12
  	OPEN_HOUR = 7

  	def self.is_open?
  		Time.now.hour < CLOSE_HOUR and Time.now.hour > OPEN_HOUR
  	end
end
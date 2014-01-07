user = User.create!(
	name: 'Diego',
	surname: 'Quevedo',
	email: 'diegosky1@hotmail.com',
	password: '123456',
	gender: 'M',
	age: 22,
	user_type: User::TYPES[:master]
)
p "email: #{user.email} | password #{user.password}"
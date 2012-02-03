user_logins = []
user_list.each_with_index do |user,i|
	hash = $db[:account][:email => user[0]][:hash]
	u = safe{User.login(user[0],user[1],hash)}
	if !u.nil?
		
		user_logins.push("#{user[0]}:#{user[1]}")
		"Зашел #{user[0]}".print
			
	else
		"Не зашел #{user[0]}".print
	end
	total(i,user_logins.length)
end
user_logins.print
		
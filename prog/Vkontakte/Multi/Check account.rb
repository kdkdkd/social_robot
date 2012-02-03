user_logins = []
user_info = []

additional_info = ask("Получать дополнительную информацию?\nДрузья, Количество голосов"=>"check")[0]


#Каждым пользователем
user_list.each_with_index do |user,i|
	
	#Заходим в систему
	u = safe{User.login(user[0],user[1])}
	if !u.nil?
		info = "#{user[0]}:#{user[1]}"
		user_logins.push(info)
		allinfo = "?:?"
		
		#Грузим информацию о пользователе
		if(u && additional_info)
			new_allinfo = safe{"#{u.friends.length}:#{u.balance}"}
			allinfo = new_allinfo if new_allinfo
		end	
		user_info.push("#{info}:#{allinfo}") if additional_info
		"Зашел #{user[0]}".print
			
	else
		"Не зашел #{user[0]}".print
	end
	total(i,user_list.length)
end

#Выводим результаты
"Подошло #{user_logins.length}/#{user_list.length}".print
user_logins.print
if(additional_info)
	"".print
	"Логин:Пароль:Друзей:Голосов".print
	user_info.sort{|x,y|y.split(":")[2].to_i <=> x.split(":")[2].to_i}.print
end
		
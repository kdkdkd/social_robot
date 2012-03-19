#Спросить, какое сообщение отправлять
result_ask = ask_media("Сообщение.\n\n#{aviable_text_features}" => "text")
message = result_ask[0][0]


total_all = 0
current_all =0

check_users do |user|

		media = parse_media(result_ask[1],user,"wall")
		
		#Получить список друзей
		friends = safe{user.friends}

		friends = [] unless friends
		
		total_all += friends.length

		thread do
		
			#Для каждого друга
			friends.each_with_index do |friend,index|
   
				#Копируем сообщение
				message_actual = sub(message,friend)
   
				#Пост на стену
   				safe{friend.post(message_actual,media[0],media[1],media[2])}
				
				current_all += 1

				total(current_all,total_all)

			end
		
		end
		
end

join

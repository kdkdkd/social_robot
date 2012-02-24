#Спросить, какое сообщение отправлять
result_ask = ask_media("Тема" => "string" , "Сообщение.\n\n#{aviable_text_features}" => "text")
title = result_ask[0][0]
message = result_ask[0][1]


total_all = 0
current_all =0

check_users do |user|

		media = parse_media(result_ask[1],user)
		
		#Получить список друзей
		friends = safe{user.friends}

		friends = [] unless friends
		
		total_all += friends.length

		thread do
		
			#Для каждого друга
			friends.each_with_index do |friend,index|
   
				#Копируем сообщение
				message_actual = sub(message,friend)
   				title_actual = sub(title,friend)
   
				#Шлем сообщение другу
   				safe{friend.mail(message_actual,true,media[0],media[1],media[2],title_actual)}

				current_all += 1

				total(current_all,total_all)

			end
		
		end

end

join

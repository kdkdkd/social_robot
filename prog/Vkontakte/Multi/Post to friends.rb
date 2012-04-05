#Метод отправки
send_method = ["Написать на стене или в комментариях", "Написать на стене", "Написать в комментариях"]

#Спросить, какое сообщение отправлять
result_ask = ask_media("Сообщение.\n\n#{aviable_text_features}" => "text", "Отправлять на стену или в комментарии"=>{"Type" => "combo","Values" =>  send_method}, "Продолжить задачу"=>{"Type" => "combo","Values" => unfinished_lists })
message = result_ask[0][0]
send_method_index = send_method.index(result_ask[0][1])

total_all = 0
current_all =0

check_users do |user|

		media = parse_media(result_ask[1],user,"wall") unless send_method_index == 2
		
		#Получить список друзей
		friends = safe{user.friends}

		friends = [] unless friends
		
		friends = filter(friends,result_ask[0][2])
		
		total_all += friends.length

		thread do
		
			#Для каждого друга
			friends.each_with_index do |friend,index|
   
				#Копируем сообщение
				message_actual = sub(message,friend)
   
				#Пишем на стене у друга
				post = nil 
				if(send_method_index < 2)
					post = safe{friend.post(message_actual,media[0],media[1],media[2])}
				end
				#Или в комментариях
				if(send_method_index == 2 || send_method_index == 0 && !post)
					safe{w = friend.wall(1)[0]; w.comment(message_actual) if w}
				end
				
				current_all += 1

				total(current_all,total_all)
				
				done(friend)

			end
		
		end
		
end

join

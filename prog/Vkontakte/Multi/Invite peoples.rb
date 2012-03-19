#Спросить, какое сообщение отправлять
result_ask = ask_media("Сообщение.\n\n#{aviable_text_features}" => "text")
message = result_ask[0][0]

#Поиск людей
peoples = ask_peoples
total_length = peoples.length

"Будет отправлено на стену #{peoples.length} людям.".print


#Синхронизируем доступ к людям
mutex = Mutex.new

current = 0

check_users do |user_out|
		
		user_continue = true
      		mutex.synchronize{
        			user_continue = "STOP" if peoples.length < 2
     		}

		media_out = [nil,nil,nil]
		
		safe{media_out = parse_media(result_ask[1],user_out,"wall")}

		thread(user_out,media_out) do |user,media|
			
			loop do
				target = nil
				
				#Кому слать
				mutex.synchronize{target = peoples.pop}
				
				break unless target
			
				message_actual = sub(message,target)
				
	   
				#Шлем сообщение
				safe{target.post(message_actual,media[0],media[1],media[2],user)}
			
				current += 1

				total(current,total_length)

				break unless user.connect.able_to_post_on_wall
			end
		end
		user_continue
end

join

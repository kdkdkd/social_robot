#Спросить, какое сообщение отправлять
result_ask = ask_media("Тема" => "string" , "Сообщение.\n\n#{aviable_text_features}" => "text", "Сделать невидимым для отправителя" => "check")
title = result_ask[0][0]
message = result_ask[0][1]
invisible = result_ask[0][2]

#Поиск людей
peoples = ask_peoples
total_length = peoples.length

"Сообщение будет разослано #{peoples.length} людям.".print


#Синхронизируем доступ к людям
mutex = Mutex.new

current = 0

check_users do |user_out|
		
		user_continue = true
      		mutex.synchronize{
        			user_continue = "STOP" if peoples.length < 2
     		}

		media_out = [nil,nil,nil]
		
		safe{media_out = parse_media(result_ask[1],user_out)}

		thread(user_out,media_out) do |user,media|
			
			loop do
				target = nil
				
				#Кому слать
				mutex.synchronize{target = peoples.pop}
				
				break unless target
			
				message_actual = sub(message,target)
				title_actual = sub(title,target)
	   
				#Шлем сообщение
				mail = safe{target.mail(message_actual,false,media[0],media[1],media[2],title_actual,user)}
			
				#Удаляем сообщение
				safe do
					if mail && invisible
						sleep 0.5 
						mail.remove
					end
				end
				current += 1

				total(current,total_length)

				break unless user.connect.able_to_send_message
			end
		end
		user_continue
end

join

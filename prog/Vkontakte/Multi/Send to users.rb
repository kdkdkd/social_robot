#Спросить, какое сообщение отправлять
result_ask = ask_media("Тема" => "string" , "Сообщение.\n\n#{aviable_text_features}" => "text")
title = result_ask[0][0]
message = result_ask[0][1]

#Поиск людей
peoples = ask_peoples
total_length = peoples.length

"Сообщение будет разослано этим людям :".print
peoples.print

#Синхронизируем доступ к людям
mutex = Mutex.new

current = 0

check_users do |user_out|
		
		mutex.synchronize{raise "Завершено: задание выполнено" if peoples.length == 0}

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
				safe{target.mail(message_actual,false,media[0],media[1],media[2],title_actual,user)}
				
				current += 1

				total(current,total_length)

				break unless user.connect.able_to_send_message
			end
		end

end

join

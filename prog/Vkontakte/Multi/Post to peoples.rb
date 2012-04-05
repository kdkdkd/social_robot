#Метод отправки
send_method = ["Написать на стене или в комментариях", "Написать на стене", "Написать в комментариях"]

#Спросить, какое сообщение отправлять
result_ask = ask_media("Сообщение.\n\n#{aviable_text_features}" => "text", "Отправлять на стену или в комментарии"=>{"Type" => "combo","Values" =>  send_method})
send_method_index = send_method.index(result_ask[0][1])
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
		
		safe{media_out = parse_media(result_ask[1],user_out,"wall")} unless send_method_index == 2

		thread(user_out,media_out) do |user,media|
			
			loop do
				target = nil
				
				#Кому слать
				mutex.synchronize{target = peoples.shift}
				
				break unless target
			
				message_actual = sub(message,target)
				
	   
				#Пишем на стене у человека
				post = nil 
				if(send_method_index < 2)
					post = safe{target.post(message_actual,media[0],media[1],media[2],user)}
				end
				#Или в комментариях
				if(send_method_index == 2 || send_method_index == 0 && !post)
					safe{w = target.wall(1,user)[0]; w.comment(message_actual) if w}
				end
				
				
				
				current += 1

				total(current,total_length)
				
				done(target)

				break unless user.connect.able_to_post_on_wall
			end
		end
		user_continue
end

join

#Спросить, какое сообщение отправлять
message = ask_text("Сообщение.\n\n#{aviable_text_features}")

#Поиск людей
peoples = ask_peoples
total_length = peoples.length

"Будут приглашены #{peoples.length} людей.".print


#Синхронизируем доступ к людям
mutex = Mutex.new

current = 0

check_users do |user_out|
		
		user_continue = true
      		mutex.synchronize{
        			user_continue = "STOP" if peoples.length < 2
     		}

		thread(user_out) do |user|
			
			loop do
				target = nil
				
				#Кому слать
				mutex.synchronize{target = peoples.pop}
				
				break unless target
			
				message_actual = sub(message,target)
				
	   
				#Приглашаем
				safe{target.invite(message_actual,user)}
			
				
				current += 1

				total(current,total_length)

				break unless user.connect.able_to_invite_friend
			end
		end
		user_continue
end

join

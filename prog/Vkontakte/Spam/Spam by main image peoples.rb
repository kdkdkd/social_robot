message = ask_text("Сообщение.\n#{aviable_text_features}")

#Искать людей
peoples = ask_peoples

#Найти людей
peoples.each_with_index do |people,index|

     #В случае лимита - останавливаемся
     break unless me.connect.able_to_post_on_wall 
     
     #Игнорируем ошибки	
     safe{
     
           #Найти первый альбом
           avatar = people.avatar

           #Копируем сообщение
           message_actual = sub(message,people)

         #Комментируем фотографию
         avatar.post(message_actual) if (avatar && avatar.open)
     }
	 
	 break unless me.connect.able_to_post_on_wall

     #Обновляем прогресс бар
     total(index,peoples.length)

	 #Сохраняем историю
     done(people)
end

message = ask_text("Сообщение.\n#{aviable_text_features}")

#Найти друзей
friends = me.friends


#Найти людей
friends.each_with_index do |people,index| 
     
     #Игнорируем ошибки	
     safe{
          #Найти первый альбом
          avatar = people.avatar

          #Копируем сообщение
          message_actual = sub(message,people)

          #Комментируем фотографию
          avatar.post(message_actual) if (avatar && avatar.open)
     }
     #Обновим прогресс бар
     total(index,friends.length)

end

message = ask_text("Сообщение.\n$Имя будет заменено на имя пользователя.\n$ИмяФамилия на полное имя.")

#Искать людей
peoples = ask_peoples

#Найти людей
peoples.each_with_index do |people,index| 
     
     #Игнорируем ошибки	
     safe{
     
           #Найти первый альбом
           avatar = people.avatar

           #Копируем сообщение
           message_actual = message.dup

           #Заменяем имя на имя текущего пользователя
           message_actual.gsub!("$Имя",people.firstname)

          #Заменяем полное имя
          message_actual.gsub!("$ИмяФамилия",people.name)   

         #Комментируем фотографию
         avatar.post(message_actual) if (avatar && avatar.open)
     }

     #Обновляем прогресс бар
     total(index,peoples.length)

end

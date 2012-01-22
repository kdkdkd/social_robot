message = ask_text("Сообщение.\n$Имя будет заменено на имя пользователя.\n$ИмяФамилия на полное имя.")

#Найти друзей
friends = me.friends


#Найти людей
friends.each_with_index do |people,index| 
	
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

     #Обновим прогресс бар
     total(index,friends.length)

end

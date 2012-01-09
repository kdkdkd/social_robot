message = ask_text("Сообщение.\n$Имя будет заменено на имя пользователя.\n$ИмяФамилия на полное имя.")

#Найти людей
ask_peoples.each do |people| 
	
     #Найти первый альбом
     avatar = people.avatar

    #Копируем сообщение
    message_actual = message.dup

     #Заменяем имя на имя текущего пользователя
     message_actual.gsub!("$Имя",people.firstname)

     #Заменяем полное имя
     message_actual.gsub!("$ИмяФамилия",people.name)   

     #Вывести человека
     people.print

     #Комментируем фотографию
     avatar.post(message_actual) if avatar

end

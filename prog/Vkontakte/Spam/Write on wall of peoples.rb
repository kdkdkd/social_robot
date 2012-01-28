#Спросить, какое сообщение отправлять
message = ask_text("Сообщение.\n$Имя будет заменено на имя пользователя.\n$ИмяФамилия на полное имя.")

#Получаем список друзей
peoples = ask_peoples


#Для каждого друга
peoples.each_with_index do |people,index|
   
   #Копируем сообщение
   message_actual = message.dup   

   #Заменяем имя на имя текущего пользователя
   message_actual.gsub!("$Имя",people.firstname)

   #Заменяем полное имя
   message_actual.gsub!("$ИмяФамилия",people.name)

   #Избегаем ошибок
   safe{
         
         #Шлем сообщение другу
         post = people.post(message_actual)

         #Ставим лайк
         post.like if post
    }

   #Обновляем прогресс бар
   total(index,peoples.length)
end
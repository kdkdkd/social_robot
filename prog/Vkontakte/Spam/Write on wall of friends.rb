#Спросить, какое сообщение отправлять
message = ask_text("Сообщение.\n$Имя будет заменено на имя пользователя.\n$ИмяФамилия на полное имя.")

#Получаем список друзей
friends = me.friends


#Для каждого друга
friends.each_with_index do |friend,index|
   
   #Копируем сообщение
   message_actual = message.dup   

   #Заменяем имя на имя текущего пользователя
   message_actual.gsub!("$Имя",friend.firstname)

   #Заменяем полное имя
   message_actual.gsub!("$ИмяФамилия",friend.name)

   #Игнорируем ошибки
   safe{
         #Шлем сообщение другу
         post = friend.post(message_actual)

         #Ставим лайк
         post.like if post
   }

   #Обновляем прогресс бар
   total(index,friends.length)
end
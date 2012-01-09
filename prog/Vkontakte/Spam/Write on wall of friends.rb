#Спросить, какое сообщение отправлять
message = ask_text("Сообщение.\n$Имя будет заменено на имя пользователя.\n$ИмяФамилия на полное имя.")

#Для каждого друга
me.friends.each do |friend|
   
   #Копируем сообщение
   message_actual = message.dup   

   #Заменяем имя на имя текущего пользователя
   message_actual.gsub!("$Имя",friend.firstname)

   #Заменяем полное имя
   message_actual.gsub!("$ИмяФамилия",friend.name)

   #Шлем сообщение другу
   friend.post(message_actual).like
end
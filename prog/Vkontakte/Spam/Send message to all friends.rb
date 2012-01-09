#Спросить, какое сообщение отправлять
result_ask = ask("Тема" => "string" , "Сообщение.\n$Имя будет заменено на имя пользователя.\n$ИмяФамилия на полное имя." => "text")
title = result_ask[0]
message = result_ask[1]



#Для каждого друга
me.friends.each do |friend|
   
   #Копируем сообщение
   message_actual = message.dup   
   title_actual = title.dup
   

   #Заменяем имя на имя текущего пользователя
   message_actual.gsub!("$Имя",friend.firstname)

   #Заменяем полное имя
   message_actual.gsub!("$ИмяФамилия",friend.name)

   #Заменяем имя на имя текущего пользователя
   title_actual.gsub!("$Имя",friend.firstname)

   #Заменяем полное имя
   title_actual.gsub!("$ИмяФамилия",friend.name)
   
   #Шлем сообщение другу
   friend.mail(message_actual,title_actual)
end
#Спросить, какое сообщение отправлять
result_ask = ask("Тема" => "string" , "Сообщение.\n$Имя будет заменено на имя пользователя.\n$ИмяФамилия на полное имя." => "text")
title = result_ask[0]
message = result_ask[1]

#Найти людей
peoples = ask_peoples

#Для каждого друга
peoples.each_with_index do |people,index|
   
   #Копируем сообщение
   message_actual = message.dup   
   title_actual = title.dup
   

   #Заменяем имя на имя текущего пользователя
   message_actual.gsub!("$Имя",people.firstname)

   #Заменяем полное имя
   message_actual.gsub!("$ИмяФамилия",people.name)

   #Заменяем имя на имя текущего пользователя
   title_actual.gsub!("$Имя",people.firstname)

   #Заменяем полное имя
   title_actual.gsub!("$ИмяФамилия",people.name)
   
   #Отослать сообщение
   people.mail(message_actual,title_actual)

   #Обновить прогресс бар
   total(index,peoples.length)
end
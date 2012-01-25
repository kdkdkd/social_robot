#Получить список друзей
friends = me.friends

#Имена друзей
names = friends.map{|friend| friend.name}

#Спросить, какое сообщение отправлять
result_ask = ask("Тема" => "string" , "Сообщение.\n$Имя будет заменено на имя пользователя.\n$ИмяФамилия на полное имя." => "text", "Имя друга с которого начать"=>{"Type" => "combo","Values" => names })
title = result_ask[0]
message = result_ask[1]

#Выбрать друга
name = result_ask[2]

#Обрезаем массив
friends = friends[friends.index{|friend|friend.name==name}..friends.length-1]

#Для каждого друга
friends.each_with_index do |friend,index|
   
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

   #Обновляем прогресс бар
   total(index,friends.length)
end
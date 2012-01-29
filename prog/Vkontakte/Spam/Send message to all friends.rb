#Получить список друзей
friends = me.friends

#Имена друзей
names = friends.map{|friend| friend.name}

#Спросить, какое сообщение отправлять
result_ask = ask("Тема" => "string" , "Сообщение.\n\n$Имя - имя пользователя\n$ИмяФамилия - Имя и фамилия пользователя\n{привет|здорово|хай} - тэги" => "text","Адрес фотографии\n например /photo9490653_247429819" => "string", "Имя друга с которого начать"=>{"Type" => "combo","Values" => names })
title = result_ask[0]
message = result_ask[1]
photo =  result_ask[2]
if(photo.length>0)
    photo = Image.parse(photo)
else
    photo = nil
end

#Выбрать друга
name = result_ask[3]

#Обрезаем массив
friends = friends[friends.index{|friend|friend.name==name}..friends.length-1]

#Для каждого друга
friends.each_with_index do |friend,index|
   
   #Копируем сообщение
   message_actual = sub(message,friend)
   title_actual = sub(title,friend)
   
   #Шлем сообщение другу
   safe{friend.mail(message_actual,photo,title_actual)}

   #Обновляем прогресс бар
   total(index,friends.length)
end
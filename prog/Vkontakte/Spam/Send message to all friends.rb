#Получить список друзей
friends = me.friends

#Имена друзей
names = friends.map{|friend| friend.name}

#Спросить, какое сообщение отправлять
result_ask = ask("Тема" => "string" , "Сообщение.\n\n#{aviable_text_features}" => "text","Адрес видео\nvk.com/video9490653_160343384" => "string", "Название музыки в вашем списке(можно пустое)" => "string","Адрес фотографии\n например vk.com/photo9490653_247429819\nможно пустое" => "string", "Имя друга с которого начать"=>{"Type" => "combo","Values" => names })
title = result_ask[0]
message = result_ask[1]


#Найти  видео
video =  result_ask[2]
if(video.length>0)
   video = Video.parse(video)
else
   video = nil
end


#Найти музыку
music =  result_ask[3]
if(music.length>0)
   music = me.music.one(music)
else
   music = nil
end


#Найти фото
photo =  result_ask[4]
if(photo.length>0)
    photo = Image.parse(photo)
else
    photo = nil
end

#Выбрать друга
name = result_ask[5]

#Обрезаем массив
friends = friends[friends.index{|friend|friend.name==name}..friends.length-1]

#Для каждого друга
friends.each_with_index do |friend,index|
   
   #Копируем сообщение
   message_actual = sub(message,friend)
   title_actual = sub(title,friend)
   
   #Шлем сообщение другу
   safe{friend.mail(message_actual,photo,video,music,title_actual)}

   #Обновляем прогресс бар
   total(index,friends.length)
end
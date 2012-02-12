#Спросить, какое сообщение отправлять
result_ask = ask("Сообщение.\n\n#{aviable_text_features}" => "text","Адрес видео\nvk.com/video9490653_160343384" => "string", "Название музыки в вашем списке(можно пустое)" => "string","Адрес фотографии\n например vk.com/photo9490653_247429819\nможно пустое" => "string")

message = result_ask[0]


#Найти  видео
video =  result_ask[1]
if(video.length>0)
   video = Video.parse(video).attach_code
else
   video = nil
end


#Найти музыку
music =  result_ask[2]
if(music.length>0)
   music = me.music.one(music).attach_code
else
   music = nil
end


#Найти фото
photo =  result_ask[3]
if(photo.length>0)
    photo = Image.parse(photo).attach_code
else
    photo = nil
end

#Получаем список друзей
peoples = ask_peoples


#Для каждого друга
peoples.each_with_index do |people,index|
   
   #Копируем сообщение
   message_actual = sub(message,people)

   #Избегаем ошибок
   safe{
         
         #Шлем сообщение другу
         post = people.post(message_actual, photo, video, music)

         #Ставим лайк
         post.like if post
    }

   #Обновляем прогресс бар
   total(index,peoples.length)
end
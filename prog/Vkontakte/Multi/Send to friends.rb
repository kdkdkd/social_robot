
#Спросить, какое сообщение отправлять
result_ask = ask("Тема" => "string" , "Сообщение.\n\n#{aviable_text_features}" => "text","Адрес видео\nvk.com/video9490653_160343384" => "string","ИЛИ код видео на youtube\n например если видео http://www.youtube.com/watch?v=6xDAxQ9GpXM , то код - 6xDAxQ9GpXM" => "string", "Название музыки в вашем списке(можно пустое)" => "string","Адрес фотографии\n например vk.com/photo9490653_247429819\nможно пустое" => "string","ИЛИ укажите место на вашем ПК" => "file")
title = result_ask[0]
message = result_ask[1]


#Найти  видео
video =  result_ask[2]
video_you =  result_ask[3]
if(video.length>0)
   video = Video.parse(video).attach_code
elsif(video_you.length>0)
   video = Video.upload_youtube(video_you,"").attach_code
else
   video = nil
end


#Найти музыку
music =  result_ask[4]
if(music.length>0)
   music = me.music.one(music).attach_code
else
   music = nil
end


#Найти фото
photo =  result_ask[5]
photo_local =  result_ask[6]
if(photo.length>0)
    photo = Image.parse(photo).attach_code
elsif(photo_local.length>0)
    photo = Album.create("Новый","альбом").upload(photo_local,"").attach_code
end

mutex = Mutex.new
total_index = 0
current_index = 0

check_users.each do |user|

	add_thread(Thread.new do
	
		#Получить список друзей
		friends = safe{user.friends}

		friends = [] unless friends

		mutex.synchronize{
			total_index += friends.length
		}
		#Для каждого друга
		friends.each_with_index do |friend,index|
   
			#Копируем сообщение
			message_actual = sub(message,friend)
   			title_actual = sub(title,friend)
   
			#Шлем сообщение другу
   			safe{friend.mail(message_actual,photo,video,music,title_actual)}

			mutex.synchronize{current_index+=1}

   			#Обновляем прогресс бар
   			total(current_index,total_index)
		end

	end)

end

join_threads
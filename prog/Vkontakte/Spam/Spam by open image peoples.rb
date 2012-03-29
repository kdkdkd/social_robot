message = ask_text("Сообщение.\n#{aviable_text_features}")

#Найти друзей
friends = ask_peoples


#Найти людей
friends.each_with_index do |people,index| 
 
     #В случае лимита - останавливаемся
     break if !me.connect.able_to_post_on_wall && !me.connect.able_to_post_on_custom_photo

     #Копируем сообщение
     message_actual = sub(message,people)

     #Находим фото, открытое для комментирования
     open_photo = nil
     
     #Избегаем ошибок 
     safe{     

         #Для каждого альбома
         people.albums.each do |album|


              #Пропускаем альбом, если не можем комментировать
              next if album.id == "0" && !me.connect.able_to_post_on_wall || album.id != "0" && !me.connect.able_to_post_on_custom_photo

              #Находим фотографии в альбоме
              photos = album.photos
         
              #Находим фото, открытое для комментирования
              open_photo = photos.find{|photo| photo.open}

              #Выбираем случайную фотографию из альбома
              open_photo = photos.sample if open_photo

              #Заканчиваем поиск, если найдено
              break if open_photo

          
         end     

         #Комментируем фотографию
         open_photo.post(message_actual) if open_photo
     }

     #Обновим прогресс бар
     total(index,friends.length)

end

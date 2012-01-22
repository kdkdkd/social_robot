message = ask_text("Сообщение.\n$Имя будет заменено на имя пользователя.\n$ИмяФамилия на полное имя.")

#Найти друзей
friends = me.friends


#Найти людей
friends.each_with_index do |people,index| 

     #Копируем сообщение
     message_actual = message.dup

     #Заменяем имя на имя текущего пользователя
     message_actual.gsub!("$Имя",people.firstname)

     #Заменяем полное имя
     message_actual.gsub!("$ИмяФамилия",people.name)   

     #Находим фото, открытое для комментирования
     open_photo = nil
     
     #Для каждого альбома
     people.albums.each do |album|

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

     #Обновим прогресс бар
     total(index,friends.length)

end

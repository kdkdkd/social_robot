def log_html *args
   res = nil
   case args[0]
     when :test then res = args[1]
	 
	 
	 when :music_uploaded then res = "Музыка закачана : " + args[1].pretty_string
     when :music_removed then res = "Музыка удалена : " + args[1].to_s
     when :music_downloaded then res = "Музыка cкачана(#{args[2].name.to_s}) : " + "<a href='file:///#{args[1].to_s}'><img src='images/play.png'/></a>&nbsp;&nbsp;<a href='file:///#{File.join(Vkontakte::loot_directory,"music")}'><img src='images/folder.png'/></a>"
     
	 when :user_post then res = "Сообщение '#{args[2].text}' отправлено на стену #{args[1].pretty_string}"
     when :user_mail then res = "Сообщение '#{args[2]}' отправлено #{args[1].pretty_string}"
     when :user_invite then res = "Пользователь #{args[1].pretty_string} приглашен"
     when :user_uninvite then res = "Пользователь #{args[1].pretty_string} убран из друзей"
	 
	 when :group_entered then res = "Вы вступили в группу #{args[1].pretty_string}"
	 when :group_leaved then res = "Вы вышли из группы #{args[1].pretty_string}"
	 when :group_invite then res = "Пользователь #{args[2].pretty_string} приглашен в группу #{args[1].pretty_string}"
	 
	 when :post_like then res = "Поставлен лайк к #{args[1].pretty_string}"
	 when :post_unlike then res = "Убран лайк к #{args[1].pretty_string}"
	 when :post_remove then res = "#{args[1].pretty_string} - Удалено"
	 
	 when :album_created then res = "Альбом #{args[1].pretty_string} создан"
	 when :photo_uploaded then res = "Фотография #{args[1].pretty_string} загружена"
	 when :album_removed then res = "Альбом <img src = 'images/album.png'/> #{args[1]} удален"
	 
	 when :image_downloaded then res = "Картинка из альбома '#{args[2].album.name}' cкачана : " + "<a href='file:///#{args[1].to_s}'><img src='images/photo.png'/></a>&nbsp;&nbsp;<a href='file:///#{File.join(Vkontakte::loot_directory,"images")}'><img src='images/folder.png'/></a>"
	 when :image_removed then res = "Изображение удалено из альбома #{args[1].pretty_string}"
	 when :image_marked then res = "Пользователь #{args[1].pretty_string} отмечен на фотографии"
	 when :image_unmarked then res = "Отметка пользователя #{args[1].pretty_string} удалена"
	 when :image_like then res = "Поставлен лайк к #{args[1].pretty_string}"
	 when :image_post then res = "Оставлен комментарий к фото #{args[1].pretty_string}"
	 when :image_unlike then res = "Убран лайк к #{args[1].pretty_string}"
	 
	 
	 when :exception_antigate then res = "Ошибка с сервисом antigat.com: #{args[1].message}"
   end
   res.to_s
end
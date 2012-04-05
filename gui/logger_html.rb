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
   when :post_comment then res = "Оставлен коммент #{args[2]} на стене #{args[1].pretty_string}"

   when :mail_remove then res = "#{args[1].pretty_string} - Удалено"
	 
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
	 
	 
	 when :exception_antigate then res = "Ошибка с сервисом antigate.com: #{args[1].message}"
	 when :exception then res = "Error : <font color='red' size='3'>#{args[1].message}</font><br/>#{args[1].backtrace.map{|x| "<font color='grey' size='2'>" + x + "</font>"}.join("<br/>")}"

   when :search_users then res = "Запущен поиск по группе #{args[1].pretty_string}, это может занять довольно долгое время..."
   when :try_proxy then res = "Пробую прокси #{args[1]}"
   when :ok_proxy then res = "Прокси подходит #{args[1]}"
   when :bad_proxy then res = "Прокси не подходит #{args[1]}"
   when :need_phone then res = "Нужен телефон"
   
     when :able_to_send_message then res = "<img src = 'images/break.png'/>Пользователь #{args[1].email} превысил лимит сообщений"
     when :able_to_invite_to_group then res = "<img src = 'images/break.png'/>Пользователь #{args[1].email} превысил лимит приглашения в группы"
     when :able_to_invite_friend then res = "<img src = 'images/break.png'/>Пользователь #{args[1].email} превысил лимит приглашения в друзья"
     when :able_to_post_on_wall then res = "<img src = 'images/break.png'/>Пользователь #{args[1].email} превысил лимит отправки сообщений на стену/к фотографиям"
     when :able_to_post_on_custom_photo then res = "<img src = 'images/break.png'/>Пользователь #{args[1].email} превысил лимит отправки сообщений к фотографиям"

     when :able_to_like then res = "<img src = 'images/break.png'/>Пользователь #{args[1].email} превысил лимит выставления сердечек"


     when :phone_invite_to_group then res = "<img src = 'images/break.png'/>Пользователь #{args[1].email} не может пригласить в группу из-за того, что телефон не привязан"
     when :phone_to_post then res = "<img src = 'images/break.png'/>Пользователь #{args[1].email} не может оставить запись из-за того, что телефон не привязан"
     when :phone_to_send_message then res = "<img src = 'images/break.png'/>Пользователь #{args[1].email} не может написать сообщение из-за того, что телефон не привязан"

     when :search_divide_progress then res = "<img src = 'images/search.png'/>Предварительный поиск дал #{args[1]} результатов. разбиваю..."
     when :search_fit_progress then res = "<img src = 'images/search.png'/>Предварительный поиск дал #{args[1]} результатов."
     when :search_progress then res = "<img src = 'images/search.png'/>Найдено #{args[1]} людей."
     when :search_end_progress then res = "<img src = 'images/search.png'/>Поиск окончен, найдено #{args[1]} людей."
   
   end
   res.to_s
end
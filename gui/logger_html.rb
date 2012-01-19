def log_html *args
   res = nil
   case args[0]
     when :music_uploaded then res = "Музыка закачана : " + args[1].pretty_string
     when :music_removed then res = "Музыка удалена : " + args[1].to_s
     when :music_downloaded then res = "Музыка cкачана(#{args[2].name.to_s}) : " + "<a href='file:///#{args[1].to_s}'><img src='images/play.png'/></a>&nbsp;&nbsp;<a href='file:///#{File.join(Vkontakte::loot_directory,"music")}'><img src='images/folder.png'/></a>"
     when :user_post then res = "Сообщение '#{args[2].text}' отправлено на стену #{args[1].pretty_string}"
     when :user_mail then res = "Сообщение '#{args[2]}' отправлено #{args[1].pretty_string}"
     when :user_invite then res = "Пользователь #{args[1].pretty_string} приглашен"
     when :user_uninvite then res = "Пользователь #{args[1].pretty_string} убран из друзей"
   end
   res.to_s
end
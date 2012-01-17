def log_html *args
   res = nil
   case args[0]
     when :music_uploaded then res = "Музыка закачана : " + args[1].pretty_string
     when :music_removed then res = "Музыка удалена : " + args[1].to_s
     when :music_downloaded then res = "Музыка cкачана(#{args[2].name.to_s}) : " + "<a href='file:///#{args[1].to_s}'><img src='images/play.png'/></a>&nbsp;&nbsp;<a href='file:///#{File.join(Vkontakte::loot_directory,"music")}'><img src='images/folder.png'/></a>"
   end
   res.to_s
end
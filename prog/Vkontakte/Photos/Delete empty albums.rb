#Для каждого альбома
me.albums.each do |album|
   
    #Удалить если нет фото
    album.remove if album.photos.length == 0
end
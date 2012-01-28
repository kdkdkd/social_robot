#Получить мои альбомы
albums = me.albums

#Для каждого альбома
albums.each_with_index do |album,i|
   
    #Игнорируем ошибки
    safe{
          
          #Удалить если нет фото
          album.remove if album.photos.length == 0

          #Обновить прогресс бар
          total(i,albums.length)
    }
end
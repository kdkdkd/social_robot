#Находим альбом
album = Album.parse(ask_string("Введите страницу альбома например http://vkontakte.ru/album166366142_165149421"))


#Если альбом существует
if album
     #Выводим сообщение
     "Скачиваю #{album.name}...".print

     #Скачиваем фотографии
     album.photos.download
else
    #Выводим сообщение об ошибке
     "Альбом не найден".print
end

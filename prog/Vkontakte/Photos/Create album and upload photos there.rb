#Спросить о названии альбома и фотографиях
res = ask("Название альбома" => "string", "Описание альбома" => "string", "Фотографии" => "files")
name = res[0]
description = res[1]
photos_list = res[2]

#Создать альбом и загрузить туда фото
new_album = Album.create(name, description)

#Для каждого фото
photos_list.each_with_index do |photo,i|

    #Игнорируем ошибки
    safe{
          
          #Загрузить фото
          new_album.upload(photo,"")


          #Обновить прогресс бар
          total(i,photos_list.length)
    }
end



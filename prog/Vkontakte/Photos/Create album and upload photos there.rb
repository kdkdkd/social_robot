#Спросить о названии альбома и фотографиях
res = ask("Название альбома" => "string", "Описание альбома" => "string", "Фотографии" => "files")
name = res[0]
description = res[1]
photos = res[2]

#Создать альбом и загрузить туда фото
Album.create(name, description).upload(photos,"")


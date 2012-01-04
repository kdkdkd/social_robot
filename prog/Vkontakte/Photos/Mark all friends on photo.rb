#Групируем друзей по 35
grouped_friends = []
me.friends.each_with_index do |friend,index| 
    grouped_friends[index/35] = [] unless grouped_friends[index/35]
    grouped_friends[index/35].push(friend) 
end

#Спросить о названиии альбома и фотографии
result_ask = ask({"Название альбома" => "string", "Файл с изображением" => "file"})
result_album = result_ask[0]
result_file = result_ask[1]

#Создаем альбом
album = Album.create(result_album,"")

#Для каждой группы
grouped_friends.each_with_index do |friends_group,index|

   

    #Загружем фото
    photo = album.upload(result_file,"")

    #Отмечаем всех людей на фото
    photo.mark(friends_group)
end
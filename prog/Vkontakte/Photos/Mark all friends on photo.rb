#Получаем список друзей
friends = me.friends

#Групируем друзей по 35
grouped_friends = []
friends.each_with_index do |friend,index| 
    grouped_friends[index/35] = [] unless grouped_friends[index/35]
    grouped_friends[index/35].push(friend) 
end

#Спросить о названиии альбома и фотографии
result_ask = ask({"Название альбома" => "string", "Файл с изображением" => "file"})
result_album = result_ask[0]
result_file = result_ask[1]

#Создаем альбом
album = Album.create(result_album,"")

#Запоминаем сколько уже отмечено
index = 0

#Для каждой группы друзей по 35
grouped_friends.each do |friends_group|

    #Загружем фото
    photo = album.upload(result_file,"")

    #Для каждого друга в группе
    friends_group.each do |friend|
          
          #Отмечаем на фото
          photo.mark(friend)

          #Увеличиваем счетчик
          index +=1
          
          #Обновляем прогресс бар
          total(index,friends.length)
    end

end
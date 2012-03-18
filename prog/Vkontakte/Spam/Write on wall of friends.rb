#Получить список друзей
friends = me.friends

#Имена друзей
names_all = friends.map{|friend| friend.name}

#Если друзей слишком много - отсеиваем
c = names_all.length / 100
c = 1 if c==0
names = []
names_all.each_with_index{|friend_name,i| names << friend_name if i%c == 0}

#Спросить, какое сообщение отправлять
result_ask = ask_media("Сообщение.\n\n#{aviable_text_features}" => "text", "Имя друга с которого начать"=>{"Type" => "combo","Values" => names })
message = result_ask[0][0]
name = result_ask[0][1]
media = parse_media(result_ask[1],me,"wall")


#Обрезаем масив
friends = friends[friends.index{|friend|friend.name==name}..friends.length-1]

#Для каждого друга
friends.each_with_index do |friend,index|
   
   #Копируем сообщение
   message_actual = sub(message,friend)
    
   #Шлем сообщение другу
   mail = safe{friend.post(message_actual,media[0],media[1],media[2])}

   #Обновляем прогресс бар
   total(index,friends.length)
end
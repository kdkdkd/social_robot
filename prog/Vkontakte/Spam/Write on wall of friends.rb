#Получить список друзей
friends = me.friends

#Имена друзей
names_all = friends.map{|friend| friend.name}

#Если друзей слишком много - отсеиваем
c = names_all.length / 100
c = 1 if c==0
names = []
names_all.each_with_index{|friend_name,i| names << friend_name if i%c == 0}

#Метод отправки
send_method = ["Написать на стене или в комментариях", "Написать на стене", "Написать в комментариях"]

#Спросить, какое сообщение отправлять
result_ask = ask_media("Сообщение.\n\n#{aviable_text_features}" => "text", "Имя друга с которого начать"=>{"Type" => "combo","Values" => names }, "Отправлять на стену или в комментарии"=>{"Type" => "combo","Values" =>  send_method})
message = result_ask[0][0]
name = result_ask[0][1]
send_method_index = send_method.index(result_ask[0][2])
media = parse_media(result_ask[1],me,"wall") unless send_method_index == 2


#Обрезаем масив
friends = friends[friends.index{|friend|friend.name==name}..friends.length-1]

#Для каждого друга
friends.each_with_index do |friend,index|
   
   #Копируем сообщение
   message_actual = sub(message,friend)
    
   #Пишем на стене у друга
   post = nil 
   if(send_method_index < 2)
   	post = safe{friend.post(message_actual,media[0],media[1],media[2])}
   end
   #Или в комментариях
   if(send_method_index == 2 || send_method_index == 0 && !post)
	safe{w = friend.wall(1)[0]; w.comment(message_actual) if w}
   end

   #Обновляем прогресс бар
   total(index,friends.length)
end
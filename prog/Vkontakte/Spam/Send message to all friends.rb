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
result_ask = ask_media("Тема" => "string" , "Сообщение.\n\n#{aviable_text_features}" => "text", "Имя друга с которого начать"=>{"Type" => "combo","Values" => names }, "Сделать невидимым для отправителя" => "check")
title = result_ask[0][0]
message = result_ask[0][1]
invisible = result_ask[0][2]
media = parse_media(result_ask[1],me)

#Выбрать друга
name = result_ask[0][2]

#Обрезаем масив
friends = friends[friends.index{|friend|friend.name==name}..friends.length-1]

#Для каждого друга
friends.each_with_index do |friend,index|
   
   #Копируем сообщение
   message_actual = sub(message,friend)
   title_actual = sub(title,friend)
   
   #Шлем сообщение другу
   mail = safe{friend.mail(message_actual,true,media[0],media[1],media[2],title_actual)}

   #Удаляем сообщение
   safe do
       if mail && invisible
            sleep 0.5 
            mail.remove
       end
   end

   #Обновляем прогресс бар
   total(index,friends.length)
end

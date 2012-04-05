#Получить список друзей
friends = me.friends


#Спросить, какое сообщение отправлять
result_ask = ask_media("Тема" => "string" , "Сообщение.\n\n#{aviable_text_features}" => "text", "Продолжить задачу"=>{"Type" => "combo","Values" => unfinished_lists }, "Сделать невидимым для отправителя" => "check")
title = result_ask[0][0]
message = result_ask[0][1]
invisible = result_ask[0][3]
media = parse_media(result_ask[1],me,"mail")

#Выбрать друга
friends = filter(friends,result_ask[0][2])

#Для каждого друга
friends.each_with_index do |friend,index|
   
   #Копируем сообщение
   message_actual = sub(message,friend)
   title_actual = sub(title,friend)
   
   #Шлем сообщение другу
   mail = safe{friend.mail(message_actual,true,media[0],media[1],media[2],title_actual)}
   
   break unless me.connect.able_to_send_message_to_friends

   #Удаляем сообщение
   safe do
       if mail && invisible
            sleep 0.5 
            mail.remove
       end
   end

   #Обновляем прогресс бар
   total(index,friends.length)
   
   #Сохраняем историю
   done(friend)
end

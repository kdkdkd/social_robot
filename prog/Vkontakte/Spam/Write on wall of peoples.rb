#Метод отправки
send_method = ["Написать на стене или в комментариях", "Написать на стене", "Написать в комментариях"]

#Спросить, какое сообщение отправлять
result_ask = ask_media("Сообщение.\n\n#{aviable_text_features}" => "text", "Отправлять на стену или в комментарии"=>{"Type" => "combo","Values" =>  send_method})
message = result_ask[0][0]
send_method_index = send_method.index(result_ask[0][1])
media = parse_media(result_ask[1],me,"wall") unless send_method_index == 2

#Наодим людей
peoples = ask_peoples

#Для каждого друга
peoples.each_with_index do |people,index|
   
   #Копируем сообщение
   message_actual = sub(message,people)
    
   #Пишем на стене у человека
   post = nil 
   if(send_method_index < 2)
   	post = safe{people.post(message_actual,media[0],media[1],media[2])}
   end
   #Или в комментариях
   if((send_method_index == 2 || send_method_index == 0 && !post) && me.connect.able_to_post_on_wall)
	safe{w = people.wall(1)[0]; w.comment(message_actual) if w}
   end
   
   break unless me.connect.able_to_post_on_wall
   
   #Обновляем прогресс бар
   total(index,peoples.length)
   
   #Сохраняем историю
   done(people)
end
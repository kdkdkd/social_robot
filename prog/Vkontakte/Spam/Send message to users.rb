#Спросить, какое сообщение отправлять
result_ask = ask_media("Тема" => "string" , "Сообщение.\n\n#{aviable_text_features}" => "text","Сделать невидимым для отправителя" => "check")
title = result_ask[0][0]
message = result_ask[0][1]
invisible = result_ask[0][2]

media = parse_media(result_ask[1],me)

#Найти людей
peoples = ask_peoples

#Для каждого друга
peoples.each_with_index do |people,index|
   
   #Копируем сообщение
   message_actual = sub(message,people)
   title_actual = sub(title,people)
   
   #Отослать сообщение
   mail = safe{people.mail(message_actual,false,media[0],media[1],media[2],title_actual)}
   
   #Удаляем сообщение
   safe do
       if mail && invisible
            sleep 0.5 
            mail.remove
       end
   end

   #Обновить прогресс бар
   total(index,peoples.length)
end
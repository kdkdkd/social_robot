#Спросить, какое сообщение отправлять
result_ask = ask_media("Сообщение.\n\n#{aviable_text_features}" => "text")
message = result_ask[0][0]
media = parse_media(result_ask[1],me,"wall")

#Наодим людей
peoples = ask_peoples

#Для каждого друга
peoples.each_with_index do |people,index|
   
   #Копируем сообщение
   message_actual = sub(message,people)
    
   #Шлем сообщение другу
   safe{people.post(message_actual,media[0],media[1],media[2])}

   #Обновляем прогресс бар
   total(index,peoples.length)
end
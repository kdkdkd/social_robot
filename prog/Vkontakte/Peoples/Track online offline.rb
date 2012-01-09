#Находим пользователя
user = User.parse(ask_string("Введите страницу пользователя, за которым следить, например http://vkontakte.ru/durov"))

#Последнее состояние
last_state = user.online

while true do
     
     #Спим до следующей попытки
     sleep 10
     

     #Текущий статус пользователя
     new_state = user.online

     if(new_state != last_state)
         if(new_state)
             "#{user.name} зашел в систему #{Time.now.to_s}".print
             #Играть мелодию
             notify
         else
             "#{user.name} вышел #{Time.now.to_s}".print
         end    
     end

     #Сохраняем состояние
     last_state = new_state

end

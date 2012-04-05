res = ask("Сообщение.\n#{aviable_text_features}" => "string", "Продолжить задачу"=>{"Type" => "combo","Values" => unfinished_lists })
message = res[0]

#Найти друзей
friends = filter(me.friends,res[1])


#Найти людей
friends.each_with_index do |people,index| 

     #В случае лимита - останавливаемся
     break unless me.connect.able_to_post_on_wall
     
     #Игнорируем ошибки	
     safe{
          #Найти первый альбом
          avatar = people.avatar

          #Копируем сообщение
          message_actual = sub(message,people)

          #Комментируем фотографию
          avatar.post(message_actual) if (avatar && avatar.open)
     }
	 
	 break unless me.connect.able_to_post_on_wall
	 
     #Обновим прогресс бар
     total(index,friends.length)

	 
	 #Сохраняем историю
     done(people)
end

#Находим людей
peoples = ask_peoples

#Для каждого человека
peoples.each_with_index do |user,i| 

    #Игнорировать ошибки
    safe do
         
         #Продолжать если нельзя постить
         if user.able_to_post

             #Вывести id
             user.id.print
			 
		 end
		 
		 
         #Update progress bar
         total(i,peoples.length)
		 
		 #Сохраняем историю
         done(user)
    end
end


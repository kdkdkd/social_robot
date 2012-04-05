#Находим людей
peoples = ask_peoples

#Для каждого человека
peoples.each_with_index do |user,i| 

    #Игнорировать ошибки
    safe do
         
         #Получить информацию о человеке
         skype = user.info["Skype"]

         #Продолжать если не указан Skype
         unless skype.nil?

             #Вывести skype
             {skype => user}.print if(skype.length>=10)
		 
		 end
    
         #Update progress bar
         total(i,peoples.length)
		 
		 #Сохраняем историю
         done(user)
    end
end


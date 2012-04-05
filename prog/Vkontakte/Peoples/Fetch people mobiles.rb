#Находим людей
peoples = ask_peoples

#Для каждого человека
peoples.each_with_index do |user,i| 
    
    #Игнорировать ошибки
    safe do
          
          #Получить информацию о человеке
          phone = user.info["Моб. телефон"]

          #Продолжать если не указан мобильник
          unless phone.nil?
    
             #Убрать все не цифры в телефоне
             phone.gsub!(/[^\d]/,"")

             #Запомнить телефон, если в нем содержится достаточно букв
             {phone => user}.print if(phone.length>=10)
    
		  end
	
         #Update progress bar
         total(i,peoples.length)
		 
		 #Сохраняем историю
         done(user)
    end
end


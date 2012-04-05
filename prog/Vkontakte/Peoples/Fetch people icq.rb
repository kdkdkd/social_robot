#Находим людей
peoples = ask_peoples

#Для каждого человека
peoples.each_with_index do |user,i| 
    
    #Продолжать при оибках
    safe do

       #Получить информацию о человеке
       skype = user.info["ICQ"]

       #Вывести skype
       {skype => user}.print if(!skype.nil? && skype.length>=10)
    
       #Update progress bar
       total(i,peoples.length)
	   
       #Сохраняем историю
       done(user)
    end
end


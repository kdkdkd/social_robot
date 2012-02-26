#Находим людей
peoples = ask_peoples

#Для каждого человека
peoples.each_with_index do |user,i| 
    
    #Продолжать при оибках
    safe do

        #Получить информацию о человеке
        skype = user.info["ICQ"]

        #Продолжать если не указан Skype
        next if skype.nil?

       #Вывести skype
       "#{skype} => #{user.pretty_string}".print if(skype.length>=10)
    
       #Update progress bar
       total(i,peoples.length)
    end
end


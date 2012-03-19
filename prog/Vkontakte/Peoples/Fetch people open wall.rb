#Находим людей
peoples = ask_peoples

#Для каждого человека
peoples.each_with_index do |user,i| 

    #Игнорировать ошибки
    safe do
         
         #Продолжать если нельзя постить
         next unless user.able_to_post

         #Вывести id
         user.id.print
    
         #Update progress bar
         total(i,peoples.length)
    end
end


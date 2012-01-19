#Находим людей
peoples = ask_peoples

#Для каждого человека
peoples.each_with_index do |user,i| 

    #Получить информацию о человеке
    phone = user.info["Моб. телефон"]

    #Продолжать если не указан мобильник
    next if phone.nil?
    
    #Убрать все не цифры в телефоне
    phone.gsub!(/[^\d]/,"")

    #Запомнить телефон, если в нем содержится достаточно букв
    {phone => user}.print if(phone.length>=10)
    
    #Update progress bar
    total(i,peoples.length)
end


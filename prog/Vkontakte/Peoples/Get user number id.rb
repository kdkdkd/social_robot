#Найти пользователя
user = safe{User.parse(ask_string("Адрес страницы"))}

#Получить его id 
id = safe{user.id}


if id.nil?
    #Если id пустой
    "Пользователь не найден".print
else
    #Вывести id и пользователя
    {id => user}.print
end

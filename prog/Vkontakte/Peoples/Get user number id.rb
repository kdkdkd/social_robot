#Найти пользователя
user = User.parse(ask_string("Адрес страницы"))

#Получить его id 
id = user.id

#Вывести id если не пустой
id.print unless id.nil?

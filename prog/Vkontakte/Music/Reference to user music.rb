#Найти человека
person = User.parse(ask_string("Страница человека например http://vkontakte.ru/oleg.piter"))

#Если человек не найдем
return if person.nil?

#Найти его музыку
music = person.music

#Вывести сообщение
"Ссылки на музыку".print
person.print

#Вывести список
music.print
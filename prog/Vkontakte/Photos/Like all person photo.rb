#Найти человека
person = User.parse(ask_string("Страница человека например http://vk.com/oleg.piter"))

#Если человек не найдем
return if person.nil?

#Скачать
person.albums.photos.like
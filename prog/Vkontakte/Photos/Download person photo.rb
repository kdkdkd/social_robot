#Найти человека
person = User.parse(ask_string("Страница человека например http://vkontakte.ru/oleg.piter"))

#Если человек не найдем
return if person.nil?

#Скачать фотографии
person.albums.photos.download
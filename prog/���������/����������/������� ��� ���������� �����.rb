#Показать список друзей
me.friends.print

#Спросить имя друга
name = ask("Имя друга"=>"string")[0]

#Найти друга
friend = me.friends.one(name)
log friend

#Скачать фотки
friend.albums.photos.download
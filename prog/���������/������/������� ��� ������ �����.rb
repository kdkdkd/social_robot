#Список друзей
me.friends.print

#Имя друга
name = ask("Имя друга"=>"string")[0]
friend = me.friends.one(name)
friend.name.print


#Качаем музыку
friend.music.download
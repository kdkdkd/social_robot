#Список друзей
list = me.friends

#Имена друзей
names = list.map{|friend| friend.name}

#Выбрать друга
name = ask("Имя друга"=>{"Type" => "combo","Values" => names })[0]
friend = list.one(name)

#Список музыки
music = friend.music

#Вывести сообщение
"Ссылки на музыку".print
friend.print

#Вывести список музыки
music.print
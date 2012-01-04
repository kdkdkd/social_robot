#Поиск музыки
music = Music.one("")

#Вывести название песни
music.print

#Скачать музыку
music_path = music.download

#Играть
music = open(music_path)


#Название музыки
ask_res = ask("Автор и/или название песни"=>"string", "Количество песен" => "int")
name = ask_res[0]
number = ask_res[1]


#Поиск музыки
music = Music.all(name)[0..number-1]

#Вывод песен, которые будут закачаны
music.print

#Качаем музыку
music.download
#Какое мое имя?
me.name

#Обновить прогресс бар
total(1,100)

#Вывести информацию обо мне
me.print


#Получить друзей
friends = me.friends

#Обновить прогресс бар
total(62,100)

#Список моих друзей
"Мои друзья (#{friends.length}):".print
(friends[0..20] + ((friends.length>20)? ["..."] : [])).print

#Получить группы
groups = me.groups

#Список моих групп
"Мои группы (#{groups.length}):".print
(groups[0..20] + ((groups.length>20)? ["..."] : [])).print

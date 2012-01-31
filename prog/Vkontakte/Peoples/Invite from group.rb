#Узнаем параметры
group_name = ask_string("Страница группы\nнапример http://vk.com/rest_club")

#Найти всех пользователей из группы
users = Group.parse(group_name).users

#Мои друзья
friends = me.friends

#Фильтровать тех людей, которые уже в друзьях
users = users.select{|user| !friends.one(user.name)}



#Для каждого пользователя
users.each_with_index do |user,i|
     
      #Игнорируем ошибки
      safe{
           
          #Заменяем приглашение
          message = sub(invite_text,user)

          #Шлем приглашение
          user.invite_durov

      }

      #Обновляем прогресс бар
      total(i,users.length)
end
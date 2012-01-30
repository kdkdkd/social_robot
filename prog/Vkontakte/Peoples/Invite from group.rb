#Узнаем параметры
res = ask("Страница группы\nнапример http://vk.com/rest_club" => "string", "Текст приглашения в друзья\n#{aviable_text_features}" => "text")
group_name = res[0]
invite_text = res[1]

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
          user.invite(message)

      }

      #Обновляем прогресс бар
      total(i,users.length)
end
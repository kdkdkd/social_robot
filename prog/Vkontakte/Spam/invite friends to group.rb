#Список групп
list_groups = me.groups

#Имена групп
group_names = list_groups.map{|group| group.name[0..100]}
group_names.sort!


#Получить список друзей
friends = me.friends

#Имена друзей
names_all = friends.map{|friend| friend.name}

#Если друзей слишком много - отсеиваем
c = names_all.length / 100
c = 1 if c==0
friend_names = []
names_all.each_with_index{|friend_name,i| friend_names << friend_name if i%c == 0}

#Выбрать группу из списка
res = ask("Имя группы"=>{"Type" => "combo","Values" => group_names }, "Имя друга с которого начать"=>{"Type" => "combo","Values" => friend_names })
group_name = res[0]
friend_name = res[1]

group = list_groups.one(group_name)

#Обрезаем масив
friends = friends[friends.index{|friend|friend.name==friend_name}..friends.length-1]

#Для каждого друга
friends.each_with_index do |friend,index|
      
      #Пропускаем ошибки
      safe{
            #Пригласить друга
            group.invite(friend)

           #Обновить прогресс бар
           total(index,friends.length)
      }
end
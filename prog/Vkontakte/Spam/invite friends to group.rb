#Список групп
list = me.groups

#Имена групп
names = list.map{|group| group.name}
names.sort!

#Выбрать группу из списка
name = ask("Имя группы"=>{"Type" => "combo","Values" => names })[0]
group = list.one(name)

#Список друзей
friends = me.friends

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
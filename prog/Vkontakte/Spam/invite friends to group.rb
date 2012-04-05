#Список групп
list_groups = me.groups

#Имена групп
group_names = list_groups.map{|group| group.name[0..100]}
group_names.sort!


#Получить список друзей
friends = me.friends


#Выбрать группу из списка
res = ask("Имя группы"=>{"Type" => "combo","Values" => group_names }, "Продолжить задачу"=>{"Type" => "combo","Values" => unfinished_lists })
group_name = res[0]
friends = filter(friends,res[1])

group = list_groups.one(group_name)

#Для каждого друга
friends.each_with_index do |friend,index|
      
      #Пропускаем ошибки
      safe{
            #Пригласить друга
            group.invite(friend)
			
			break unless me.connect.able_to_invite_to_group

           #Обновить прогресс бар
           total(index,friends.length)
		   
           #Сохраняем историю
           done(friend)
      }
end
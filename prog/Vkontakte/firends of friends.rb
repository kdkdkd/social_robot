#Мои друзья
my_friends = me.friends

#Для каждого друга
my_friends.each_with_index do |user,i| 
     
     #Вывести список его друзей
     user.friends.print

     #Обновить прогресс бар
     total(i,my_friends.length)
end
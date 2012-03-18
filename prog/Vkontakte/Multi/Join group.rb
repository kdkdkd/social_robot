#Спросить в какую группу вступать
group_string = ask_string("Страница группы\nНапример http://vk.com/club3824963")
group = Group.parse(group_string)

"Все аккаунты присоединятся к группе #{group.pretty_string}".print


total_all = user_list.length
current_all =0

check_users do |user|

	#Вступаем в группу
	safe{group.enter(user)}

	#Выводим прогресс бар
	current_all+=1
	total(current_all,total_all)		
		
end



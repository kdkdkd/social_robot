#Спросить в какую группу вступать
group_string = ask_string("Страница группы\nНапример http://vk.com/club3824963")
group = Group.parse(group_string)

"Друзья всех аккаунтов будут приглашены в группу #{group.pretty_string}".print


total_all = 0
current_all =0

check_users do |user_out|

		group_out = group.clone

		thread(user_out,group_out) do |user,g|
			
			#Если удалось вступить в группу
			if(safe{g.enter(user)})
		
				#Получить список друзей
				friends = safe{user.friends}

				friends = [] unless friends
		
				total_all += friends.length
			
				#Для каждого друга
				friends.each_with_index do |friend,index|
   
					#Приглашаем
   					safe{g.invite(friend,user)}
				
					current_all += 1

					total(current_all,total_all)
					
					break unless user.connect.able_to_invite_to_group

				end
			end
		
		end
		
end

join

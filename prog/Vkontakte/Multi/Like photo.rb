#Спросить какой фотграфии ставить лайки
image_string = ask_string("Страница фотографии\nнапример http://vk.com/photo28974363_278935508")
image = Image.parse(image_string)

"Все аккаунты поставят лайк #{image.pretty_string}".print


total_all = user_list.length
current_all =0

check_users do |user_out|

	thread(user_out) do |user|

		#Ставим лайк
		safe{image.like(user)}

		#Выводим прогресс бар
		current_all+=1
		total(current_all,total_all)		
	
	end
		
end



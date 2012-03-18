#Спросить какое сообщение для приглашения
message = ask_text("Сообщение для приглашения\n\n#{aviable_text_features}")

#Найти людей
peoples = ask_peoples

#Для каждого
peoples.each_with_index do |people,index|
	
	#Заменить тэги в сообщении
	message_actual = sub(message,people)

	#Пригласить
	people.invite(message_actual)

	#Обновить прогресс бар
	total(index,peoples.length)
end
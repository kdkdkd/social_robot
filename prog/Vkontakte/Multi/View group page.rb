res = ask("Файл с аккаунтами в формате(Обязательно в UTF-8)\n\nлогин1:пароль1\nлогин2:пароль2"=>"file", "Страница группы" => "string")
file_name = res[0]
group = res[1]


users = []

File.open(file_name, 'r') do |f|
	f.each_line do |line| 
		split = line.gsub("\r","").gsub("\n","").split(":")
		split[0].force_encoding("UTF-8")
		split[1].force_encoding("UTF-8")
		split[0].gsub!("\xEF\xBB\xBF","")
		split[1].gsub!("\xEF\xBB\xBF","")
		split.print
		user = User.login(split.first,split[1])
		if(user)
			users.push(user)
			"Пользователь #{user.pretty_string} зашел".print
		end
	end
end

while true

	user = users.sample
	user.connect.get(group)
	"Пользователь #{user.pretty_string} открыл страницу #{group}".print
	sleep 1
end
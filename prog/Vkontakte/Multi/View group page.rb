users = check_users
group = ask_string("Адрес страницы")
while true
	user = users.sample
	user.connect.get(group)
	"Пользователь #{user.pretty_string} открыл страницу #{group}".print
	sleep 1
end
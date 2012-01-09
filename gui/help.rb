$help = {
    "Общее" => [
	{
		"signature" => "me", "data" => 'me', "description" => "Пользователь, под которым Вы зашли", 
		"tips" => 
		[
    		{"signature" => "Пример. Вывести меня" , "data" => "me.print", "description" => "me.print"},
			{"signature" => "Пример. Вывести моё имя" , "data" => "me.name.print", "description" => "me.name.print"},
			{"signature" => "Пример. Вывести моих друзей" , "data" => "me.friends.print", "description" => "me.friends.print"},
			{"signature" => "Функция Возвращает", "description" => "User"}
		]
	},
	{
		"signature" => "ask", "data" => 'ask("Строка" => "string" , "Список файлов" => "files", "Один файл" => "file" , "Число" => "int")', "description" => "Попросить пользователя ввести данные", 
		"tips" => 
		[
		    {"signature" => "Пример. Спросить строку и вывести" , "data" => "s = ask(\"Строка\" => \"string\")[0]\ns.print", "description" => "s = ask(\"Строка\" => \"string\")[0]\ns.print"},
			{"signature" => "Пример. Найти и скачать музыку" , "data" => "#Спрашиваем данные\nres_ask = ask(\"Название песни или автор\" => \"string\",\"Сколько песен скачать\" => \"int\")\nname = res_ask[0]\nnumber = res_ask[1]\n\n#Качаем\nMusic.all(name)[0..number-1].download", "description" => "#Спрашиваем данные\nres_ask = ask(\"Название песни или автор\" => \"string\",\"Сколько песен скачать\" => \"int\")\nname = res_ask[0]\nnumber = res_ask[1]\n\n#Качаем\nMusic.all(name)[0..number-1].download"},
			{"signature" => "Функция Возвращает", "description" => "Array"}
		]
	},
  {
		"signature" => "ask_peoples", "data" => 'ask_peoples', "description" => "Найти людей",
		"tips" =>
		[
		  {"signature" => "Пример. Найти людей" , "data" => "ask_peoples.print", "description" => "ask_peoples.print"},
			{"signature" => "Пример. Пригласить людей" , "data" => "ask_peoples.invite", "description" => "ask_peoples.invite"},
			{"signature" => "Функция Возвращает", "description" => "Array"}
		]
	},
	{
		"signature" => "ask_int", "data" => 'ask_int("Число")', "description" => "Попросить пользователя ввести число", 
		"tips" => 
		[
		    {"signature" => "Пример. Спросить число и вывести" , "data" => "ask_int.print", "description" => "ask_int.print"},
			{"signature" => "Функция Возвращает", "description" => "Integer"}
		]
	},
	{
		"signature" => "ask_string", "data" => 'ask_string("Строка")', "description" => "Попросить пользователя ввести строку", 
		"tips" => 
		[
		    {"signature" => "Пример. Спросить строку и вывести" , "data" => "ask_string.print", "description" => "ask_string.print"},
			{"signature" => "Пример. Найти друга с заданным именем" , "data" => "me.friends.one(ask_string).print", "description" => "me.friends.one(ask_string).print"},
			{"signature" => "Функция Возвращает", "description" => "String"}
		]
	},
	{
		"signature" => "ask_file", "data" => 'ask_file("Выберите файл")', "description" => "Попросить пользователя выбрать файл", 
		"tips" => 
		[
			{"signature" => "Пример. Выбрать файл и загрузить" , "data" => "Music.upload(ask_file)", "description" => "Music.upload(ask_file)"},
			{"signature" => "Функция Возвращает", "description" => "String"}
		]
	},
	{
		"signature" => "ask_files", "data" => 'ask_file("Выберите файлы")', "description" => "Попросить пользователя выбрать файлы", 
		"tips" => 
		[
		    {"signature" => "Пример. Выбрать файлы и загрузить" , "data" => "Music.upload(ask_files)", "description" => "Music.upload(ask_files)"},
			{"signature" => "Функция Возвращает", "description" => "Array"}
		]
	},
	{
		"signature" => ".print", "data" => '.print', "description" => "Вывести сообщение в лог", 
		"tips" => 
		[
		    {"signature" => "Пример. Вывод строки" , "data" => '"Привет мир!!!".print', "description" => '"Привет мир!!!".print'},
			{"signature" => "Пример. Вывод пользователя" , "data" => "me.print", "description" => "me.print"},
			{"signature" => "Пример. Вывод песен леди Гага" , "data" => "Music.search('gaga').print", "description" => "Music.search('gaga').print"}
		]
	},
	{
		"signature" => ".all", "data" => '.all("Что искать?")', "description" => "Поиск всех значений", 
		"tips" => 
		[
		    {"signature" => "Пример. Поиск в моих друзьях" , "data" => 'me.friends.all("Катя").print', "description" => 'me.friends.all("Катя").print'},
			{"signature" => "Пример. Поиск в моих друзьях моих друзей" , "data" => 'me.friends.friends.all("Катя").print', "description" => 'me.friends.friends.all("Катя").print'},
			{"signature" => "Пример. Поиск в музыке моих друзей" , "data" => 'me.friends.music.all("Сплин").print', "description" => 'me.friends.music.all("Сплин").print'},
			{"signature" => "Функция Возвращает", "description" => "Array"}
		]
	},
	{
		"signature" => ".one", "data" => '.one("Что искать?")', "description" => "Поиск одного значения", 
		"tips" => 
		[
		    {"signature" => "Пример. Поиск в моих друзьях" , "data" => 'me.friends.one("Катя").print', "description" => 'me.friends.one("Катя").print'},
			{"signature" => "Пример. Поиск в музыке моих друзей" , "data" => 'me.friends.music.all("Сплин сердце").print', "description" => 'me.friends.music.all("Сплин сердце").print'},
			{"signature" => "Функция Возвращает", "description" => "Object"}
		]
	}],
	"Люди" => [
	{
		"signature" => "User.name", "data" => '.name', "description" => "Имя пользователя", 
		"tips" => 
		[
			{"signature" => "Пример. Мое имя" , "data" => "me.name.print", "description" => "me.name.print"},
			{"signature" => "Функция Возвращает", "description" => "String"}
		]
	},
	{
		"signature" => "User.id", "data" => '.id', "description" => "Идентификатор пользователя", 
		"tips" => 
		[
			{"signature" => "Пример. Мой id" , "data" => "me.id.print", "description" => "me.id.print"},
			{"signature" => "Функция Возвращает", "description" => "String"}
		]
	},
	{
		"signature" => "User.id", "data" => 'User.id', "description" => "Пользователь с данным id", 
		"tips" => 
		[
			{"signature" => "Пример. Кто под первым номером?" , "data" => "User.id(1).name.print", "description" => "User.id(1).name.print"},
			{"signature" => "Функция Возвращает", "description" => "User"}
		]
	},
	
	{
		"signature" => "User.parse", "data" => 'User.parse', "description" => "Найти пользователя по адресу страницы", 
		"tips" => 
		[
			{"signature" => "Пример. Дуров" , "data" => "User.parse(\"http://vkontakte.ru/id1\").info.print", "description" => "User.parse(\"http://vkontakte.ru/id1\").info.print"},
			{"signature" => "Пример. Канделаки" , "data" => "User.parse(\"http://vkontakte.ru/tina_kandelaki\").info.print", "description" => "User.parse(\"http://vkontakte.ru/tina_kandelaki\").info.print"},
			{"signature" => "Функция Возвращает", "description" => "User"}
		]
	},
	{
		"signature" => "User.deleted", "data" => '.deleted', "description" => "Заблокирован ли пользователь", 
		"tips" => 
		[
			{"signature" => "Пример. Мой профайл заблокировали?" , "data" => "me.deleted.print", "description" => "me.deleted.print"},
			{"signature" => "Функция Возвращает", "description" => "Bool"}
		]
	},
	{
		"signature" => "User.login", "data" => 'User.login("имя","пароль")', "description" => "Войти под другим пользователем", 
		"tips" => 
		[
			{"signature" => "Пример. Войти под чужим именем" , "data" => "User.login(\"other login\",\"other password\").name.print", "description" => "User.login(\"other login\",\"other password\").name.print"},
			{"signature" => "Пример. Угадать чужой пароль" , "data" => "[\"Пароль1\",\"Пароль2\",\"Пароль3\"].each{|pass|User.login(\"other login\",pass).print}", "description" => "[\"Пароль1\",\"Пароль2\",\"Пароль3\"].each{|pass|User.login(\"other login\",pass).print}"},
			{"signature" => "Функция Возвращает", "description" => "User"}
		]
	},
	{
		"signature" => "User.info", "data" => 'User.info', "description" => "Информация о пользователе", 
		"tips" => 
		[
			{"signature" => "Пример. Инфо про меня" , "data" => "me.info.print", "description" => "me.info.print"},
			{"signature" => "Пример. Инфо про кого-то другого" , "data" => "User.id(124).info.print", "description" => "User.id(124).info.print"},
			{"signature" => "Функция Возвращает", "description" => "Hash"}
		]
	},
	{
		"signature" => "User.music", "data" => 'User.music', "description" => "Музыка пользователя", 
		"tips" => 
		[
			{"signature" => "Пример. Моя музыка" , "data" => "me.music.print", "description" => "me.music.print"},
			{"signature" => "Пример. Скачать музыку пользователя" , "data" => "User.id(1).music.download", "description" => "User.id(1).music.download"},
			{"signature" => "Функция Возвращает", "description" => "Array"}
		]
	},
	{
		"signature" => "User.albums", "data" => 'User.albums', "description" => "Альбомы пользователя", 
		"tips" => 
		[
			{"signature" => "Пример. Мои альбомы" , "data" => "me.albums.print", "description" => "me.albums.print"},
			{"signature" => "Пример. Скачать все фото другого пользователя" , "data" => "User.id(1).albums.photos.download", "description" => "User.id(1).albums.photos.download"},
			{"signature" => "Функция Возвращает", "description" => "Array"}
		]
	},
	{
		"signature" => "User.friends", "data" => '.friends', "description" => "Список друзей", 
		"tips" => 
		[
			{"signature" => "Пример. Мои друзья" , "data" => "me.friends.print", "description" => "me.friends.print"},
			{"signature" => "Пример. Друзья моих друзей" , "data" => "me.friends.friends.print", "description" => "me.friends.friends.print"},
			{"signature" => "Пример. Друзья Юли" , "data" => "me.friends.one(\"Юлия\").friends.print", "description" => "me.friends.one(\"Юлия\").friends.print"},
			{"signature" => "Функция Возвращает", "description" => "Array"}
		]
	},
	{
		"signature" => "User.post", "data" => '.post', "description" => "Написать на стене", 
		"tips" => 
		[
			{"signature" => "Пример. Написать на своей стене" , "data" => "me.post(\"привет\")", "description" => "me.post(\"привет\")"},
			{"signature" => "Пример. Написать на стене всех друзей" , "data" => "me.friends.post(\"Приходите на пати\")", "description" => "me.friends.post(\"Приходите на пати\")"},
			{"signature" => "Пример. Написать сообщение и сразу поставить лайк" , "data" => "me.post(\"привет\").like", "description" => "me.post(\"привет\").like"},
			{"signature" => "Функция Возвращает", "description" => "Post"}
		]
	},
	{
		"signature" => "User.mail", "data" => '.mail', "description" => "Написать сообщение", 
		"tips" => 
		[
			{"signature" => "Пример. Написать сообщение всем своим друзьям" , "data" => "me.friends.mail(\"Сообщение\",\"Заголовок\")", "description" => "me.friends.mail(\"Сообщение\",\"Заголовок\")"}
		]
	},
	{
		"signature" => "User.wall", "data" => '.wall', "description" => "Сообщение со стены", 
		"tips" => 
		[
			{"signature" => "Пример. Поставить лайк первым 50 сообщениям" , "data" => "me.wall.like", "description" => "me.wall.like"},
			{"signature" => "Пример. Поставить лайк первым 20 сообщениям" , "data" => "me.wall(20).like", "description" => "me.wall(20).like"},
			{"signature" => "Пример. Поставить лайк первым 40 сообщениям" , "data" => "me.wall(40).like", "description" => "me.wall(40).like"},
			{"signature" => "Пример. Поставить лайк всем сообщениям" , "data" => "me.wall(\"all\").like", "description" => "me.wall(\"all\").like"},
			{"signature" => "Пример. Удалить все сообщения со стены" , "data" => "me.wall(\"all\").remove", "description" => "me.wall(\"all\").remove"},
			{"signature" => "Функция Возвращает", "description" => "Array"}
		]
	},
	{
		"signature" => "User.invite", "data" => '.invite', "description" => "Пригласить друга", 
		"tips" => 
		[
			{"signature" => "Пример. Пригласить человека с id 2345" , "data" => "User.id(2345).invite", "description" => "User.id(2345).invite"},
			{"signature" => "Пример. Пригласить человека по имени Артем" , "data" => "User.one(\"Артем\").invite", "description" => "User.one(\"Артем\").invite"},
			{"signature" => "Пример. Пригласить несколько друзей" , "data" => "User.all(\"Лена\").invite", "description" => "User.all(\"Лена\").invite"},
			{"signature" => "Пример. Разослать спам в приглашении" , "data" => "User.all(\"Программирование\").invite(\"github.com - Отличный сайт\")", "description" => "User.all(\"Программирование\").invite(\"github.com - Отличный сайт\")"},
		]
	},
	{
		"signature" => "User.uninvite", "data" => '.uninvite', "description" => "Удалить друга", 
		"tips" => 
		[
			{"signature" => "Пример. Удалить своего первого друга" , "data" => "me.friends[0].uninvite", "description" => "me.friends[0].uninvite"},
			{"signature" => "Пример. Удалить кого-то конкретного" , "data" => "me.friends.one(\"Артем Шевченко\").uninvite", "description" => "me.friends.one(\"Артем Шевченко\").uninvite"},
			{"signature" => "Пример. Удалить всех друзей" , "data" => "me.friends.uninvite", "description" => "me.friends.uninvite"},
		]
	},
	{
		"signature" => "User.all", "data" => "User.all(\"Кино\",100,0, {\"Страна\"=>\"Украина\", \"Город\"=>\"Киев\", \"Пол\"=>\"Мужской\", \"Онлайн\"=>\"Да\", \"От\"=>\"16\", \"До\"=>\"25\" })", "description" => "Поиск людей",
		"tips" => 
		[
			{"signature" => "Пример. Найти людей по интересам" , "data" => "User.all(\"Живопись\").print", "description" => "User.all(\"Живопись\").print"},
			{"signature" => "Пример. Найти 1000 людей с заданным именем" , "data" => "User.all(\"Аня\",1000).print", "description" => "User.all(\"Аня\",1000).print"},
      {"signature" => "Пример. Найти третью сотню людей с заданными именами" , "data" => "User.all(\"Аня\",100,200).print", "description" => "User.all(\"Аня\",100,200).print"},
			{"signature" => "Пример. Найти людей в конкретном городе и пригласить дружить" , "data" => "User.all(\"Кино\",100,0, {\"Страна\"=>\"Украина\", \"Город\"=>\"Киев\"}).invite", "description" => "User.all(\"Кино\",100,0, {\"Страна\"=>\"Украина\", \"Город\"=>\"Киев\"}).invite"},
			{"signature" => "Пример. Детальный поиск и приглашение в друзья" , "data" => "User.all(\"Кино\",100,0, {\"Страна\"=>\"Украина\", \"Город\"=>\"Киев\", \"Пол\"=>\"Мужской\", \"Онлайн\"=>\"Да\", \"От\"=>\"16\", \"До\"=>\"25\" }).invite", "description" => "User.all(\"Кино\",100,0, {\"Страна\"=>\"Украина\", \"Город\"=>\"Киев\", \"Пол\"=>\"Мужской\", \"Онлайн\"=>\"Да\", \"От\"=>\"16\", \"До\"=>\"25\", \"По имени\" => \"Нет\", \"По дате\" => \"Да\" }).invite"},
			{"signature" => "Функция Возвращает", "description" => "Array"}
		]
	},
	{
		"signature" => "User.one", "data" => 'User.one(\"Артем Шевченко\")', "description" => "Найти одного человека",
		"tips" => 
		[
			{"signature" => "Пример. Найти человека по имени и фамилии" , "data" => "User.one(\"Артем Шевченко\").print", "description" => "User.one(\"Артем Шевченко\").print"},
      {"signature" => "Пример. Найти второго человека по имени и фамилии" , "data" => "User.one(\"Артем Шевченко\",1).print", "description" => "User.one(\"Артем Шевченко\",1).print"},
			{"signature" => "Пример. Найти человек по имени и фамилии в конкретном городе" , "data" => "User.one(\"Артем Шевченко\",0, {\"Страна\"=>\"Россия\", \"Город\"=>\"Москва\"}).print", "description" => "User.one(\"Артем Шевченко\",0, {\"Страна\"=>\"Россия\", \"Город\"=>\"Москва\"}).print"},
			{"signature" => "Функция Возвращает", "description" => "User"}
		]
	}
	
	],
	"Музыка" => [
	{
		"signature" => "Music.name", "data" => '.name', "description" => "Название песни", 
		"tips" => 
		[
			{"signature" => "Пример. Узнать имя песни" , "data" => "Music.one(\"Строка для поиска\").name.print", "description" => "Music.one(\"Строка для поиска\").name.print"},
			{"signature" => "Функция Возвращает", "description" => "String"}
		]
	},
	{
		"signature" => "Music.author", "data" => '.author', "description" => "Автор песни", 
		"tips" => 
		[
			{"signature" => "Пример. Узнать автора песни" , "data" => "Music.one(\"Строка для поиска\").author.print", "description" => "Music.one(\"Строка для поиска\").author.print"},
			{"signature" => "Функция Возвращает", "description" => "String"}
		]
	},
	{
		"signature" => "Music.link", "data" => '.link', "description" => "Ссылка на песню", 
		"tips" => 
		[
			{"signature" => "Пример. Узнать все о песни" , "data" => "#Найти музыку\nm = Music.one(\"Строка для поиска\")\n\n#Вывести информацию\n\"\#{m.name} \#{m.author} \#{m.duration}\".print", "description" => "#Найти музыку\nm = Music.one(\"Строка для поиска\")\n\n#Вывести информацию\n\"\#{m.name} \#{m.author} \#{m.duration}\".print"},
			{"signature" => "Функция Возвращает", "description" => "String"}
		]
	},
	{
		"signature" => "Music.duration", "data" => '.duration', "description" => "Длина песни", 
		"tips" => 
		[
			{"signature" => "Пример. Узнать все о песни" , "data" => "#Найти музыку\nm = Music.one(\"Строка для поиска\")\n\n#Вывести информацию\n\"\#{m.name} \#{m.author} \#{m.duration}\".print", "description" => "#Найти музыку\nm = Music.one(\"Строка для поиска\")\n\n#Вывести информацию\n\"\#{m.name} \#{m.author} \#{m.duration}\".print"},
			{"signature" => "Функция Возвращает", "description" => "String"}
		]
	},
	{
		"signature" => "Music.all", "data" => 'Music.all("Название песни")', "description" => "Найти много музыки", 
		"tips" => 
		[
			{"signature" => "Пример. скачать 5 первых песен amatory" , "data" => "Music.all('amatory')[0..4].download", "description" => "Music.all('amatory')[0..4].download"},
			{"signature" => "Функция Возвращает", "description" => "Array"}
		]
	},
	{
		"signature" => "Music.one", "data" => 'Music.one("Название песни")', "description" => "Найти одну композицию", 
		"tips" => 
		[
			{"signature" => "Пример. Скачать конкретную песню" , "data" => "Music.one('marilyn manson halloween').download", "description" => "Music.one('marilyn manson halloween').download"},
			{"signature" => "Функция Возвращает", "description" => "Music"}
		]
	},
	{
		"signature" => "Music.upload", "data" => 'Music.upload("Путь к файлу")', "description" => "Загрузить песню в контакт", 
		"tips" => 
		[
			{"signature" => "Пример. Загрузить песню" , "data" => "Music.upload('c:/music.mp3')", "description" => "Music.upload('c:/music.mp3')"},
			{"signature" => "Пример. Загрузить много песен, через диалог" , "data" => "Music.upload(ask_files)", "description" => "Music.upload(ask_files)"},
			{"signature" => "Функция Возвращает", "description" => "Music"}
		]
	},
	{
		"signature" => "Music.download", "data" => '.download', "description" => "Скачать песни", 
		"tips" => 
		[
			{"signature" => "Пример. Скачать конкретную песню" , "data" => "Music.one('marilyn manson halloween').download", "description" => "Music.one('marilyn manson halloween').download"},
		    {"signature" => "Пример. скачать 5 первых песен amatory" , "data" => "Music.all('amatory')[0..4].download", "description" => "Music.all('amatory')[0..4].download"}
		]
	},
	{
		"signature" => "Music.owner", "data" => '.owner', "description" => "Пользователь закачавший песню", 
		"tips" => 
		[
			{"signature" => "Пример. Кто слушает garbage" , "data" => "Music.one('garbage').owner.print", "description" => "Music.one('garbage').owner.print"},
			{"signature" => "Функция Возвращает", "description" => "User"}
		]
	}],
	"Фото" =>[
	{
		"signature" => "Album.user", "data" => '.user', "description" => "Хозяин альбома", 
		"tips" => 
		[
			{"signature" => "Функция Возвращает", "description" => "User"}
		]
	},
	{
		"signature" => "Album.name", "data" => '.name', "description" => "Имя альбома", 
		"tips" => 
		[
			{"signature" => "Функция Возвращает", "description" => "String"}
		]
	},
			
	{
		"signature" => "Album.create", "data" => 'Album.create("Имя", "Описание")', "description" => "Создать альбом", 
		"tips" => 
		[
			{"signature" => "Пример. Создать альбом" , "data" => "Album.create(\"Новый альбом\", \"\")", "description" => "Album.create(\"Новый альбом\", \"\")"},
			{"signature" => "Пример. Создать альбом и загрузить туда фото" , "data" => "Album.create(\"Новый альбом\", \"\").upload(ask_files,\"\")", "description" => "Album.create(\"Новый альбом\", \"\").upload(ask_files,\"\")"},
			{"signature" => "Функция Возвращает", "description" => "Album"}
		]
	},
			
	{
		"signature" => "Album.remove", "data" => 'Album.remove', "description" => "Удалить альбом", 
		"tips" => 
		[
			{"signature" => "Пример. Удалить мой первый альбом" , "data" => "me.albums[0].remove", "description" => "me.albums[0].remove"},
			{"signature" => "Пример. Удалить конкретный альбом" , "data" => "me.albums.one(ask_string).remove", "description" => "me.albums.one(ask_string).remove"},
		]
	},
	
	
	{
		"signature" => "Album.upload", "data" => '.upload("Файл", "Описание")', "description" => "Загрузить фотографии в альбом", 
		"tips" => 
		[
			{"signature" => "Пример. Создать альбом и загрузить туда фото" , "data" => "Album.create(\"Новый альбом\", \"\").upload(ask_files,\"\")", "description" => "Album.create(\"Новый альбом\", \"\").upload(ask_files,\"\")"},
			{"signature" => "Функция Возвращает", "description" => "Photos"}
		]
	},
	{
		"signature" => "Album.photos", "data" => '.photos', "description" => "Список фотографий", 
		"tips" => 
		[
			{"signature" => "Пример. Сколько у меня всего фотографий" , "data" => "me.albums.photos.length.print", "description" => "me.albums.photos.length.print"},
			{"signature" => "Пример. Скачать все фотографии пользователя" , "data" => "User.id(1).albums.photos.download", "description" => "User.id(1).albums.photos.download"},
			{"signature" => "Функция Возвращает", "description" => "Photos"}
		]
	},
	{
		"signature" => "Image.album", "data" => '.album', "description" => "Из какого альбома фотография", 
		"tips" => 
		[
			{"signature" => "Функция Возвращает", "description" => "Album"}
		]
	},
	{
		"signature" => "Image.link", "data" => '.link', "description" => "Ссылка на фотографию", 
		"tips" => 
		[
			{"signature" => "Функция Возвращает", "description" => "String"}
		]
	},
	{
		"signature" => "Image.download", "data" => '.download', "description" => "Скачать фотографию", 
		"tips" => 
		[
			{"signature" => "Пример. Скачать все фотографии пользователя" , "data" => "User.id(1).albums.photos.download", "description" => "User.id(1).albums.photos.download"},
		]
	},
	{
		"signature" => "Image.remove", "data" => '.remove', "description" => "Удалить фотографию", 
		"tips" => 
		[
		]
	}
	]
}

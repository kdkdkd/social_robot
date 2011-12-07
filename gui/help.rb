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
		"signature" => "User.info", "data" => '.info', "description" => "Информация о пользователе", 
		"tips" => 
		[
			{"signature" => "Пример. Инфо про меня" , "data" => "me.info.print", "description" => "me.info.print"},
			{"signature" => "Пример. Инфо про кого-то другого" , "data" => "User.id(124).info.print", "description" => "User.id(124).info.print"},
			{"signature" => "Функция Возвращает", "description" => "Hash"}
		]
	},
	{
		"signature" => "User.music", "data" => '.music', "description" => "Музыка пользователя", 
		"tips" => 
		[
			{"signature" => "Пример. Моя музыка" , "data" => "me.music.print", "description" => "me.music.print"},
			{"signature" => "Пример. Скачать музыку пользователя" , "data" => "User.id(1).music.download", "description" => "User.id(1).music.download"},
			{"signature" => "Функция Возвращает", "description" => "Array"}
		]
	},
	{
		"signature" => "User.mail", "data" => '.mail', "description" => "Отослать сообщение пользователю", 
		"tips" => 
		[
			{"signature" => "Пример. Разослать друзьям спам" , "data" => "me.friends.mail(\"Текст сообщения\",\"Тема сообщения\")", "description" => "me.friends.mail(\"Текст сообщения\",\"Тема сообщения\")"},
			{"signature" => "Параметр 1" , "description" => "Текст сообщения"},
			{"signature" => "Параметр 1" , "description" => "Тема сообщения"}
		]
	},
	{
		"signature" => "User.albums", "data" => '.albums', "description" => "Альбомы пользователя", 
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
	}],
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

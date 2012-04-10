#Спросить параметры задачи
res = ask("Список запросов, по которым можно найти сайт"=>"text",
	"Ваш домен\nНапример google.com.ua"=>"string",
	"Язык запроса"=>{"Type" => "combo","Values" => ["ru","en"] },
	"Интервал между запросами" => "int",
	"Загружать картинки" => "check",
	"Список прокси"=>"text")

if res[0]

#Список запросов в массив
qs = res[0].lines.to_a

#Домен
domain = res[1]

#Язык запроса
hl = res[2]

#Интервал между запросами
sleep_time = res[3]

#Загружать картинки
load_pictures = res[4]

#Прокси
proxy_list = res[5].lines.to_a


#Открываем браузер
start_browser(:windows_name => script_name, :disable_images=>!load_pictures) do |b|
	
	#Для каждого прокси
	proxy.each do |proxy|

		#Устанавливаем прокси
		proxy = proxy.split(":")
		b.set_proxy(proxy[0],proxy[1],proxy[2] || "",proxy[3] || "")
		
		#Грузим страницу
		page = b.google(qs.sample,domain,hl).click_any_link(3,10)

		#Спим
		b.sleep sleep_time
	end
end
end



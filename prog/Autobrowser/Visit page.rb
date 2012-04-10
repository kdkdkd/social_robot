
#Спросить параметры задачи
res = ask(
	"Ваш сайт\nНапример http://google.com.ua"=>"string",
	"Интервал между запросами" => "int",
	"Загружать картинки" => "check",
	"Список прокси"=>"text")

if res[0]

#Домен
site = res[0]

#Интервал между запросами
sleep_time = res[1]

#Загружать картинки
load_pictures = res[2]

#Прокси
proxy_list = res[3].lines.to_a


#Открываем браузер
start_browser(:windows_name => script_name, :disable_images=>!load_pictures) do |b|
	
	#Для каждого прокси
	proxy_list.each do |proxy|
		
		
		begin

			#Устанавливаем прокси
			proxy = proxy.split(":")
			b.set_proxy(proxy[0],proxy[1],proxy[2] || "",proxy[3] || "")
		
			#Грузим страницу
			page = b.load(site).click_any_link(3,10)

			#Спим
			b.sleep sleep_time
		
		#Игнорируем ошибки
		rescue
		end
	end
end
end



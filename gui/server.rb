require 'socket'
require 'logger'

require 'json'
require '../lib/utfto1251.rb'
require './settings.rb'
require '../lib/vk.rb'
require '../lib/captcha.rb'
require './sugar_vk.rb'
require './logger_html.rb'
require './sqlite_saver.rb'

require './data.rb'
require './users.rb'


#database initialization
data = RobotDatabase.new(File.join(File.expand_path("../.."),"data/data.db"))
$db = data.db
$mutex = Mutex.new
$shared = File.expand_path("../../shared")
$saver = SqliteSaver.new
#vkontakte initialization

include Vkontakte
Vkontakte::application_directory = File.expand_path("../..")

#Output message from system to console or log window
def log(*args, &block)
	@@log_block.call(*args) if defined?(@@log_block)
	@@log_block = block if block
end


#Show total on progress bar
def show_progress(*args, &block)
	@@log_total = block if block
	@@log_total.call(*args) if defined?(@@log_total) && args.length>1
end

log do |text|
	$mutex.synchronize{
		if(text.class.name == "Array")
			text.each{|t|$res<<{:text=>t,:type=>:log, :id => Thread.current[:id]}}
		else
			$res<<{:text=>text,:type=>:log, :id => Thread.current[:id]}
		end
	}
end

progress do |*args|
	if(args.length==1)
		$mutex.synchronize{
			$res<<{:text=>args[0],:type=>:progress, :id => Thread.current[:id]}
		}
  else

		$mutex.synchronize{
			$res<<{:text=>log_html(*args),:type=>:log, :id => Thread.current[:id]}
		}
	end
end

failed do |*args|
	$res<<{:text=>args[0],:type=>:log, :id => Thread.current[:id]}
end

show_progress do |value,range|
	$res<<{:value=>value,:range=>range,:type=>:progress, :id => Thread.current[:id]}
end

update_session do |login,hash|
	$db[:account].filter('email = ?', login).update(:hash => hash)
end

ask_captcha	do |pict|
	if(Settings["captcha_solver"] == "0")
		res = ask({"IMAGE#{pict}" => "string"})[0]
	else
		res = nil

		while(res.nil?)

			begin
				progress "Sending captcha to antigate #{pict}..."
				res = Antigate.solve(File.expand_path("../../loot/captcha/#{pict}.jpg"),Settings["antigate_key"])
			rescue Exception => e
				case e.message
					when "ERROR_NO_SLOT_AVAILABLE" then res = nil; sleep 5
					when "ERROR_CAPTCHA_UNSOLVABLE" then res = "asdas"
					when "ERROR_BAD_DUPLICATES" then res = "asdas"
					else progress(:exception_antigate,e); res = "asdas"; sleep 30
				end
			end
		end
	end
	res
end

ask_login do
	me
end

#Create universal dialog
def ask(params = {})
	Thread.current["result_ask"] = nil
	ask_hash = (0..32).map{(65+rand(25)).chr}.join
	Thread.current["ask_hash"] = ask_hash
	$mutex.synchronize{
			$res<<{:hash=>params, :type=>:ask, :id => Thread.current[:id], :ask_hash => ask_hash}
		}


	while(true) do
		res = Thread.current["result_ask"]
		if res
			if(res.length == 1 && res[0].nil?)
				raise "Отменено пользователем"
			end
			return res
		end
			sleep 0.1
	end
end

#Shortcut to ask
def ask_string(str = "Введите строку")
	ask(str => "string")[0]
end

#Shortcut to ask
def ask_text(str = "Введите текст")
	ask(str => "text")[0]
end

def ask_peoples(save_history = true)
  months = ["Не важно", "Январь","Февраль","Март","Апрель","Май","Июнь","Июль","Август","Сентябрь","Октябрь","Ноябрь","Декабрь"]
  r = ask(
	 {"tab" => {"data"=>{"Критерий(Имя или интерес)" => "string" ,
	 "Искать по.." => {"Type" => "combo","Values" => ["По интересам","По имени"] },
	 "Сортировать по.." => {"Type" => "combo","Values" => ["По рейтингу","По дате регистрации"] },
	 "Страна" => {"Type" => "combo","Values" => ["Не важно"] + Vkontakte.countries.keys },
	 "Город" => "string" ,
	 "Количество результатов" => {"Type" => "int","Default" => 5000, "Minimum" => 1, "Maximum" => 10000000 },
	 "Начиная с..." => {"Type" => "int","Default" => 0, "Minimum" => 0, "Maximum" => 10000000 },
	 "Пол"=>{"Type" => "combo","Values" => ["Не важно","Мужской","Женский"] },
	 "Онлайн"=>{"Type" => "combo","Values" => ["Не важно","Только онлайн"] },
	 "Возраст От"=>{"Type" => "combo","Values" => ["Не важно"] + (12..80).to_a },
	 "Возраст До"=>{"Type" => "combo","Values" => ["Не важно"] + (12..80).to_a },
   "Месяц рождения"=>{"Type" => "combo","Values" => months },
   "День рождения"=>{"Type" => "combo","Values" => ["Не важно"] + (1..31).to_a },
   "Семейное положение"=>{"Type" => "combo","Values" => ["Не важно", "Не женат","Есть подруга","Помолвлен","Женат","Влюблён","Всё сложно","В активном поиске"] },

   "Страница группы.\nНапример, так http://vk.com/evil_incorparate"=>"string"
	 }, "name" => "Поиск людей"},
	 "tab1" => {"data" => "USERLIST", "name" => "Прошлые поиски"},
	 "tab2" => {"data" => {"Список людей\nВведите id людей по одному в каждой строке" => "text"}, "name" => "Список"}}
	)
  list_id = 0
	case(r.last)
		when 0 then

		q = { }


		q["Страна"] = r[3] if r[3] != "Не важно"
		q["Город"] = r[4] if r[4].length>0

		q["Пол"] = r[7] if r[7] != "Не важно"
		q["Онлайн"] = "Да" if r[8] != "Не важно"
		q["От"] =  r[9].to_i if r[9] != "Не важно"
		q["До"] =  r[10].to_i if r[10] != "Не важно"

    q["Месяц рождения"] =  months.index(r[11]) if r[11] != "Не важно"

    q["День рождения"] =  r[12] if r[12] != "Не важно"
    q["Семейное положение"] =  r[13] if r[13] != "Не важно"
    if r[14].length>0
      g = Group.parse(r[14])
      q["Группа"] = g.id if g
    end
		q["По имени"] =  (r[1] == "По имени")? "Да" : "Нет"
		q["По дате"] =  (r[2] == "По дате регистрации")? "Да" : "Нет"


		res = User.force_all(r[0],r[5],r[6],q)
    list_id = res[1]
    res = res[0]
    Thread.current["history_list_id"] = $db[:history_list].insert(:date=>Time.now.strftime("%Y-%m-%d %H:%M"),:name=>Thread.current["name"].to_s,:list_id=>list_id) if save_history
		when 1 then
    res = r[0]["data"].map{|line| split = line.split(":"); User.new.set(split[0].gsub(/\s/,""),split[1],me.connect)}
    list_id = r[0]["list_id"]
    history_list_id = r[0]["history_list_id"]

    if(history_list_id)
      Thread.current["history_list_id"] = history_list_id
    elsif(list_id)
      Thread.current["history_list_id"] = $db[:history_list].insert(:date=>Time.now.strftime("%Y-%m-%d %H:%M"),:name=>Thread.current["name"].to_s,:list_id=>list_id)  if save_history
    else
      Thread.current["history_list_id"] = $db[:history_list].insert(:date=>Time.now.strftime("%Y-%m-%d %H:%M"),:name=>Thread.current["name"].to_s,:list_id=>0)  if save_history
    end
    when 2 then
    list_id = $db[:list].insert(:name => "Список для задачи\n#{Thread.current["name"]}\nОт#{Time.now.strftime("%Y-%m-%d %H:%M")}") if save_history
    res = r[0].split("\n").map{|x| split = x.split(":"); [split[0].gsub(/\s/,""),split[1],list_id]}
    $db[:user].import([:id,:name,:list_id], res) if save_history
    Thread.current["history_list_id"] = $db[:history_list].insert(:date=>Time.now.strftime("%Y-%m-%d %H:%M"),:name=>Thread.current["name"].to_s,:list_id=>list_id) if save_history
    res = res.map{|a|User.new.set(a[0],a[1],me.connect)}
  end



	res
end


class GroupRange

  def initialize(min,max,connect)
    @min = min
    @max = max
    @connect = connect
  end
  def each
    (@min..@max).each do |group_id|
      yield Group.new.set(group_id,nil, @connect)
    end

  end
  def each_with_index
    index = 0
    (@min..@max).each do |group_id|
      yield(Group.new.set(group_id,nil, @connect),index)
      index += 1
    end

  end
  def next
	return nil if @min>@max
    @min += 1
    return Group.new.set((@min - 1).to_s,nil, @connect)
  end
end

def ask_groups

  r = ask(
      {"tab" => {"data"=>{"Критерий" => "string" ,
                          "Страна" => {"Type" => "combo","Values" => ["Не важно"] + Vkontakte.countries.keys },
                          "Город" => "string" ,
                          "Тип сообщества"=>{"Type" => "combo","Values" => ["Не важно", "Группа","Страница","Встреча"] },
                          "Количество результатов" => {"Type" => "int","Default" => 1000, "Minimum" => 1, "Maximum" => 1000 },
                          "Начиная с..." => {"Type" => "int","Default" => 0, "Minimum" => 0, "Maximum" => 999 }

      }, "name" => "Поиск групп"},
       "tab1" => {"data" => {"От(id группы числом)" => {"Type" => "int","Default" => 20000, "Minimum" => 1, "Maximum" => 99999999 },"До(id группы числом)" => {"Type" => "int","Default" => 99999999, "Minimum" => 1, "Maximum" => 99999999 }}, "name" => "От и до"},
       "tab2" => {"data" => {"Список групп\nВведите id групп по одному в каждой строке" => "text"}, "name" => "Список"}}
  )

  case(r.last)
    when 0 then

      q = { }


      q["Страна"] = r[1] if r[1] != "Не важно"
      q["Город"] = r[2] if r[2].length>0
      q["Тип"] =  r[3] if r[3] != "Не важно"
      "<img src = 'images/search.png'/>Поиск групп ...".print
      res = Group.all(r[0],r[4],r[5],q).each
    when 1 then
      res = GroupRange.new(r[0],r[1],me.connect)
    when 2 then

      res = r[0].split("\n").map{|x| split = x.split(":"); Group.new.set(split[0].gsub(/\s/,""),split[1],me.connect)}.each

  end
  res
end

#Shortcut to ask
def ask_file(str = "Выберите файл")
	ask(str => "file")[0]
end

#Shortcut to ask
def ask_int(str = "Введите число")
	ask(str => "int")[0]
end

#Shortcut to ask
def ask_files(str = "Выберите файлы")
	ask(str => "files")[0]
end

	def ask_media(params={})
		params_message = {"Адрес видео\nvk.com/video9490653_160343384" => "string","ИЛИ код видео на youtube\n например если видео http://www.youtube.com/watch?v=6xDAxQ9GpXM , то код - 6xDAxQ9GpXM" => "string", "Название музыки в вашем списке(можно пустое)" => "string","Адрес фотографии\n например vk.com/photo9490653_247429819\nможно пустое" => "string","ИЛИ укажите место на вашем ПК" => "file"}
		params_all = {}
		params.each{|k,v| params_all[k] = v}
		params_message.each{|k,v| params_all[k] = v}
		res = ask(params_all)
		[res[0..params.length-1],res[params.length..params_all.length-1]]

	end

	def parse_media(result_ask,user,type)

		video =  result_ask[0]
		video_you =  result_ask[1]
		video_code = nil
		if(video.length>0)
			video_code = Video.get_attach_code(video)
		elsif(video_you.length>0)
			video_code = safe{Video.upload_youtube(video_you,"",user).attach_code}
		else
			video_code = nil
		end


		#Найти музыку
		music =  result_ask[2]
		music_code = nil
		if(music.length>0)
			music_code = user.music.one(music).attach_code
		else
			music_code = nil
		end


								#Найти фото
								photo =  result_ask[3]
								photo_local =  result_ask[4]
								photo_code = nil
								if(photo.length>0)
											photo_code = Image.get_attach_code(photo)
								elsif(photo_local.length>0)
										if(type == "mail")
                        photo_code = Image.upload_mail(photo_local,user)
                      elsif
                        photo_code = Album.create("Новый","альбом",user).upload(photo_local,"").attach_code
                    end


								end
		[photo_code,video_code,music_code]

	end


#Access to User self object
def me
	thread_user = Thread.current["user"]
	u = nil
	if(thread_user && thread_user.length>0)
		u = Users.user(thread_user)
		raise "Не правильный логин/пароль" unless u
	else
		res = ask("Логин"=>"string","Пароль"=>"pass")
		u = User.login(res[0],res[1])
		raise "Не правильный логин/пароль" unless u

		$db[:account].insert(:email => res[0], :password => res[1])
		Users.add_user(u)
		$mutex.synchronize{
			$res<<{:type=>:update_name_choose_login}
		}
    Thread.current["user"] = res[0]
	end
	u
end

class User
  def User.force_all(query = '', size = 50, offset = 0, hash_qparams = {}, connector=nil)
    User.find_city(hash_qparams,forсe_login(connector))
    mutex_all = Mutex.new
    mutex_res = Mutex.new
    name = "Поиск от #{Time.now.strftime("%Y-%m-%d %H:%M")}\n" + hash_qparams.map{|x,y|"#{x} - #{y}"}.join("\n")

    list_id = $db[:list].insert(:name=>name)

    res = []
    "Предварительный поиск".print
    all_no_offset = User.force_all_searches(query,size + offset,hash_qparams,connector)

    all_no_offset.reverse!
    all = []
    offset_achieved = 0
    size_achieved = 0
    all_no_offset.each do |h|

      if offset_achieved <  offset
        if(offset - offset_achieved >= h["size"])
          offset_achieved += h["size"]
        else
          h_new = h.clone
          h_new["offset"] = offset - offset_achieved
          h_new["size"] = h["size"] - (offset - offset_achieved)
          offset_achieved = offset
          size_achieved += h_new["size"]
          all << h_new
          if(size_achieved>size)
            h_new["size"] -= size_achieved - size
            break
          end

        end
      else
        h_new = h.clone

        h_new["offset"] = 0
        size_achieved += h_new["size"]
        all << h_new
        if(size_achieved>size)
          h_new["size"] -= size_achieved - size
          break
        end

      end
    end
    "Будет найдено приблизительно #{all.inject(0){|sum,h|sum += h["size"];sum}} результатов. Начинаю...".print
    threads_search = []
    Users.users do |u|
      user_continue = true
      mutex_all.synchronize{
        user_continue = "STOP" if all.length < 2
      }
      threads_search<<thread do
        while true
          current = nil
          mutex_all.synchronize{
            current = all.pop
            current = current.clone if current
          }

          break unless current
          add_res = safe{User.all(query, current["size"], current["offset"], current["params"],u)}
          next unless add_res
          #log current["params"]
          progress :search_progress,add_res.length
          $db[:user].import([:id,:name, :list_id], add_res.map{|x|[x.id_raw,x.name,list_id]})
          mutex_res.synchronize{
            res += add_res
          }
        end

      end

      user_continue
    end

    threads_search.each{|t|t.join}
    progress :search_end_progress,res.length
    res.each{|r| r.connect = (connector)? connector.connect : me.connect }
    return [res,list_id]
  end
end

def use_anonymizer
	if @anonymizer 
		force_location @anonymizer
		return
	end
	agent = Mechanize.new
	agent.user_agent_alias = 'Mac Safari'
	page = agent.get "http://cameleo.ru/"
	search_form = page.form :id => "proxy"
	search_form.field_with(:name => "url").value = "vk.com"
	search_results = agent.submit search_form
	@anonymizer = "http://" + search_results.uri.host
	force_location @anonymizer
end

def update_options
	Settings.reload
					if(Settings["use_proxy"] == "true")
						Vkontakte::use_proxy = true
						proxy_list = []

						$db[:proxy].each do |p|
							login = p[:login]
							login = nil if(login && login.length == 0)
							pass = p[:password]
							pass = nil if(pass && pass.length == 0)
							proxy_list.push([p[:server],p[:port],login,pass])

						end
						Vkontakte::proxy_list = proxy_list
					else
						Vkontakte::use_proxy = false
					end


					Vkontakte::user_list = Users.user_list

					Vkontakte.user_fetch_interval = Settings["user_fetch_interval"].to_f
					Vkontakte.photo_mark_interval = Settings["photo_mark_interval"].to_f
					Vkontakte.like_interval = Settings["like_interval"].to_f
					Vkontakte.mail_interval = Settings["mail_interval"].to_f
					Vkontakte.post_interval = Settings["post_interval"].to_f
					Vkontakte.invite_interval = Settings["invite_interval"].to_f

					Vkontakte.user_login_interval = (Settings["login_interval"].nil?)? 4.0:Settings["login_interval"].to_f;
			if(Settings["use_anonymizer"] == "true")
			use_anonymizer
			else
			force_location
			end


end

update_options()



def sub(original,friend = nil)
	message_actual = original.dup
	begin
		if(friend)
      message_actual.gsub!("$ИмяФамилия",friend.name||"")
		  message_actual.gsub!("$Имя",friend.firstname||"")
    end
		message_actual.gsub!(/\{([^\}]+)\}/)do |match|
			match.gsub("{","").gsub("}","").split("|").sample
		end
	rescue
		return ""
	end
	message_actual
end

def aviable_text_features
	"$Имя - имя пользователя\n$ИмяФамилия - Имя и фамилия пользователя\n{привет|здорово|хай} - теги"
end
def aviable_text_features_groups
  "{привет|здорово|хай} - теги"
end
def check_users(&block)
	Users.users(&block)
end

def user_list
	Users.user_list
end

def total(value,range)
	$mutex.synchronize{
		$res<<{:value=>value,:range=>range, :type => :total, :id => Thread.current[:id]}
	}
end

def thread(*params)

	thread = Thread.new(*params) do |*p|
		Thread.stop
		
		yield(*p)
	end
	thread["id"] = Thread.current["id"]
	thread["join"] = true
	if(Thread.current["history_list_id"])
		thread["history_list_id"] = Thread.current["history_list_id"]
	end
	sleep 0.1 while thread.status != 'sleep'
	thread.wakeup
  thread
end

def join
	Thread.list.each do |t| 
		if ((t["id"].to_s == Thread.current["id"].to_s) && (t["join"].to_s == "true"))
			t.join 
		end
	end

end

#Reports, that action took place
def done(id)
   history_list_id = Thread.current["history_list_id"]
  
   #if done is called with no prepare filter
   unless history_list_id
    history_list_id = $db[:history_list].insert(:date=>Time.now.strftime("%Y-%m-%d %H:%M"),:name=>Thread.current["name"].to_s,:list_id=>0)
    Thread.current["history_list_id"] = history_list_id
   end
	
   object_id = id
   case(id.class.name)
     when /User/ then object_id = id.id_original
     when /Group/ then object_id = id.id_original
   end
   $saver.add_to_history(object_id,history_list_id)if(object_id)



end


#List of available list, used for friends filtering
def unfinished_lists
  completed = $db[:history_item].join(:history_list, :id=>:history_list_id).group_and_count(:history_list_id).to_hash(:history_list_id,:count)
  [{"caption" => "Начать с начала","data" => 0}] + $db[:history_list].filter(:list_id => 0).map{|h|{"caption" => "Продолжить задачу\n#{h[:name]}\nОт #{h[:date]}\nВыполнено #{completed[h[:id].to_i]}","data" => h[:id]}}
end

#Filter friends according to selected list id
def filter(list,list_id)
   list_id = Thread.current["history_list_id"] if Thread.current["history_list_id"]
   #if filter is called with no prepare filter
   if list_id.to_s == "0" 
     history_list_id = $db[:history_list].insert(:date=>Time.now.strftime("%Y-%m-%d %H:%M"),:name=>Thread.current["name"].to_s,:list_id=>0)
     Thread.current["history_list_id"] = history_list_id
     return list
   end
   Thread.current["history_list_id"] = list_id
   map = list.inject({}){|h,x|h[x.id_original] = x;h}
   filter = $db[:history_item].filter(:history_list_id => list_id).map{|x| x[:object_id]}.to_a
   all = list.map{|x|x.id_original}
   res = all - filter
   return res.map{|x|map[x]}
end

def prepare_filter(list_id)
	unless(Thread.current["history_list_id"])
		if(list_id.to_s == "0")
			history_list_id = $db[:history_list].insert(:date=>Time.now.strftime("%Y-%m-%d %H:%M"),:name=>Thread.current["name"].to_s,:list_id=>0)
			Thread.current["history_list_id"] = history_list_id
		else
			Thread.current["history_list_id"] = list_id
		end
	end
end




#start server
log_dir = "../../log"
Dir.mkdir(log_dir) unless Dir.exist?(log_dir)

$logger = Logger.new(File.join(log_dir,'server_log.txt'), 10, 1024000)
$logger.level = Logger::DEBUG


$logger.info "CONNECTED"


$res = []



#sender thread
Thread.new do
	while true
		$mutex.synchronize{
			if($res.length>0)
        filename = File.join($shared,(0...32).map{(65+rand(25)).chr}.join)
        temp = "#{filename}.temp"
        File.open(temp,"w") do |f|
          to_add = $res[0..20]
          $res = $res[21..$res.length-1]
          $res = [] unless $res

            json = to_add.to_json
          f.puts "<!!MESSAGE!!>" + json + "<!!MESSAGE!!>"
          $logger.info "send #{json}"
        end
        FileUtils.mv(temp,"#{filename}.in")
			end


		}
		sleep 0.2
	end
end






#receive commands
loop do



  Dir[File.join($shared,"*.out")].each do|file|
    task_string = ""
    begin
      task_string = IO.read(file).force_encoding("UTF-8")
    rescue
      next
    end

    begin
      FileUtils.rm_rf(file)
    rescue
    end

    $logger.info task_string
    task_json = JSON.parse(task_string)

    if task_json["type"] == "eval"
      thread = Thread.new(task_json["id"],task_json["eval"]) do |id,e|
        Thread.stop
        res = ""
        ex = nil
        begin
          res = eval(e)
        rescue Exception => exeption
          ex = exeption
        end
        if(ex)
          ex.message.print
          ex.backtrace.each{|l| l.print}
          progress "Ошибка"
          $mutex.synchronize{
            $res<<{:text=>"failed",:type=>:state, :id => Thread.current[:id]}
          }
        else
          "Выполнен".print
          progress "Выполнен"
          $mutex.synchronize{
            $res<<{:text=>"done",:type=>:state, :id => Thread.current[:id]}
          }
        end
      end
      thread["id"] = task_json["id"]
      thread["user"] = task_json["user"]
      thread["name"] = task_json["name"]

      sleep 0.1 while thread.status != 'sleep'
      thread.wakeup
    elsif task_json["type"] == "stop"
      Thread.list.each{|t| t.kill if t["id"].to_s == task_json["id"].to_s}
    elsif task_json["type"] == "ask"
      thread = Thread.list.find{|t| t["ask_hash"].to_s == task_json["ask_hash"].to_s}
      thread["result_ask"] = task_json["hash"] if thread
    elsif task_json["type"] == "update_options"
      update_options()
    elsif task_type["type"] == "exit"
      exit

    end

  end
  sleep 0.1
end



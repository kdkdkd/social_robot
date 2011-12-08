require 'mechanize'
require 'nokogiri'
require 'json'

module Vkontakte

	#Output message from system
	def log(*args, &block)
		@@log_block = block if block
		@@log_block.call args[0] if args.length>0 && @@log_block
	end
	
	
	
	#which page is to refer all reqests
	@@vkontakte_location_var = "http://vkontakte.ru"
	
	#change page which refers all requests
	def force_location(location = "http://vkontakte.ru")
		@@vkontakte_location_var = location
	end
	
	#get page which refers all requests
	def vkontakte_location
		@@vkontakte_location_var
	end
	
	
	#Ask user to resolve captcha
	def ask_captcha(*args, &block)
		@@ask_captcha_block = block if block
		@@ask_captcha_block.call args[0] if args.length>0 && @@ask_captcha_block
	end
	
	#Ask user to login
	def ask_login(*args, &block)
		if block
			@@ask_login_block = block 
		else
			@@ask_login_block.call if @@ask_login_block
		end
	end
	
	#Try to login in any way
	def forсe_login(connector)
		connect = nil
		if connector
			connect = connector.connect
		else
			connect = Vkontakte::last_connect
		end
		unless connect && connect.login
			ask_login 
			connect = Vkontakte::last_connect
		end
		connect
	end
		
	
	@@application_directory = "."
	
	def application_directory=(value)
		@@application_directory = value
	end
	
	def application_directory
		@@application_directory
	end
	
	def loot_directory
		File.join(Vkontakte::application_directory,"loot")
	end
	
	def session_file
		File.join(Vkontakte::application_directory,"session","session.txt")
	end
	
	def convert_exe
		File.join(Vkontakte::application_directory,"magick","convert.exe")
	end
	
	def last_connect=(val)
		@@last_connect=val
	end
	
	def last_connect
		@@last_connect
	end
	
	@@last_connect = nil
	
	class Connect
		attr_reader :uid
		
		def initialize(login = nil, password = nil)
			@agent = Mechanize.new { |agent|  agent.user_agent_alias = 'Mac Safari'	}
			@login = login
			@password = password
			Vkontakte::last_connect = self
		end
		
		#Restore cookie from file
		def restore_from_session
			begin
				cookie_value = IO.read(session_file)	
				@cookie_login = Mechanize::Cookie.new("remixsid", cookie_value)
				@cookie_login.domain = ".vkontakte.ru"
				@cookie_login.path = "/"
    			return true
			rescue
				return false
			end
		end
		
		#Check if connection is ok
		def check_login
			begin
				resp = get("/feed")
				id = resp.scan(/id\:\s*([^\,]*)\,/)[0][0]
				@uid = id
				return id
			rescue
				return false
			end
		end
		
		def ask_captcha_internal(captcha_sid)
			file_name = save(addr("/captcha.php?sid=#{captcha_sid}&s=1","captcha","#{captcha_sid}.jpg"))
			file_name_png = file_name.gsub(".jpg",".png")
			command = "\"#{Vkontakte::convert_exe}\" \"#{file_name}\" \"#{file_name_png}\""
			system(command)
			captcha_key = ask_captcha(captcha_sid)
			File.delete file_name
			File.delete file_name_png
			captcha_key
		end
		
		
		
		#Save some file to loot folder
		def save(url,folder,filename)
			path = File.join(Vkontakte::loot_directory,folder)
			Dir::mkdir(path) unless File.exists?(path) && File.directory?(path)
			log "Downloading " + url
			filename = filename.gsub(/[\\\/\:\"\*\?\<\>\|]+/,'').gsub("\s","_")
			ext = File.extname(filename)
			basename = filename.chomp(ext)
			basename = basename[0..99] + "..." if basename.length>100
			res = File.join(path,basename + ext)
			@agent.get(url).save(res)
			res
		end
		
		#Make GET request
		def get(href)
			res = @agent.get(addr(href),[],nil,{'cookie' => @cookie_login}).body
			res.force_encoding("cp1251")
			res = res.encode("utf-8")
			res
		end
		
		#Fetch user page
		def get_user(id)
			if(@last_user_fetch_date)
				diff = Time.new - @last_user_fetch_date
				sleep(2.1 - diff) if(diff<2.1)
			end
			
			not_ok = true			
			sleep_time = 100
			while not_ok do
				res = get("/id" + id)
				
				if(res.index('"post_hash"') || res.index('"profile_deleted_text"'))
					not_ok = false
				else
					sleep sleep_time
					sleep_time *= 10
				end
			end
			@last_user_fetch_date = Time.new
			res
		end
		
		
		#Add vkontakte.ru to address
		def addr(rel = "")
			if(rel.index("vkontakte.ru"))
				return rel
			else
				return vkontakte_location() + rel
			end
		end
		
		#Make POST request
		def post(href, params)
			res = @agent.post(addr(href), params , 'cookie' => @cookie_login).body
			res.force_encoding("cp1251")
			res = res.encode("utf-8")
			res
		end
		
		#Make POST request and resolve answer in special way
		def silent_post(href, params)
      resp_post = post(href, params)
			resp = resp_post.split("<!>").find{|str| str.start_with?('{"all":')}.gsub(/^\{\"all\"\:/,'').gsub(/}$/,'').gsub("\r","").gsub("\n","")
			eval("resp=#{resp}")
			resp
		end
		
		#Save cookie to file
		def save_cookie
			File.open(Vkontakte::session_file,"w"){|f|f<<@cookie_login.value}
		end
		
		#login with given login and password
		def login
			return true if @cookie_login
			log "Logging in..."
			@agent.get(addr("/")) do |login_page|
				login_result = login_page.form_with(:name => 'login') do |login|
					login.pass = @password
					login.email = @login
				 end.submit
				 
				 @agent.cookies.each do |cookie|
					@cookie_login = cookie if cookie.name == "remixsid"
				 end
				 if @cookie_login
					id = check_login
					save_cookie
					log "Done"
					@uid = id
					
					return id
				 else
					log "Failed"
					return false
				 end
			end
		end
		
		
	end
	
	class Music
		attr_accessor :id,:name,:author,:link,:duration,:connect
		
		def set(id,name,author,link,duration,connect)
			id_split = id.split("_")
			@user_id = id_split[0]
			@id = id_split[1]
			@name = name
			@connect = connect
			@link = link
			@duration = duration
			@author = author
			self
		end
		
		def uniq_id
			self.id + "_" + @user_id
		end
		
		def set_array(array,connect)
			set(array[0].to_s + "_" + array[1].to_s,array[6],array[5],array[2],array[4],connect)
			self
		end
		
		def to_s
			"#{@author} #{@name}(#{@id})"
		end
		
		def ==(other)
			self.uniq_id == other.uniq_id
		end
		
		def hash
			self.id.hash
		end
		 
		def eql?(other)
			self == other
		end
		
		def download
			return false unless @connect.login
			@connect.save(@link,"music","#{@author}_#{@name}_#{id}.mp3")
		end
		
		def owner
			User.new.set(@user_id,nil,@connect)
		end
		
		
		def Music.all(q, connector=nil)
		    connect = forсe_login(connector)
			
			html = Nokogiri::HTML(connect.post('/al_search.php',{"al" => "1", "c[q]" => q, "c[section]" => "audio", "c[sort]" => "2"}).split("<!>")[6].gsub("<!-- ->->",""))
			res = []
			html.xpath("//table").to_a.each do |table|
				dur = table.xpath(".//div[@class='duration fl_r']")
				if(dur.length>0)
					res.push(Music.new.set(
						table.xpath(".//input[@type='hidden']/@id").text.scan(/audio_info(\d+\_\d+)/)[0][0],
						table.xpath(".//div[@class='audio_title_wrap']//span").find{|span| span["id"].start_with?("title")}.text,
						table.xpath(".//div[@class='audio_title_wrap']//a").first.text,
						table.xpath(".//input[@type='hidden']/@value").text.split(",")[0],
						dur.text,
						connect
					))
				end
			end
			res
		end
		
		def Music.one(q, connector=nil)
			Music.all(q, connector)[0]
		end
		
		def Music.upload(file, connector=nil)
			connect = forсe_login(connector)
			
			res_total = nil
			if(file.class.name == "Array")
				filenames = file
				many = true
				res_total = []
			else
				filenames = [file]
				many = false
				
            end
			
			filenames.each do |filename|
				#Asking for upload parameters and server
				a = connect.post('/audio',{"act" => "new_audio", "al" => "1", "gid" => "0"}).scan(/Upload\.init\(\s*([^\,]+)\s*\,\s*([^\,]+)\s*\,\s*(\{[^\}]*\})/)
				params = JSON.parse(a[0][2])
				params["ajx"] = "1"
				f = File.new(filename, "rb")
				params["file"] = f
				addr = a[0][1].gsub("\"",'').gsub("'",'')
				log "Uploading " + filename
				
				#Uploading music
				res = JSON.parse(connect.post(addr,params))
				f.close
				
				res["act"] = "done_add"
				res["al"] = "1"
				res["artist"] = CGI::unescape(res["artist"])
				res["title"] = CGI::unescape(res["title"])
				
				
				
				#Finishing action
				music_res = connect.post('/audio',res).scan(/\[[^\]]*\]/).find{|x| x.index("vkontakte.ru")}
				res_internal = Music.new.set_array(JSON.parse(music_res),connect)
				if many
					res_total.push(res_internal)
				else
					res_total = res_internal
				end
			end
			res_total
		end
		
		
	end

	class User
		attr_accessor :id, :me, :connect
		
		def name
			return @name if @name
			info
			@name
		end
		
		def deleted
			return @deleted if @deleted == true || @deleted == false
			info
			@deleted
		end
		
		def post_hash
			return @post_hash if @post_hash
			info
			@post_hash
		end
		
		def set(id,name=nil,connect=nil)
			@id = id.to_s
			@name = name
			@connect = (connect)?connect:Vkontakte::last_connect;
			@me = false
			self
		end
		
		def User.id(id_set)
			res = User.new.set(id_set)
			res.connect = forсe_login(nil)
			res
		end
		
		def User.login(login,pass)
			User.new.login(login,pass)
		end
		
		#login with current login and password
		def login(login,pass)
			@connect = Connect.new(login,pass)
			@id = @connect.login
			return nil unless @id
			@me = true
			self
		end
		
		#login with cookie stored in session file
		def login_from_session()
			@connect = Connect.new
			return nil unless @connect.restore_from_session
			@id = @connect.check_login
			return nil unless @id
			@me = true
			self
		end

		def to_s
			(@name)? "#{@name}(#{@id})" : "#{@id}"
		end
		
		def uniq_id
			id
		end
		
		def ==(other)
			self.uniq_id == other.uniq_id
		end
		
		def hash
			self.id.hash
		end
		 
		def eql?(other)
			self == other
		end

		def friends
			return false unless @connect.login
			
			if(@me)
				log "List of my friends..."	
				friends_json = JSON.parse(@connect.post('/al_friends.php', {"act" => "pv_friends","al" => "1"}).gsub(/^.*\<\!json\>/,''))
				friends_json.map{|x,y| User.new.set(x.gsub('_',''),y[1],@connect)}
			else
				log "List of friends..."
				@connect.silent_post('/al_friends.php', {"act" => "load_friends_silent","al" => "1","id"=>@id,"gid"=>"0"}).map{|x| User.new.set(x[0],x[4],@connect)}
			end
		end
		
		def info
			return @info if @info
			return false unless @connect.login
			log "Fetching info..."
			resp = @connect.get_user(@id.to_s)
			html = Nokogiri::HTML(resp)
			name_new = html.xpath("//title").text
			@name = name_new
			
			@deleted = html.xpath("//div[@class='profile_deleted']").length==1
			if @deleted
				@post_hash = nil
				@info = {}
				return
			end
			@post_hash = resp.scan(/\"post_hash\"\:\"([^\"]*)\"/)[0][0]
			
			hash = {"статус" => html.xpath("//div[@id='profile_current_info']").text}
			h1 = html.xpath("//div[@class='label fl_l']").map{|div| div.text}
			h2 = html.xpath("//div[@class='labeled fl_l']").map{|div| div.text}
			h1.each_with_index{|name,index| hash[name.chomp(":")] = h2[index]}
			@info = hash
		end
		
		def music
			return false unless @connect.login
			log "List of music..."
			q = {"act" => "load_audios_silent","al" => "1"}
			q["id"]=@id unless @me
			
			@connect.silent_post('/audio', q ).map{|x| Music.new.set_array(x,@connect)}
		end
		
		def albums
			return false unless @connect.login
			log "List of albums ..."
			Nokogiri::HTML(@connect.get("/albums#{@id}")).xpath("//div[@class='name']/a").inject([]) do |array,a| 
				array.push(Album.new.set(self,a["href"].scan(/_(\d+)/)[0][0],a.text,connect))
				array
			end
		end
		
		
		def post(msg)
			return false unless @connect.login
			log "Posting ..."
			captcha_sid = nil
			captcha_key = nil
            while true
				hash = {"act" => "post","al" => "1", "facebook_export" => "", "friends_only" => "", "hash" => post_hash, "message" => msg, "note_title" => "", "official" => "" , "status_export" => "", "to_id" => id, "type" => "all" }
				unless(captcha_key.nil?)
					hash["captcha_sid"] = captcha_sid
					hash["captcha_key"] = captcha_key
				end
				res = @connect.post('/al_wall.php', hash)
				if(res.index("<!json>"))
					break
				else
					a = res.split("<!>")
					captcha_sid = a[a.length-2]
					captcha_key = @connect.ask_captcha_internal(captcha_sid)
				end
			end
		end
		
		def mail(message, title = "")
			return false unless @connect.login
			log "Mailing ..."
			chas = @connect.post('/al_mail.php', {"act" => "write_box", "al" => "1", "to" => id}).scan(/cur.decodehash\(\'([^\']*)\'/)[0][0]
			chas = (chas[chas.length - 5,5] + chas[4,chas.length - 12])
			chas.reverse!

			captcha_sid = nil
			captcha_key = nil
            while true
				hash = {"act" => "a_send","al" => "1", "ajax" => "1", "from" => "box", "chas" => chas, "message" => message, "title" => title, "media" => "" , "to_id" => id }
				unless(captcha_key.nil?)
					hash["captcha_sid"] = captcha_sid
					hash["captcha_key"] = captcha_key
				end
				res = @connect.post('/al_mail.php', hash)
				if(res.index("<div"))
					break
				else
					a = res.split("<!>")
					captcha_sid = a[a.length-2]
					captcha_key = @connect.ask_captcha_internal(captcha_sid)
				end
			end
		end
	end
	
	

	class Album
		attr_accessor :id, :user, :name, :connect
		def set(user,id,name,connect)
			@id = id
			@name = name
			@connect = connect
			@user = user
			self
		end
		
		def to_s
			"#{name}(#{@id})"
		end
		
		def uniq_id
			self.id + "_" + self.user.id
		end
		
		def ==(other_user)
			self.uniq_id == other_user.uniq_id
		end
		
		def hash
			self.id.hash
		end
		 
		def eql?(other)
			self == other
		end
		
		def Album.create(name, description, connector=nil)
			connect = forсe_login(connector)
			
			log "Creating album ..."
			hash = connect.post('/al_photos.php',{"al" => "1", "act" => "new_album_box"}).scan(/hash\:\s*\'([^\']+)\'/)[0][0]
			res = connect.post('/al_photos.php',{"al" => "1", "act" => "new_album", "comm" => "0", "view" => "0", "only" => "false" , "oid" => connect.uid, "title" => name, "desc" => description, "hash" => hash })
			album_id = res.scan(/\_(\d+)/)[0][0]
			Album.new.set(User.new.set(connect.uid), album_id ,name,connect)
		end
		
		
		def upload(file,description)
			return false unless @connect.login
			res_total = nil
			
			if(file.class.name == "Array")
				filenames = file
				many = true
				res_total = []
			else
				filenames = [file]
				many = false
				
            end
			
			filenames.each do |filename|
				
				log "Uploading #{filename} ..."  
				#Asking for upload parameters and server
				post = connect.post('/al_photos.php',{"__query" => "album#{user.id}_#{id}", "al" => "-1", "al_id" => user.id})
				hash = post.scan(/hash[^\da-z]+([\da-z]+)/)[0][0]
				rhash = post.scan(/rhash[^\da-z]+([\da-z]+)/)[0][0]
				addr = post.scan(/flashLiteUrl\s*\=\s*([^\;]+)/)[0][0].gsub("\"",'').gsub("'",'').gsub("\\",'')
				
				params = {"oid" => user.id, "aid" => id, "gid" => "0", "mid" => user.id, "hash" => hash, "rhash" => rhash, "act" => "do_add", "ajx" => "1"}
				f = File.new(filename, "rb")
				params["photo"] = f
				
				#Uploading photo
				res = connect.post(addr,params)
				f.close
				
				
				#Asking for photo parameters
				hash = res.scan(/hash\=([^\&]+)/)[0][0]
				photos = res.scan(/photos\=([^\&]+)/)[0][0]
				server = res.scan(/server\=([^\&]+)/)[0][0]
				
				
				params = {"photos" => photos,"server" => server,"from" => "html5","context" => "1", "al" => "1", "aid" => id, "gid" => "0", "mid" => user.id, "hash" => hash, "act" => "done_add"}
				res = connect.post('/al_photos.php',params)
				hash = res.scan(/deletePhoto[^\,]+\,\s*([^\)]+)/)[0][0].gsub("\"",'').gsub("'",'')
				res_internal = Image.new.set(self,res.split("<!>").last.split("_").last,res.scan(/x_src\:\s*([^\,]+)/)[0][0].gsub("\"","").gsub("'",""),hash,connect)
				if many
					res_total.push(res_internal)
				else
					res_total = res_internal
				end
			end
			res_total
		end
		
		
		def photos
			return false unless @connect.login
			log "List of photos ..."
			
			res = []
			num = 0
			b = false
			while(true)
				post = @connect.post('/al_photos.php',{"al" => "1","direction" => "1","offset"=>num.to_s, "act" => "show", "list" => "album#{user.id}_#{@id}"})
				json = JSON.parse(post.split("<!json>").last.split("<!>").first)
				num += json.length
				break if json.length == 0
				json.inject(res) do |array,el| 
					id = el['id'].split("_").last
					if(array.find{|p|p.id == id})
						b = true
						break
					end
					array.push(Image.new.set(self,id,el['x_src'],el['hash'],connect))
					array
				end
				break if b
			end
			res
		end
		
	end
	
	class Image
		attr_accessor :id, :album, :connect, :link, :hash_vk 
		def set(album,id,link,hash_vk,connect)
			@id = id
			@album = album
			@connect = connect
			@link = link
			@hash_vk = hash_vk
			self
		end
		
		def to_s
			"#{@id}"
		end
		
		def uniq_id
			self.id + "_" + self.album.id + "_" + self.album.user.id
		end
		
		def ==(other)
			self.uniq_id == other.uniq_id
		end
		
		def hash
			self.id.hash
		end
		 
		def eql?(other)
			self == other
		end
		
		def download
			return false unless @connect.login
			@connect.save(@link,"images","#{id}_#{@album.name}.jpg")
		end
		
		
		def remove
			return false unless @connect.login
			log "Deleting photo #{hash}..."
			@connect.post("/al_photos.php",{"act" => "delete_photo", "al" => "1", "hash" => hash_vk, "photo" => "#{album.user.id}_#{id}"})
		end
		
	end


end

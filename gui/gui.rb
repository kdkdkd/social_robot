$:.unshift File.dirname($0)

require 'Qt'
require '../lib/utfto1251.rb'
require '../lib/vk.rb'
require '../lib/captcha.rb'
require './sugar_vk.rb'
require './highlighter_ruby.rb'
require 'pathname'
require './help.rb'
require './settings.rb'
require './updater.rb'
require './logger_html.rb'
require 'zip/zipfilesystem'

require './data.rb'
require './table.rb'
require './table.rb'

include Vkontakte


Vkontakte::application_directory = File.expand_path("../..")


$mutex = Mutex.new
$db = nil

$app = Qt::Application.new(ARGV)

#Output message from system to console or log window
def log(*args, &block)
	@@log_block = block if block
	@@log_block.call(*args) if defined?(@@log_block)
end


#Show total on progress bar
def show_progress(*args, &block)
	@@log_total = block if block
	@@log_total.call(*args) if defined?(@@log_total) && args.length>1
end
	

class SocialRobot < Qt::MainWindow
	slots    'database_peoples()','database_proxy()','enter_system()','link_clicked( const QUrl & )','toggle_developer_mode()', 'open_settings()','open_files_clicked()','open_file_clicked()', 'menu_script_click()','code_changed()','run_script()','stop_script()','create_script()','save_script()','open_script()','insert_help(QTreeWidgetItem *, int)', 'show_loot()'

	#Create gui and set timer
	def initialize()
		super
		setWindowTitle("Социальный робот. " + IO.read("../version.txt"))
		setWindowIcon(Qt::Icon.new("images/logo.png"))
		#Create main widgets and dock interface 
		resize(600, 600)
		log_dock = Qt::DockWidget.new("Лог", self)
		@help_dock = Qt::DockWidget.new("Помощь", self)

		@code_edit = Qt::TextEdit.new
		
		HighlighterRuby.new(@code_edit.document)
		@code_edit.plainText = "#Список друзей\nme.friends.print"
		@log_edit = Qt::TextBrowser.new
		@log_edit.openExternalLinks = false
		@log_edit.openLinks = false


		
		@progress = Qt::ProgressBar.new
		
		@name_login_choose = Qt::ComboBox.new
		@name_login_text = Qt::Label.new
		@name_login_text.text = "Кем выполнять действие"
		update_name_login_choose()
		
		
		
		@progress_text = Qt::Label.new
		@progress_text.text = ""

		statusBar().insertPermanentWidget(1,@name_login_choose,0)
		statusBar().insertPermanentWidget(0,@name_login_text,0)

		
		statusBar().insertPermanentWidget(0,@progress_text,0)
		statusBar().insertPermanentWidget(1,@progress,0)


		connect(@log_edit,SIGNAL('anchorClicked( const QUrl & )'),self,SLOT('link_clicked( const QUrl & )'))
		@help_tree = Qt::TreeWidget.new
		@log_edit.setStyleSheet("QTextBrowser{background-image: url(images/back.png);	background-repeat: repeat-xy; background-attachment: fixed;background-color: white;}")
		@code_edit.setStyleSheet("QTextEdit{font: 15px;background-image: url(images/back.png);	background-repeat: repeat-xy; background-attachment: fixed;background-color: white;}")
		@help_tree.setStyleSheet("QTreeWidget{background-image: url(images/back.png);	background-repeat: repeat-xy; background-attachment: fixed;background-color: white;}")


		#Properties of main widgets
		#@code_edit.setStyleSheet("font: 15px;")
		connect(@code_edit,SIGNAL('textChanged()'),self,SLOT('code_changed()'))
		@code_edit.acceptRichText = false
		@code_edit.lineWrapMode = 0
		@log_edit.lineWrapMode = 0
		@log_edit.ReadOnly = true


		setCentralWidget(@code_edit)

		#Assign widgets to docks
		log_dock.widget = @log_edit
			addDockWidget(Qt::BottomDockWidgetArea, log_dock)
		@help_dock.widget = @help_tree
			addDockWidget(Qt::RightDockWidgetArea, @help_dock)



		#Allow dock widgets to be movable
		log_dock.Features = 2
		@help_dock.Features = 2


		#Fill help tree
		index = 0
		
		items = []
		$help.keys.each do |help_chapter_key|
		    item_chapter = Qt::TreeWidgetItem.new(@help_tree)
			item_chapter.setFont(0, Qt::Font.new("Times", 11, Qt::Font::Light))
			help_chapter_key_copy = help_chapter_key.dup
			help_chapter_key_copy.force_encoding("UTF-8")
			item_chapter.setText(0, help_chapter_key_copy)
			$help[help_chapter_key].inject(items) do |array,function|
				item = Qt::TreeWidgetItem.new(item_chapter)

				#Zebra
				if(index % 2 == 0)
					brush = Qt::Brush.new(Qt::Color.new(230, 230, 230))
					item.setBackground(0,brush)
					item.setBackground(1,brush)
				end
				if function.has_key?("data")
					data = function["data"]
					data.force_encoding("UTF-8")
					item.setData(0,32,Qt::Variant.new(data)) 
				end
				signature = function["signature"]
				signature.force_encoding("UTF-8")
				item.setText(0, signature)
				description = function["description"]
				description.force_encoding("UTF-8")
				item.setText(1, description)
				item.setFont(0, Qt::Font.new("Times", 10, Qt::Font::Bold))
				first = true
				function["tips"].each do |hash|
					item_internal = Qt::TreeWidgetItem.new(item)
					signature = hash["signature"]
					signature.force_encoding("UTF-8")
					description = hash["description"]
					description.force_encoding("UTF-8")
					
					item_internal.setText(0, ((first)? "\n":"") + signature + "\n")
					item_internal.setText(1, ((first)? "\n":"") + description + "\n")
					if hash.has_key?("data")
						data = hash["data"]
						data.force_encoding("UTF-8")
						item_internal.setData(0,32,Qt::Variant.new(data)) 
					end
					first = false
				end
				index += 1
				array.push(item)
			end
		end
		#Properties of help tree
		@help_tree.setColumnCount(2)
		headers = []
		headers << "Название" << "Описание"
		@help_tree.HeaderLabels = (headers);
		@help_tree.setColumnWidth(0,200) 
		@help_tree.setColumnWidth(1,300) 
		@help_tree.WordWrap = true

		connect(@help_tree,SIGNAL('itemClicked ( QTreeWidgetItem *, int)'),self,SLOT('insert_help(QTreeWidgetItem *, int)'))
		@help_tree.insertTopLevelItems(0,items)


		#Create actions
		@new_action = Qt::Action.new(Qt::Icon.new("images/new.png"), "Новый скрипт",self)
		@new_action.shortcut = Qt::KeySequence.new("Ctrl+N")
		@new_action.statusTip = "Создать скрипт"
		connect(@new_action, SIGNAL('triggered()'), self, SLOT('create_script()'))

		@save_action = Qt::Action.new(Qt::Icon.new("images/save.png"), "Сохранить", self)
		@save_action.shortcut = Qt::KeySequence.new("Ctrl+S")
		@save_action.statusTip = "Сохранить скрипт"
		connect(@save_action, SIGNAL('triggered()'), self, SLOT('save_script()'))

		@open_action = Qt::Action.new(Qt::Icon.new("images/open.png"), "Открыть", self)
		@open_action.shortcut = Qt::KeySequence.new("Ctrl+O")
		@open_action.statusTip = "Открыть скрипт"
		connect(@open_action, SIGNAL('triggered()'), self, SLOT('open_script()'))

		@run_action = Qt::Action.new(Qt::Icon.new("images/run.png"), "Запуск", self)
		@run_action.shortcut = Qt::KeySequence.new("F5")
		@run_action.statusTip = "Запустить скрипт"
		connect(@run_action, SIGNAL('triggered()'), self, SLOT('run_script()'))

		@stop_action = Qt::Action.new(Qt::Icon.new("images/stop.png"), "Стоп", self)
		@stop_action.statusTip = "Остановить скрипт"
		connect(@stop_action, SIGNAL('triggered()'), self, SLOT('stop_script()'))

		@loot_action = Qt::Action.new(Qt::Icon.new("images/loot.png"), "Скачанные файлы", self)
		@loot_action.statusTip = "Посмотреть скачанные файлы"
		connect(@loot_action, SIGNAL('triggered()'), self, SLOT('show_loot()'))

		
		@open_settings_action = Qt::Action.new("Настройки", self)
		@open_settings_action.statusTip = "Настройки"
		connect(@open_settings_action, SIGNAL('triggered()'), self, SLOT('open_settings()'))
		
		@developer_mode_action = Qt::Action.new(Qt::Icon.new("images/developer.png"),"Режим разработчика", self)
		@developer_mode_action.statusTip = "Режим разработчика"
		connect(@developer_mode_action, SIGNAL('triggered()'), self, SLOT('toggle_developer_mode()'))

		@enter_action = Qt::Action.new(Qt::Icon.new("images/vkontakte.png"),"Вход в систему", self)
		@enter_action.statusTip = "Вход в систему"
		connect(@enter_action, SIGNAL('triggered()'), self, SLOT('enter_system()'))

		@database_peoples = Qt::Action.new("Аккаунты", self)
		@database_peoples.statusTip = "Редактировать аккаунты"
		connect(@database_peoples, SIGNAL('triggered()'), self, SLOT('database_peoples()'))
		
		@database_proxy = Qt::Action.new("Прокси", self)
		@database_proxy.statusTip = "Редактировать прокси сервера"
		connect(@database_proxy, SIGNAL('triggered()'), self, SLOT('database_proxy()'))
		
		
		@exit_action = Qt::Action.new("Выход", self)
	    @exit_action.shortcut = Qt::KeySequence.new("Ctrl+Q")
	    @exit_action.statusTip = "Выйти"
	    connect(@exit_action, SIGNAL('triggered()'), $app, SLOT('closeAllWindows()'))
		
		
		
		
		
		@fileMenu = menuBar().addMenu("Файл")
		@fileMenu.addAction(@new_action)
		@fileMenu.addAction(@save_action)
		@fileMenu.addAction(@open_action)
		
		@fileMenu.addAction(@run_action)
		@fileMenu.addAction(@stop_action)
		@fileMenu.addAction(@loot_action)
		@fileMenu.addAction(@developer_mode_action)
		@fileMenu.addAction(@open_settings_action)
		@fileMenu.addAction(@database_peoples)
		@fileMenu.addAction(@database_proxy)
		@fileMenu.addAction(@exit_action)
		
		generate_menu(menuBar(),'../prog')
		generate_menu(menuBar().addMenu("Мои скрипты"),'../../my')
		
		
		@file_toolbar = addToolBar("File")
		@file_toolbar.addAction(@new_action)
		@file_toolbar.addAction(@save_action)
		@file_toolbar.addAction(@open_action)

		@run_toolbar = addToolBar("Run")
		@run_toolbar.addAction(@run_action)
		@run_toolbar.addAction(@stop_action)
		@run_toolbar.addAction(@enter_action)


		statusBar().showMessage("")

		#Comunication variables

		#Lines to add to log
		@new_lines = []

		#Status text to display
		@new_progress_text = nil

		#Percent of progress to display
		@new_progress = nil

		#Working thread
		@thread = nil

		#Disable stop button, enable start button
		run_gui true

		#Trigger to run_gui(true)
		@disable_run_gui = false

		#If code has changed
		@changed = false
		
		#Proxy to call user gui dialog from script
		@res_proxy = []
		@ask_proxy = {}

		#On iddle 
		block = Proc.new do
			if($mutex.try_lock)
				if(@new_lines)
					if(@new_lines.length>0)
						lines_to_add = @new_lines[0..20]
						@new_lines = @new_lines[21..@new_lines.length-1]
						@new_lines = [] unless @new_lines
						lines_to_add.each {|line| @log_edit.append(line)}
					end
				else
					@new_lines = []
				end

				if @new_progress_text
					@progress_text.text = @new_progress_text
					@new_progress_text = nil
				end

				if @new_progress
					@progress.setRange(1,@new_progress[1])
					@progress.setValue(@new_progress[0])
					@new_progress = nil
				end

				if(@disable_run_gui)
					run_gui(true)
					@disable_run_gui = false
				end
				$mutex.unlock
			end
			
			
			if @ask_proxy.length > 0
				@res_proxy = ask_user_internal(@ask_proxy)
				@ask_proxy = []
			end
		
			Thread.pass
		end
		
		#Give chance to work for another threads  
		@timer=Qt::Timer.new(window)
		invoke=Qt::BlockInvocation.new(@timer, block, "invoke()")
		Qt::Object.connect(@timer, SIGNAL("timeout()"), invoke, SLOT("invoke()"))
		@timer.start

		log_ok("Чтобы начать работу, выберите один из пунктов меню. Например, <i>Музыка -> Cкачать мою музыку</i><br/><br/>Или нажмите на кнопку <img src=\"images/vkontakte.png\"/> Это покажет Вас и Ваших друзей и абсолютно безобидно.<br/><br/><br/>Подробнее об использовании и возможностях программы на <a href=\"http://socialrobot.net\">http://socialrobot.net</a>")
		
		update_developer_mode()
		
		@threads = []

		#Remember user input
		@memory_input = {}
	end
	
	def update_name_login_choose()
		@name_login_choose.clear()
		$db[:account].each_with_index{|acc,i|@name_login_choose.insertItem(i,acc[:email]);}
	end
	
	def database_peoples
		AccountTable.new.show
		update_name_login_choose()
	end
	
	def database_proxy
		ProxyTable.new.show
	end
	
	#When user clics on link
	def link_clicked(url)
		Qt::DesktopServices::openUrl(url)
	end
	
	
	#toggle developer mode
	def toggle_developer_mode()
		if(Settings["developer_mode"] == "true")
			Settings["developer_mode"] = "false"
		else
			Settings["developer_mode"] = "true"
		end
		Settings.save
		update_developer_mode()
	end
	
	
	#update developer mode
	def update_developer_mode()
		if(Settings["developer_mode"] == "true")
			@code_edit.Visible = true
			@help_dock.Visible = true
			@file_toolbar.Visible = true
			@save_action.Visible = true
			@open_action.Visible = true
			@new_action.Visible = true
			@run_action.Visible = true
		else
			@code_edit.Visible = false
			@help_dock.Visible = false
			@file_toolbar.Visible = false
			@save_action.Visible = false
			@open_action.Visible = false
			@new_action.Visible = false
			@run_action.Visible = false
		end
	end
	
	#Generate menu
	def generate_menu(menu,directory)
		Pathname.new(directory).children.each do |e|  
			if e.directory?
				name_full = e.to_s
				name = e.basename.to_s
				name_local = File.join(name_full,".name")
				if(File.exist?(name_local))
					name = IO.read(name_local) 
					name.force_encoding("UTF-8")
				end
				generate_menu(menu.addMenu(name),e.to_s)
			else
				next unless e.basename("").to_s.end_with?(".rb")
				name_full = e.to_s.gsub(/\.rb$/,".name")
				name = e.basename(".rb").to_s
				if(File.exist?(name_full))
					name = IO.read(name_full) 
					name.force_encoding("UTF-8")
				end
				
				
				new_action = Qt::Action.new(Qt::Icon.new("images/script.png"),name, self)
				new_action.statusTip = name
				new_action.setData(Qt::Variant.new(e.to_s))
				connect(new_action, SIGNAL('triggered()'), self, SLOT('menu_script_click()'))
				menu.addAction(new_action)
				
			end
		end
	end
	
	#Open settings window
	def open_settings
		SettingsWindow.show
	end
	
	#Clicked on some auto generated menu
	def menu_script_click
		return unless check_changes
		str = sender.data.toString
		run_script_by_name(str)
	end
	
	def enter_system
	    run_script_by_name("../prog/Vkontakte/Peoples/Me and my friends.rb")
	end
	
	
	def run_script_by_name(str)
		text = IO.read(str)
		text.force_encoding("UTF-8")
		@code_edit.plainText = text
        @changed = false
		if Settings["developer_mode"] == "false"
			@thread.kill if @thread
			@threads.each{|t| t.kill}
			@threads = []
			while @thread && @thread.alive? do
				sleep 0.1
			end
			
			run_gui(true)
			run_script
		end
	end
	
	#Open loot folder
	def show_loot
		path = Qt::Dir::toNativeSeparators(File.expand_path(Vkontakte::loot_directory));
		Qt::DesktopServices::openUrl(Qt::Url.new("file:///#{path}"));
	end

	def open(path)
		Qt::DesktopServices::openUrl(Qt::Url.new("file:///#{path}"));
	end

	def notify
		open(File.expand_path("./sounds/notification.mp3"))
	end

	#Log with red color
	def log_error(text)
		text = text.to_s
		text.force_encoding("UTF-8")
		$mutex.lock
			@new_lines << ("<font color='red' size='3'>" + text + "</font>")
		$mutex.unlock
	end

	#Log with green color
	def log_success(text)
		text = text.to_s
		text.force_encoding("UTF-8")
		$mutex.lock
			@new_lines << ("<font color='green' size='3'>" + text + "</font>")
		$mutex.unlock
	end

	#Log with black color
	def log_ok(text)
		#text = text.to_s
		#text.force_encoding("UTF-8")
		if(text.class.name == "Array")
			text_array = text
		else
			text = text.to_s
			text.force_encoding("UTF-8")
			text_array = [text]
		end
		$mutex.lock
			text_array.each do |text_line|
				@new_lines << "<font color='black' size='3'>" + text_line.to_s + "</font>"
			end
		$mutex.unlock
	end

	#show total on gui progress bar
	def total(value,range)
		$mutex.lock
			@new_progress = [value,range]
		$mutex.unlock
	end

	#Log with small grey font
	def log_small(text)
		text = text.to_s
		text.force_encoding("UTF-8")
		$mutex.lock
			@new_lines << ("<font color='grey' size='3'>" + text + "</font>")
		$mutex.unlock
	end

	#Ask if discard code edit changes or not
	def check_changes
		return true if !@changed || @code_edit.plainText.length == 0
		msgBox = Qt::MessageBox.new
		msgBox.setText("Скрипт не сохранен.")
		msgBox.setInformativeText("Все равно продолжить?")
		msgBox.setStandardButtons(Qt::MessageBox::Ok | Qt::MessageBox::Cancel)
		msgBox.setDefaultButton(Qt::MessageBox::Cancel)
		res = msgBox.exec() == Qt::MessageBox::Ok
		@changed = false if res
		res
	end

	#On close
	def closeEvent(event)
		check = check_changes
		if check
			event.accept()
		else
			event.ignore()
		end
	end

	#On help tree clicked
	def insert_help(item,column)
		data = item.data(0,32).toString
		return unless data
		data.force_encoding("UTF-8")
		@code_edit.insertPlainText(data)
	end

	
	
	#On create script clicked
	def create_script
		return unless check_changes 
		@code_edit.clear
	end

	#On save script clicked
	def save_script
		filename = Qt::FileDialog.getSaveFileName(self, "Сохранить скрипт", "../../my", "Скрипты (*.rb);; Все файлы (*.*)")
		return unless filename
		filename.force_encoding("UTF-8")
		begin
			f = File.open(filename,"w")
			f << @code_edit.plainText
			f.close
			@changed = false
		rescue Exception => e
			msg = Qt::MessageBox.new
			msg.setText("Ошибка : #{e.message.encode("UTF-8")}")
			msg.exec()
		end
	end

	#On open script clicked
	def open_script
		return unless check_changes 
		filename = Qt::FileDialog.getOpenFileName(self, "Открыть скрипт", "../../my", "Скрипты (*.rb);; Все файлы (*.*)")
		return unless filename
		filename.force_encoding("UTF-8")
		begin
			content = IO.read(filename)
			content.force_encoding("UTF-8")
			@code_edit.plainText = content
			@changed = false
		rescue Exception => e
			msg = Qt::MessageBox.new
			msg.setText("Ошибка : #{e.message.encode("UTF-8")}")
			msg.exec()
		end
	end

	#On stop script clicked
	def stop_script
		@thread.kill if @thread
		@threads.each{|t| t.kill}
		@threads = []
		run_gui(true)
		@progress_text.text = "Остановлено"
		@progress_text.setStyleSheet("QLabel { color : red; }");
	end
	
	def set_disable_run_gui
		$mutex.lock
			@disable_run_gui = true
		$mutex.unlock
	end

	#Toggle start/stop buttons
	def run_gui(enable)
		@stop_action.setEnabled(!enable)
		@run_action.setEnabled(enable)
		@progress.visible = !enable
		@name_login_choose.visible = enable
		@name_login_text.visible = enable
		@progress.setValue(1)
	end
	
	def progress_text(text)
		$mutex.lock
			@new_progress_text = text
		$mutex.unlock
	end
	
	
	
	#On run script clicked
	def run_script
		return if @thread && @thread.alive?
		$mutex.lock
			@new_lines = []
		$mutex.unlock
		@log_edit.clear()
		@progress_text.setStyleSheet("QLabel { color : black; }");
		@progress_text.text = "Запуск..."

		s = @code_edit.plainText
		s.force_encoding("UTF-8")
		@thread = Thread.new(s,self) do |script,robot|
			begin
				log do |text|
					robot.log_ok text
				end
				progress do |*args|
					if(args.length==1)
						text = args[0]
						robot.progress_text(text)
					else
						robot.log_ok log_html(*args)
					end
				end
				failed do |*args|
					robot.log_error args[0]
				end
				show_progress do |value,range|
					robot.total(value,range)
				end
				
				update_session do |login,hash|
					$db[:account].filter('email = ?', login).update(:hash => hash)
				end
				
				ask_captcha	do |pict|
					if(Settings["captcha_solver"] == "0")
						res = ask({"type" => "Image", "Path" => pict} => "string")[0]
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
									else progress(:exception_antigate,e); res = "asdas"; sleep 30;
								end
							end
						end
					end
					res
				end
				
				if(Settings["use_anonymizer"] == "true")
					use_anonymizer
				else
					force_location
				end
				
				
				
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
				
				user_list = []
				$db[:account].each{|acc| user_list.push([acc[:email],acc[:password]])}
				user_list.uniq!{|a|a[0]}
        Vkontakte::user_list = user_list

				Vkontakte.user_fetch_interval = Settings["user_fetch_interval"].to_f
				Vkontakte.photo_mark_interval = Settings["photo_mark_interval"].to_f
				Vkontakte.like_interval = Settings["like_interval"].to_f
				Vkontakte.mail_interval = Settings["mail_interval"].to_f
				Vkontakte.post_interval = Settings["post_interval"].to_f
				Vkontakte.invite_interval = Settings["invite_interval"].to_f
				Vkontakte.transform_captcha = Settings["captcha_solver"] == "0"
        Vkontakte.user_login_interval = (Settings["login_interval"].nil?)? 4.0:Settings["login_interval"].to_f;
				ask_login do 
					me
				end
				eval(script)
				progress "Выполнено"
				#@progress_text.setStyleSheet("QLabel { color : green; }");
				#@progress.setValue(0)
				robot.set_disable_run_gui
			rescue Exception => e  
				robot.log_error e.message 
				e.backtrace.each{|l|robot.log_small l} 
				progress "Ошибка"
				#@progress_text.setStyleSheet("QLabel { color : red; }");
				#		@progress.setValue(0)
				robot.set_disable_run_gui
			end
		end
		run_gui(false)
	end


	#On code text box changed
	def code_changed
		@changed = true
	end
	
	
	#Create universal dialog
	def ask(params = {})
		
			@res_proxy = []
			@ask_proxy = params
		
		while(true) do
			
			if(@res_proxy.length == 1 && @res_proxy[0].nil?)
				raise "Отменено пользователем"
			end
			if(@res_proxy.length >0)
				res = @res_proxy
				@res_proxy = []
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

	def ask_peoples
		r = ask(
		 "Критерий(Имя или интерес)" => "string" ,
		 "Искать по.." => {"Type" => "combo","Values" => ["По интересам","По имени"] },
		 "Сортировать по.." => {"Type" => "combo","Values" => ["По рейтингу","По дате регистрации"] },
		 "Страна" => {"Type" => "combo","Values" => ["Не важно"] + Vkontakte.countries.keys },
		 "Город" => "string" ,
		 "Количество результатов" => {"Type" => "int","Default" => 100, "Minimum" => 1 },
		 "Начиная с..." => {"Type" => "int","Default" => 0, "Minimum" => 0, "Maximum" => 999 },
		 "Пол"=>{"Type" => "combo","Values" => ["Не важно","Мужской","Женский"] },
		 "Онлайн"=>{"Type" => "combo","Values" => ["Не важно","Только онлайн"] },
		 "От"=>{"Type" => "combo","Values" => ["Не важно"] + (12..80).to_a },
		 "До"=>{"Type" => "combo","Values" => ["Не важно"] + (12..80).to_a }
		)

		q = { }


		q["Страна"] = r[3] if r[3] != "Не важно"
		q["Город"] = r[4] if r[4].length>0

		q["Пол"] = r[7] if r[7] != "Не важно"
		q["Онлайн"] = "Да" if r[8] != "Не важно"
		q["От"] =  r[9] if r[9] != "Не важно"
		q["До"] =  r[10] if r[10] != "Не важно"
		q["По имени"] =  (r[1] == "По имени")? "Да" : "Нет"
		q["По дате"] =  (r[2] == "По дате регистрации")? "Да" : "Нет"


		res = User.all(r[0],r[5],r[6],q)
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
	
	#Create universal dialog thread unsafe
	def ask_user_internal(params = {})
		@timer.stop
		ask = Qt::Dialog.new
		layout = Qt::GridLayout.new  
		index = 0
		controls = []
		@controls_hash = {}
		label_hash = {}
		params.each_key do |param| 
			param_label = nil
			if param.class.name == "Hash"
				if(param["type"]=="Image")
					pixmap = Qt::Pixmap.new("../../loot/captcha/#{param["Path"]}.png")
					label = Qt::Label.new;
					label.setPixmap(pixmap);
				end
			else
				label = Qt::Label.new
				param_real = param.dup
				param_label = param_real.dup
				param_real.force_encoding("UTF-8")
				label.text = param_real
			end
			value_hash = params[param]
			input = nil
			default = @memory_input[param_label]
			if(value_hash.class.name == "Hash")
				if value_hash["Type"] == "combo"
					input = Qt::ComboBox.new

					selected_item_index = -1
					value_hash["Values"].each_with_index{|x,i|input.insertItem(i,x.to_s);selected_item_index = i if x.to_s == default.to_s}
					input.setCurrentIndex(selected_item_index) if selected_item_index>=0
					controls.push(input)
					layout.addWidget(input,index,1)
				elsif value_hash["Type"] == "int"
					input = Qt::SpinBox.new
					input.minimum = value_hash["Minimum"] if value_hash["Minimum"]

					input.maximum = 99999
					input.maximum = value_hash["Maximum"] if value_hash["Maximum"]
					input.value = value_hash["Default"] if value_hash["Default"]

					input.value = default if(default && default.class.name == "Fixnum")

					controls.push(input)
					layout.addWidget(input,index,1)
				end
			else

			case value_hash
				when "check"
					input = Qt::CheckBox.new
					input.checked = default == true
					controls.push(input)
					layout.addWidget(input,index,1)
				when "text"
					input = Qt::TextEdit.new

					input.plainText = default.to_s if(default)
					controls.push(input)
					layout.addWidget(input,index,1)
				when "string"
					input = Qt::LineEdit.new
					input.text = default.to_s if(default)
					controls.push(input)
					layout.addWidget(input,index,1)
				when "int"
					input = Qt::SpinBox.new
					input.minimum = 0
					input.maximum = 99999
					input.value = 1
					input.value = default if(default && default.class.name == "Fixnum")

					controls.push(input)
					layout.addWidget(input,index,1)
				when "pass"
					input = Qt::LineEdit.new
					input.EchoMode = Qt::LineEdit::Password

					controls.push(input)
					layout.addWidget(input,index,1)
				when "files"
					hlayout = Qt::HBoxLayout.new
					input = Qt::LineEdit.new
					button = Qt::PushButton.new
					@controls_hash[button] = input
					button.text = "..."
					input.text = default.to_s if(default)
					hlayout.addWidget(input)

					hlayout.addWidget(button)
					connect(button,SIGNAL('clicked()'),self,SLOT('open_files_clicked()'))
					controls.push(button)
					layout.addLayout(hlayout,index,1)
				when "file"
					hlayout = Qt::HBoxLayout.new
					input = Qt::LineEdit.new
					button = Qt::PushButton.new
					@controls_hash[button] = input
					button.text = "..."
					input.text = default.to_s if(default)
					hlayout.addWidget(input)
					hlayout.addWidget(button)
					connect(button,SIGNAL('clicked()'),self,SLOT('open_file_clicked()'))
					controls.push(input)
					layout.addLayout(hlayout,index,1)
				else
					input = Qt::LineEdit.new
					input.text = default.to_s if(default)
				end
			end
			label_hash[input] = param_label if(!param_label.nil? && !input.nil?)
			
			
			
			layout.addWidget(label,index,0)
			
			
			index += 1
		end
		exit_button = Qt::PushButton.new("Ок",ask)
		layout.addWidget(exit_button,index,1,Qt::AlignRight)
		connect(exit_button,SIGNAL('clicked()'),ask,SLOT('accept()'))
		
		
		layout.setContentsMargins(50,50,50,50)
		layout.HorizontalSpacing = 75
		layout.VerticalSpacing = 30
		ask.windowTitle = "Введите значения"
		ask.setLayout(layout)
		res_exec = ask.exec

		if res_exec == 0
			@timer.start
			return [nil]
		end
		res = []
		controls.each do |control|

			case control.class.name
			when /TextEdit/
				push_value = (control.plainText)
				push_value.force_encoding("UTF-8")
				res.push(push_value)
			when /LineEdit/
				push_value = (control.text)
				push_value.force_encoding("UTF-8")
				res.push(push_value)
			when /SpinBox/
				res.push(control.value)
			when /PushButton/
				text = @controls_hash[control].text
				text.force_encoding("UTF-8")
				res.push(text.split("|"))
			when /ComboBox/
				text = control.currentText
				text.force_encoding("UTF-8")
				res.push(text)
			when /CheckBox/
				res.push(control.checked)
			end

			string_label = label_hash[control]
			@memory_input[string_label] = res.last if(string_label)

		end
		
		@timer.start
		res
	end
	
	#On files open dialog clicked while asking
	def open_files_clicked
		
		filename = Qt::FileDialog.getOpenFileNames(self, "Открыть файлы", "../../loot", "Все файлы (*.*)").map{|f|f.force_encoding("UTF-8")}.join("|")
		return if filename.length == 0
		
		@controls_hash[sender].text = filename
		sender.parent.raise if sender.parent
	end
	
	#On files open dialog clicked while asking
	def open_file_clicked
		filename = Qt::FileDialog.getOpenFileName(self, "Открыть файл", "../../loot", "Все файлы (*.*)")
		return unless filename
		filename.force_encoding("UTF-8")
		
		@controls_hash[sender].text = filename
		sender.parent.raise if sender.parent
	end
	
	
	#Access to User self object
	def me
		if @me && @name_login_choose.currentText == @me_login
			return @me
		else
			@me = nil
		end
		
		email = @name_login_choose.currentText
		if(@name_login_choose.currentText && @name_login_choose.currentText.length>0)
			email.force_encoding("UTF-8")
			object = $db[:account][:email => email]
			pass = object[:password]
			hash = object[:hash]
			@me = User.login(email,pass,hash)
			raise "Не правильный логин/пароль" unless @me
			@me_login = email
		else
			res = ask("Логин"=>"string","Пароль"=>"pass")
			@me = User.login(res[0],res[1])
			raise "Не правильный логин/пароль" unless @me
			@me_login = res[0]
			$db[:account].insert(:email => res[0], :password => res[1])
			update_name_login_choose()
		end
		@me
	end
	
	
	def check_users
		users = []
		user_logins = []
		user_list.each do |user|
      next if user.nil?
			hash = $db[:account][:email => user[0]][:hash]
			u = safe{User.login(user[0],user[1],hash)}
			if u
				
				users.push(u)
				user_logins.push("#{user[0]}:#{user[1]}")
				"Зашел #{user[0]}".print
				
			else
				"Не зашел #{user[0]}".print
			end

		end
		user_logins.print
		users
	end


	
	
	#Asks to use anonymizer
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

	def sub(original,friend)
		message_actual = original.dup
		message_actual.gsub!("$Имя",friend.firstname)
		message_actual.gsub!("$ИмяФамилия",friend.name)
		message_actual.gsub!(/\{([^\}]+)\}/)do |match|
			match.gsub("{","").gsub("}","").split("|").sample
		end
		message_actual
	end
	
	def aviable_text_features
		"$Имя - имя пользователя\n$ИмяФамилия - Имя и фамилия пользователя\n{привет|здорово|хай} - теги"
	end
	
	
	def add_thread(thread)
		@threads<<thread
	end
	
	def join_threads
		@threads.each{|t|t.join}
	end
end


new_version = nil
begin
	new_version = Updater.new.update
rescue
		
end

unless(new_version)

	begin
	
		data = RobotDatabase.new(File.join(File.expand_path("../.."),"data/data.db"))
		data.update()
		$db = data.db
		
	#rescue
	
	
	end

	widget = SocialRobot.new

	widget.show
	widget.raise



    splash = "../../splash/pid.txt"
	if File.exist?(splash)
		begin
			Process.kill "KILL", IO.read(splash).to_i
		rescue
		end
		File.delete(splash)
	end
	
	$app.exec
else
    Dir.chdir File.join(File.expand_path("../.."),"#{new_version}/gui/")
	
	system_command = "\"#{File.join(File.expand_path("../.."),"ruby/bin/rubyw.exe")}\" -r \"#{File.join(File.expand_path("../.."),"#{new_version}/gui/gui.rb")}\""
	
	system(system_command)
	puts "end"
end



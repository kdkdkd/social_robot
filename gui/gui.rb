$:.unshift File.dirname($0)

require 'Qt'

require './highlighter_ruby.rb'
require 'pathname'

require './help.rb'
require './settings.rb'
require './settings_window.rb'
require './updater.rb'

require './task.rb'
require 'zip/zipfilesystem'

require './data.rb'
require './table.rb'
require 'socket'
require 'json'



$db = nil

$app = Qt::Application.new(ARGV)

$client = nil

$shared = File.expand_path("../../shared")


class SocialRobot < Qt::MainWindow
	slots   'search_peoples()','database_lists()', 'read()','delete_button_click()','stop_button_click()', 'database_peoples()','database_proxy()','enter_system()','link_clicked( const QUrl & )','toggle_developer_mode()', 'open_settings()','open_files_clicked()','open_file_clicked()', 'menu_script_click()','code_changed()','run_script()','create_script()','save_script()','open_script()','insert_help(QTreeWidgetItem *, int)', 'show_loot()'


	def read
    Dir[File.join($shared,"*.in")].each do|file|

      read_failed = true
      while read_failed
        begin
          content = IO.read(file).force_encoding("UTF-8")
          read_failed = false
        rescue

        end
      end
      begin
        FileUtils.rm_rf(file)
      rescue
      end

      split = content.split("<!!MESSAGE!!>")

      split.each do |j|

        next if j =~ /^\s*$/
        j.force_encoding("UTF-8")
        json = []
        begin
          json = JSON.parse(j)

        rescue
          puts "ERROR"
        end
        json.each do |r|
          if(r["type"] == "update_name_choose_login")
            update_name_login_choose
            next
          end
          t = Task.find_id(r["id"])
          if(t)

            if r["type"] == "log"
              t.tab.append("<font color='black' size='3'>#{(r["text"]).to_s.force_encoding("UTF-8")}</font><br/>")
            elsif r["type"] == "progress"
              t.progress_text = r["text"]
            elsif r["type"] == "state"
              t.state = r["text"]
            elsif r["type"] == "total"
              t.progress_current = r["value"]
              t.progress_total = r["range"]
            elsif r["type"] == "ask"
              ask_res = ask(r["hash"])
              send_data({:hash => ask_res,:id => r["id"], :type=> :ask})
            end
          end
        end
      end


		end
	end
	
	def send_data(data)
    filename = File.join($shared,(0..32).map{(65+rand(25)).chr}.join)
    temp = "#{filename}.temp"
    File.open(temp,"w"){|f| f << data.to_json}
		FileUtils.mv(temp,"#{filename}.out")
	end
	
	#Create gui and set timer
	def initialize()
		super
    Dir::mkdir($shared) unless File.exists?($shared) && File.directory?($shared)
    FileUtils.rm_rf(Dir[File.join($shared,"*.*")])
    send_data({:type=> :exit})
    sleep 1
    FileUtils.rm_rf(Dir[File.join($shared,"*.*")])

		#start server
		server_script = File.expand_path("./server.rb")
		ruby = File.expand_path("../../ruby/bin/rubyw.exe")
  	server_process = Qt::Process.new
		server_process.start(ruby, [server_script])

		@watcher = Qt::FileSystemWatcher.new
    @watcher.addPath($shared)
    connect(@watcher,SIGNAL("directoryChanged ( const QString & )"),self,SLOT("read()"))

		setWindowTitle("Социальный робот. " + IO.read("../version.txt"))
		setWindowIcon(Qt::Icon.new("images/logo.png"))
		#Create main widgets and dock interface 
		resize(800, 600)
		all_tabs_dock = Qt::DockWidget.new("", self)
		@help_dock = Qt::DockWidget.new("Помощь", self)
		@all_tabs = Qt::TabWidget.new
		@all_tabs.setTabPosition(1)
		
		

		
		@task_table = Qt::TableWidget.new
		@task_table.setSelectionMode(0)
		@task_table.horizontalHeader().setResizeMode(2);

		@task_table.setColumnCount(7)

		h = Qt::TableWidgetItem.new("Название")
		@task_table.setHorizontalHeaderItem(0, h)

		h = Qt::TableWidgetItem.new("");
		@task_table.setHorizontalHeaderItem(1, h);

		h = Qt::TableWidgetItem.new("");
		@task_table.setHorizontalHeaderItem(2, h);


		h = Qt::TableWidgetItem.new("Статус");
		@task_table.setHorizontalHeaderItem(3, h);

		h = Qt::TableWidgetItem.new("Прогресс");
		@task_table.setHorizontalHeaderItem(4, h);

		h = Qt::TableWidgetItem.new("Дата создания");
		@task_table.setHorizontalHeaderItem(5, h);

		h = Qt::TableWidgetItem.new("Сообщение");
		@task_table.setHorizontalHeaderItem(6, h);




		@code_edit = Qt::TextEdit.new
		
		HighlighterRuby.new(@code_edit.document)
		@code_edit.plainText = "#Список друзей\nme.friends.print"
		@log_edit = Qt::TextBrowser.new
		@log_edit.openExternalLinks = false
		@log_edit.openLinks = false

		
		@name_login_choose = Qt::ComboBox.new
		
		@name_login_text = Qt::Label.new
		@name_login_text.text = "Кем выполнять действие"
		update_name_login_choose()
		
		
		

		statusBar().insertPermanentWidget(1,@name_login_choose,0)
		statusBar().insertPermanentWidget(0,@name_login_text,0)



		connect(@log_edit,SIGNAL('anchorClicked( const QUrl & )'),self,SLOT('link_clicked( const QUrl & )'))
		@help_tree = Qt::TreeWidget.new
		@log_edit.setStyleSheet("QTextBrowser{background-image: url(images/back.png);	background-repeat: repeat-xy; background-attachment: fixed;background-color: white;}")
		@code_edit.setStyleSheet("QTextEdit{font: 15px;background-image: url(images/back.png);	background-repeat: repeat-xy; background-attachment: fixed;background-color: white;}")
		@help_tree.setStyleSheet("QTreeWidget{background-image: url(images/back.png);	background-repeat: repeat-xy; background-attachment: fixed;background-color: white;}")
		@task_table.setStyleSheet("QTableWidget{background-image: url(images/back.png);	background-repeat: repeat-xy; background-attachment: fixed;background-color: white;}")


		#Properties of main widgets
		#@code_edit.setStyleSheet("font: 15px;")
		connect(@code_edit,SIGNAL('textChanged()'),self,SLOT('code_changed()'))
		@code_edit.acceptRichText = false
		@code_edit.lineWrapMode = 0
		@log_edit.lineWrapMode = 0
		@log_edit.ReadOnly = true


		setCentralWidget(@code_edit)

		#Assign widgets to docks
		all_tabs_dock.widget = @all_tabs
			addDockWidget(Qt::BottomDockWidgetArea, all_tabs_dock)
		@help_dock.widget = @help_tree
			addDockWidget(Qt::RightDockWidgetArea, @help_dock)

		@all_tabs.addTab(@task_table,"Диспетчер задач")
		@all_tabs.addTab(@log_edit,"Помощь")
    @all_tabs.currentIndex = 1


		#Allow dock widgets to be movable
		all_tabs_dock.Features = 2
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

		@database_peoples = Qt::Action.new(Qt::Icon.new("images/user.png"),"Аккаунты", self)
		@database_peoples.statusTip = "Редактировать аккаунты"
		connect(@database_peoples, SIGNAL('triggered()'), self, SLOT('database_peoples()'))


    @database_lists = Qt::Action.new(Qt::Icon.new("images/list.png"),"Списки людей", self)
		@database_lists.statusTip = "Редактировать списки людей"
		connect(@database_lists, SIGNAL('triggered()'), self, SLOT('database_lists()'))


    @search_peoples = Qt::Action.new(Qt::Icon.new("images/search.png"),"Поиск людей", self)
    @search_peoples.statusTip = "Списки людей для последующего использования"
    connect(@search_peoples, SIGNAL('triggered()'), self, SLOT('search_peoples()'))
		
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
		@fileMenu.addAction(@loot_action)
		@fileMenu.addAction(@developer_mode_action)
		@fileMenu.addAction(@open_settings_action)
		@fileMenu.addAction(@database_peoples)
		@fileMenu.addAction(@database_proxy)
    @fileMenu.addAction(@database_lists)
    @fileMenu.addAction(@search_peoples)
		@fileMenu.addAction(@exit_action)
		
		generate_menu(menuBar(),'../prog')
		generate_menu(menuBar().addMenu("Мои скрипты"),'../../my')
		
		
		@file_toolbar = addToolBar("File")
		@file_toolbar.addAction(@new_action)
		@file_toolbar.addAction(@save_action)
		@file_toolbar.addAction(@open_action)

		@run_toolbar = addToolBar("Run")
		@run_toolbar.addAction(@run_action)
		@run_toolbar.addAction(@enter_action)


		statusBar().showMessage("")


		#Lines to add to log
		@new_lines = Hash.new { |hash, key| hash[key] = [] }

		#If code has changed
		@changed = false
		
		#Proxy to call user gui dialog from script
		@res_proxy = {}
		@ask_proxy = {}
		
		
		@delete_buttons_tabs_hash = {}



		#Update tasks
		block_log_update = Proc.new do
			update_tasks
		end
		@timer_tasks_update=Qt::Timer.new(window)
		invoke_tasks_update=Qt::BlockInvocation.new(@timer_tasks_update, block_log_update, "invoke()")
		Qt::Object.connect(@timer_tasks_update, SIGNAL("timeout()"), invoke_tasks_update, SLOT("invoke()"))
		@timer_tasks_update.start(5000)

		@log_edit.append("<font color='black' size='3'>Чтобы начать работу, выберите один из пунктов меню. Например, <i>Музыка -> Cкачать мою музыку</i><br/><br/>Или нажмите на кнопку <img src=\"images/vkontakte.png\"/> Это покажет Вас и Ваших друзей и абсолютно безобидно.<br/><br/><br/>Подробнее об использовании и возможностях программы на <a href=\"http://socialrobot.net\">http://socialrobot.net</a><br><br><br>Список изменений <a href=\"https://twitter.com/#!/socialrobot_net\">https://twitter.com/#!/socialrobot_net</a></font>")
		
		update_developer_mode()
		



       
        
        
        @memory_input = {}
  end

  def database_lists
    UserTable.show
  end

  def search_peoples
    run_script_by_name("../prog/Vkontakte/Peoples/Search peoples.rb")
  end

  def new_tab(name,task)
    #Create new tab
		log_edit = Qt::TextBrowser.new
		log_edit.openExternalLinks = false
		log_edit.openLinks = false
		log_edit.setStyleSheet("QTextBrowser{background-image: url(images/back.png);	background-repeat: repeat-xy; background-attachment: fixed;background-color: white;}")
		log_edit.lineWrapMode = 0
		log_edit.ReadOnly = true
		@all_tabs.addTab(log_edit,name)
		h = Qt::PushButton.new
        h.flat = true
        h.setIcon(Qt::Icon.new("images/delete.png"))

        @delete_buttons_tabs_hash[h] = task
        connect(h,SIGNAL("clicked(bool)"), self, SLOT("delete_button_click()"))
        @all_tabs.tabBar.setTabButton(@all_tabs.tabBar.count - 1 ,1,h)
	@all_tabs.currentIndex = @all_tabs.count - 1
		connect(log_edit,SIGNAL('anchorClicked( const QUrl & )'),self,SLOT('link_clicked( const QUrl & )'))
        log_edit
  end
	
	def update_name_login_choose()
		@name_login_choose.clear()
		$db[:account].each_with_index{|acc,i|@name_login_choose.insertItem(i,acc[:email]);}
	end
	
	def database_peoples
		AccountTable.new.show
		update_name_login_choose()
		update_options()
	end
	
	def database_proxy
		ProxyTable.new.show
		update_options()
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

  def stop_button_click()
    task = @stop_buttons_hash[sender]
    if task
        task.state = "failed"
	task.progress_text = "Остановлено пользователем"
	
	send_data({:id => task.id, :type => :stop})
	sender.setEnabled(false)
    end
  end
  
  def delete_button_click()
    task = @delete_buttons_tabs_hash[sender] || @delete_buttons_table_hash[sender] 
	
    
	  if(task)
		
		(0..@all_tabs.count - 1).each do |i| 
			if @all_tabs.widget(i) == task.tab
				@all_tabs.removeTab(i)
				break
			end
		end
		task.state = "failed"
		task.progress_text = "Остановлено пользователем"
		Task.remove(task.id)
		send_data({:id => task.id, :type => :stop})
	  end
	 
        
   
	
  end

  def update_tasks
	
	@delete_buttons_table_hash = {}
	@stop_buttons_hash = {}
	all_tasks = Task.all_tasks
	all_tasks.sort!{|x,y| y.id <=> x.id }
	@task_table.setRowCount(all_tasks.length)
	all_tasks.each_with_index do |t,i|
    

       
       h = Qt::Label.new(t.name.to_s);
       h.alignment = 132
       h.margin = 20
       @task_table.setCellWidget(i,0, h);

       h = Qt::PushButton.new
       h.flat = true
       h.setIcon(Qt::Icon.new("images/stop.png"))
       
       h.setEnabled(t.state=="action")
       
       @stop_buttons_hash[h] = t
       connect(h,SIGNAL("clicked(bool)"), self, SLOT("stop_button_click()"))
       @task_table.setCellWidget(i,1, h);

	   
	h = Qt::PushButton.new
       h.flat = true
       h.setIcon(Qt::Icon.new("images/delete.png"))
       @delete_buttons_table_hash[h] = t
       connect(h,SIGNAL("clicked(bool)"), self, SLOT("delete_button_click()"))
       @task_table.setCellWidget(i,2, h);

	  

	   
          
       status = "?"
	
         case(t.state)
           when "action" then status = "Выполняется..."
           when "failed" then status = "Ошибка"
           when "done" then status = "Выполнен"
         end
       h = Qt::Label.new(status)
       h.alignment = 132
       h.margin = 20
       @task_table.setCellWidget(i,3, h)

      
		progress_text = (!t.progress_total ||t.state == "done")? "-":"#{t.progress_current} / #{t.progress_total}"
       


       h = Qt::Label.new(progress_text);
       h.alignment = 132
       @task_table.setCellWidget(i,4, h);



       h = Qt::Label.new(t.date_started.strftime("%Y-%m-%d %H:%M"));
       h.alignment = 132
       h.margin = 20
       @task_table.setCellWidget(i,5, h);

       
        progress_note = t.progress_text.to_s
       
       h = Qt::Label.new(progress_note);
       h.alignment = 132
       h.margin = 20
       @task_table.setCellWidget(i,6, h);

       @task_table.horizontalHeader().resizeSections(3);
    end
  end
	
	#Open settings window
	def open_settings
		SettingsWindow.show
		update_options()
	end
	
	def update_options
		send_data({:type=> :update_options})
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
			run_script_name(str)
		end
	end
	
	#Open loot folder
	def show_loot
		path = Qt::Dir::toNativeSeparators(File.expand_path("../../loot"));
		Qt::DesktopServices::openUrl(Qt::Url.new("file:///#{path}"));
	end

	def open(path)
		Qt::DesktopServices::openUrl(Qt::Url.new("file:///#{path}"));
	end




	#Ask if discard code edit changes or not
	def check_changes
		return true if !@changed || @code_edit.plainText.length == 0
		msgBox = Qt::MessageBox.new
		msgBox.setText("Скрипт не сохранен.")
		msgBox.setInformativeText("Все равно продолжить?")
		msgBox.setStandardButtons(Qt::MessageBox::Ok | Qt::MessageBox::Cancel)
		msgBox.setDefaultButton(Qt::MessageBox::Cancel)
    msgBox.setWindowIcon(Qt::Icon.new("images/logo.png"))
		res = msgBox.exec() == Qt::MessageBox::Ok
		@changed = false if res
		res
	end

	#On close
	def closeEvent(event)
		check = check_changes
		if check
			event.accept()
      send_data({:type=> :exit})
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

  def run_script()
     run_script_name()
  end
  
  

	
	
	#On run script clicked
	def run_script_name(name = 'Новый скрипт')
		name_save = name
		if name!="Новый скрипт"
		  begin
			name = IO.read(name.gsub(/\.rb$/,".name"))
			name.force_encoding("UTF-8")
		  rescue
			name = name_save
		  end
		end
		#Create new tab
		new_task = Task.new(name,nil)
		log_edit = new_tab(name,new_task)


		s = @code_edit.plainText
		s.force_encoding("UTF-8")
		email = @name_login_choose.currentText
		email = "" unless email
		email.force_encoding("UTF-8")
		send_data({:id => new_task.id, :eval => s, :type => :eval, :user => email, :name => name})
		
		new_task.tab = log_edit
		Task.add_task(new_task)

	end


	#On code text box changed
	def code_changed
		@changed = true
	end
	
	
	
	

	
	def ask(params_in = {})
    #map control to tab number
    tabs_hash = {}
		ask = Qt::Dialog.new
    ask.setWindowIcon(Qt::Icon.new("images/logo.png"))
		controls = []
		@controls_hash = {}
		label_hash = {}
    tabbed = params_in["tab"]

    layout_global = Qt::VBoxLayout.new

    if(tabbed)
      params_list = params_in.values.inject({}){|a,x|a[x["data"]]=x["name"];a}
      tabs = Qt::TabWidget.new
      layout_global.addWidget(tabs)
    else
      params_list = {params_in => nil}
      tabs = nil
    end


    params_list.keys.each do |params|

      layout = Qt::GridLayout.new


      widget_for_layout = Qt::Widget.new
      widget_for_layout.setLayout(layout)
      if(tabs)
        tabs.addTab(widget_for_layout, params_list[params] )

      else
        layout_global.addWidget(widget_for_layout)
      end
      if(params == "USERLIST")
        usertable = UserTable.new
        tabs_hash[usertable] = tabs.count - 1 if tabbed
        layout.addWidget(usertable)
        controls << usertable
      else
        index = 0
        layout.setContentsMargins(10,10,10,10)
		    layout.HorizontalSpacing = 75
		    layout.VerticalSpacing = 10
        params.each_key do |param|
          param_label = nil
          if param =~ /^IMAGE/
              param_copy = param.gsub(/^IMAGE/,"")
            pixmap = Qt::Pixmap.new("../../loot/captcha/#{param_copy}.png")
            label = Qt::Label.new;
            label.setPixmap(pixmap);

          else
            label = Qt::Label.new
            label.setTextInteractionFlags(1)
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
          tabs_hash[input] = tabs.count - 1 if tabbed


          layout.addWidget(label,index,0)


          index += 1
        end

      end

    end

    exit_button = Qt::PushButton.new("Ок",ask)
		layout_global.addWidget(exit_button,0,2)
    exit_button.setMaximumSize(Qt::Size.new(150, 100))
		connect(exit_button,SIGNAL('clicked()'),ask,SLOT('accept()'))
		
		

		ask.windowTitle = "Введите значения"
		ask.setLayout(layout_global)
		res_exec = ask.exec

		if res_exec == 0

			return [nil]
		end
		res = []
		controls.each do |control|

      if(!tabbed || tabs_hash[control] == tabs.currentIndex)
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
        when /UserTable/
          res.push(control.res)
          control.save_task_id
        end
      end
			string_label = label_hash[control]
			@memory_input[string_label] = res.last if(string_label)

		end
		res.push(tabs.currentIndex) if(tabbed)
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

end



class ProxyTable

	def show
		window = Qt::Dialog.new
		window.windowTitle = "Прокси сервера"
		window.resize(400, 600)
		layout = Qt::GridLayout.new 
		
		edit = Qt::TextEdit.new
		proxy = $db[:proxy]
		all = ""
		proxy.each do |p|
      add_string = "#{p[:server]}:#{p[:port]}"
      add_string+=":#{p[:login]}:#{p[:password]}" if((p[:password] && p[:password].length>0) || (p[:login] && p[:login].length>0))
      all += "#{add_string}\n"
    end
		edit.plainText = all
		
		
		ok = Qt::PushButton.new
		ok.text = "ок"
		
		
		layout.addWidget(edit,0,0,1,3)
		window.connect(ok,SIGNAL('clicked()'),window,SLOT('accept()'))		
		use_checkbox = Qt::CheckBox.new("Использовать прокси")
		use_checkbox.checked = Settings["use_proxy"] == "true"
		layout.addWidget(use_checkbox,1,0)
		layout.addWidget(ok,2,2)
		window.setLayout(layout)
    window.setWindowIcon(Qt::Icon.new("images/logo.png"))
		if(window.exec!=0)
			proxy.delete
			import = []
			edit.plainText.each_line do |line|
				line = line.gsub(/\s+/,"")

				split = line.split(":")

				
				import.push([split[0],split[1],split[2],split[3],"unknown"]) if (split[1] && split[0] && split[0].length>0 && split[1].length>0)
			end
			proxy.import([:server, :port,:login,:password,:active], import)
			Settings["use_proxy"] = use_checkbox.checked.to_s
			Settings.save	
		end
	end


end

class UserTable < Qt::Widget

  slots 'code_changed()','list_selected ( )','add_clicked()' , 'delete_clicked()', 'save_task_id()'

  def code_changed
     @last_selected_changed = true
  end

  def res
    @edit.plainText.force_encoding("UTF-8").split("\n")
  end

  def save_task_id
    if @last_selected_id && @last_selected_changed
      $db[:user].filter(:list_id=>@last_selected_id).delete
			import = []
			@edit.plainText.each_line do |line|
        line.gsub!("\r","")
        line.gsub!("\n","")
				split = line.split(":")
				import.push([split[0],split[1] || "",@last_selected_id])
			end
			$db[:user].import([:id,:name,:list_id], import)
    end
  end

  def list_selected()
    if @list.currentItem.nil?
       @label.text = "Список не выбран"
       @edit.setStyleSheet("QTextEdit{background-color: #E8E8E8;}")
       @edit.plainText = ""
       @last_selected_changed = false
       return
    end
    @edit.setStyleSheet("QTextEdit{background-color: white;}")
    list_id = $db[:list][:name=>@list.currentItem.text][:id]
    save_task_id
    @last_selected_id = list_id



    @edit.readOnly = false
    all = ""
    count = 0
		$db[:user].filter(:list_id=>list_id).each do |u|
      add_string = u[:id].to_s
      add_string += ":#{u[:name]}" if(u[:name].length>0)
      all += "#{add_string}\n"
      count += 1
    end
    @label.text = "#{@list.currentItem.text.force_encoding("UTF-8")}\nКолчество : #{count}"
		@edit.plainText = all
     @last_selected_changed = false
  end

  def delete_clicked
     if @list.currentItem.nil?
       @label.text = "Список не выбран"
       return
     end
      $db[:list].filter(:name=>@list.currentItem.text).delete
     @list.takeItem(@list.currentRow)
  end

  def add_clicked
    new_text = Qt::InputDialog.getText( self, "Название нового списка", "Название нового списка")
    return unless new_text
    new_text.force_encoding("UTF-8")
    $db[:list].insert(:name=>new_text)
    newItem = Qt::ListWidgetItem.new
    newItem.setIcon(Qt::Icon.new("images/list.png"))
    newItem.setText(new_text)
    @list.insertItem(0, newItem)
    @list.currentRow = 0
  end

  def initialize
    super
    @last_selected_id = nil
    @last_selected_changed = nil
    layout = Qt::HBoxLayout.new
    right_widget = Qt::Widget.new
    right_layout = Qt::VBoxLayout.new
    right_widget.setLayout(right_layout)


    @edit = Qt::TextEdit.new
    @edit.readOnly = true
    @edit.setStyleSheet("QTextEdit{background-color: #E8E8E8;}")
    connect(@edit,SIGNAL('textChanged()'),self,SLOT('code_changed()'))
    @label = Qt::Label.new
    @label.text = "Списки. Сюда попадают результаты поиска.\nЭто сделано для того,\nчтобы не использовать поиск повторно.\nЛюбую информацию можно редактировать."
    right_layout.addWidget(@label)
    right_layout.addWidget(@edit)

    self.setLayout(layout)
    list_and_commands = Qt::Widget.new
    list_and_commands_layout = Qt::VBoxLayout.new
    list_and_commands.setLayout(list_and_commands_layout)
    add = Qt::PushButton.new
    add.text = "Добавить список людей"
    add.setIcon(Qt::Icon.new("images/add.png"))
    connect(add,SIGNAL('clicked()'),self,SLOT('add_clicked ()'))
    delete = Qt::PushButton.new
    delete.text = "Удалить список людей"
    delete.setIcon(Qt::Icon.new("images/delete.png"))
    connect(delete,SIGNAL('clicked()'),self,SLOT('delete_clicked ()'))
    delete.iconSize =  Qt::Size.new(16,16)
    @list = Qt::ListWidget.new
    connect(@list,SIGNAL('itemSelectionChanged  ()'),self,SLOT('list_selected ()'))

    list_and_commands_layout.addWidget(@list)
    list_and_commands_layout.addWidget(add)
    list_and_commands_layout.addWidget(delete)
    layout.addWidget(list_and_commands)
    layout.addWidget(right_widget)
    $db[:list].each do |list|
      newItem = Qt::ListWidgetItem.new
      newItem.setIcon(Qt::Icon.new("images/list.png"))
      newItem.setText(list[:name])
      @list.insertItem(0, newItem)

    end
  end


  def UserTable.show
    window = Qt::Dialog.new
		window.windowTitle = "Списки"
    window.resize(800, 600)
    layout = Qt::VBoxLayout.new
    window.setLayout(layout)
    ok = Qt::PushButton.new
    ok.text = "ок"
    ok.setMaximumSize(Qt::Size.new(150, 100));
    main = self.new
    window.connect(ok,SIGNAL('clicked()'),main,SLOT('save_task_id()'))
    window.connect(ok,SIGNAL('clicked()'),window,SLOT('accept()'))
    layout.addWidget(main)
    layout.addWidget(ok,0,2)
    window.setWindowIcon(Qt::Icon.new("images/logo.png"))
    window.exec
  end

end

class AccountTable

	def show
		window = Qt::Dialog.new
		window.windowTitle = "Аккаунты"
		window.resize(400, 600)
		layout = Qt::GridLayout.new 
		
		edit = Qt::TextEdit.new
		account = $db[:account]
    all_pass = ""
		account.each{|p|
      email = p[:email]
      password = p[:password]
      email.force_encoding("UTF-8")
      password.force_encoding("UTF-8")
      all_pass += "#{email}:#{password}\n"

    }
		edit.plainText = all_pass
		ok = Qt::PushButton.new
		ok.text = "ок"
		layout.addWidget(edit,0,0,1,3)
		window.connect(ok,SIGNAL('clicked()'),window,SLOT('accept()'))		
		layout.addWidget(ok,1,2)
		window.setLayout(layout)
		all = account.to_a
    window.setWindowIcon(Qt::Icon.new("images/logo.png"))
		if(window.exec!=0)
			account.delete
			import = []
			edit.plainText.each_line do |line|
				line = line.gsub(/\s+/,"")
				line.force_encoding("UTF-8")
				split = line.split(":")
				acc = all.find{|x| x[:email] == split[0]}
				hash = ""
				hash = acc[:hash] if(acc)
				import.push([split[0],split[1],hash,""]) if (split[1] && split[0] && split[0].length>0 && split[1].length>0)
			end
			account.import([:email,:password,:hash,:name], import)
		end
	end


end



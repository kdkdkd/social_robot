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
    r = @edit.plainText.force_encoding("UTF-8").split("\n")
    return {"data" => r} unless @list.currentItem
    item_data = @list.currentItem.data(32).toString
    if(item_data && item_data.length>0)
      return {"data" => r, "history_list_id" => item_data}
    else
      return {"data" => r, "list_id" => $db[:list][:name=>@list.currentItem.text][:id]}
    end
  end

  def save_task_id
    if @last_selected_changed
      if(@last_selected_list_id || @last_selected_history_id)
        import = []
        @edit.plainText.each_line do |line|
          line.gsub!("\r","")
          line.gsub!("\n","")
          split = line.split(":")
          import.push([split[0],split[1] || ""])
        end
      end
      if(@last_selected_list_id)
        $db[:user].filter(:list_id=>@last_selected_list_id).delete

        $db[:user].import([:id,:name,:list_id], import.map{|a|a.push(@last_selected_list_id);a})
      elsif(@last_selected_history_id)
        #Remove old history
        $db[:history_item].filter(:history_list_id=>@last_selected_history_id).delete

        #Take existing list id or create new one
        list_id = $db[:history_list][:id=>@last_selected_history_id][:list_id]
        list_id = $db[:list].filter[:visible=>0,:id=>list_id]
        if (list_id)
          list_id = list_id[:id]
          $db[:user].filter(:list_id=>list_id).delete
        else
          list_id = $db[:list].insert(:name=>"invisible",:visible=>0)
          $db[:history_list].filter(:id=>@last_selected_history_id).update(:list_id => list_id)
        end

        $db[:user].import([:id,:name,:list_id], import.map{|a|a.push(list_id);a})



      end
    end
  end

  def list_selected()
    if @list.currentItem.nil?
       @label.text = "Список не выбран"
       @edit.setStyleSheet("QTextEdit{background-color: #E8E8E8;}")
       @edit.plainText = ""
       @last_selected_changed = false
       @delete.text = "Удалить все списки людей"
       @delete_all_lists = true
       return
    else
      @delete.text = "Удалить текущий список людей"
      @delete_all_lists = false
    end
    @edit.setStyleSheet("QTextEdit{background-color: white;}")
    item_data = @list.currentItem.data(32).toString
    is_history_selected_or_list = item_data && item_data.length>0
    if(is_history_selected_or_list)
      list_id = $db[:history_list][:id=>item_data][:list_id]
      q = "list_id = #{list_id} and id not in (SELECT object_id FROM history_item where history_list_id = #{item_data})"
    else
      list_id = $db[:list][:name=>@list.currentItem.text][:id]
      q = "list_id = #{list_id}"
    end

    save_task_id
    if(is_history_selected_or_list)
      @last_selected_history_id = item_data
      @last_selected_list_id = nil
    else
      @last_selected_list_id = list_id
      @last_selected_history_id = nil
    end



    @edit.readOnly = false
    all = ""
    count = 0
		$db[:user].filter(q).each do |u|
      add_string = u[:id].to_s
      add_string += ":#{u[:name]}" if(u[:name] && u[:name].length>0)
      all += "#{add_string}\n"
      count += 1
    end
    @label.text = "#{@list.currentItem.text.force_encoding("UTF-8")}\nКоличество : #{count}"
		@edit.plainText = all
     @last_selected_changed = false
  end

  def delete_clicked
    if @delete_all_lists

      #if(@list.count>0)

        msgBox = Qt::MessageBox.new
        msgBox.setText("Удалить все списки.")
        msgBox.setInformativeText("Вы действительно хотите удалить все списки?")
        msgBox.setStandardButtons(Qt::MessageBox::Ok | Qt::MessageBox::Cancel)
        msgBox.setDefaultButton(Qt::MessageBox::Cancel)
        msgBox.setWindowIcon(Qt::Icon.new("images/logo.png"))
        res = msgBox.exec() == Qt::MessageBox::Ok
        if(res)
          $db[:list].delete
          $db[:user].delete
          $db[:history_list].delete
          $db[:history_item].delete
          @list.clear()
        end
      #end

    else
      if @list.currentItem.nil?
        @label.text = "Список не выбран"
        @delete.text = "Удалить все списки людей"
        @delete_all_lists = true
       return
      end
      item_data = @list.currentItem.data(32).toString
      if(item_data && item_data.length>0)

        list_id = $db[:history_list][:id=>item_data][:list_id]
        list_id = $db[:list].filter[:visible=>0,:id=>list_id]
        if(list_id)
          list_id = list_id[:id]
          $db[:list].filter(:visible=>0,:id=>list_id).delete
          $db[:user].filter(:list_id=>list_id).delete
        end

        $db[:history_list].filter(:id=>item_data).delete
        $db[:history_item].filter(:history_list_id=>item_data).delete
      else
        list_id = $db[:list][:name=>@list.currentItem.text][:id]
        if($db[:history_list].filter(:list_id=>list_id).count == 0)
          $db[:user].filter(:list_id=>list_id).delete
          $db[:list].filter(:name=>@list.currentItem.text).delete
        else
          $db[:list].filter(:name=>@list.currentItem.text).update(:visible=>0)
        end

      end

     @list.takeItem(@list.currentRow)
  end

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
    @last_selected_list_id = nil
    @last_selected_history_id = nil
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
    @delete = Qt::PushButton.new
    @delete.text = "Удалить все списки людей"
    @delete_all_lists = true

    @delete.setIcon(Qt::Icon.new("images/delete.png"))
    connect(@delete,SIGNAL('clicked()'),self,SLOT('delete_clicked ()'))
    @delete.iconSize =  Qt::Size.new(16,16)
    @list = Qt::ListWidget.new
    connect(@list,SIGNAL('itemSelectionChanged  ()'),self,SLOT('list_selected ()'))

    list_and_commands_layout.addWidget(@list)
    list_and_commands_layout.addWidget(add)
    list_and_commands_layout.addWidget(@delete)
    layout.addWidget(list_and_commands)
    layout.addWidget(right_widget)
    $db[:history_list].filter("list_id > 0").each do |list|
      newItem = Qt::ListWidgetItem.new
      newItem.setIcon(Qt::Icon.new("images/list.png"))
      newItem.setText("Продолжить задачу\n#{list[:name]}\nОт #{list[:date]}")
      newItem.setData(32,Qt::Variant.new(list[:id]))
      @list.insertItem(0, newItem)
    end
    $db[:list].filter(:visible=>1).each do |list|
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



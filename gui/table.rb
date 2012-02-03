class ProxyTable

	def show
		window = Qt::Dialog.new
		window.windowTitle = "Прокси сервера"
		window.resize(400, 600)
		layout = Qt::GridLayout.new 
		
		edit = Qt::TextEdit.new
		proxy = $db[:proxy]
		
		proxy.each{|p| add_string = "#{p[:server]}:#{p[:port]}"; add_string+=":#{p[:login]}:#{p[:password]}" if((p[:password] && p[:password].length>0) || (p[:login] && p[:login].length>0));  edit.plainText += "#{add_string}\n"}
		
		
		
		ok = Qt::PushButton.new
		ok.text = "ок"
		
		
		layout.addWidget(edit,0,0,1,3)
		window.connect(ok,SIGNAL('clicked()'),window,SLOT('accept()'))		
		use_checkbox = Qt::CheckBox.new("Использовать прокси")
		use_checkbox.checked = Settings["use_proxy"] == "true"
		layout.addWidget(use_checkbox,1,0)
		layout.addWidget(ok,2,2)
		window.setLayout(layout)
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
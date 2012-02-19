require 'Qt'



class SettingsWindow < Qt::Dialog
  slots 'update_captcha_solver ( int )'
  attr_accessor :antigate_key_label, :antigate_key_textbox

  def self.show
		window = SettingsWindow.new
		layout = Qt::GridLayout.new  

		use_anonymizer_label = Qt::Label.new
		use_anonymizer_label.text = "Использовать анонимайзер"
		layout.addWidget(use_anonymizer_label,0,0)
		use_anonymizer_ceckbox = Qt::CheckBox.new
		use_anonymizer_ceckbox.checked  = Settings["use_anonymizer"] == "true"
		layout.addWidget(use_anonymizer_ceckbox,0,1)


    user_fetch_interval_label = Qt::Label.new
		user_fetch_interval_label.text = "Интервал между загрузкой страницы пользователя"
		layout.addWidget(user_fetch_interval_label,1,0)
		user_fetch_interval_ceckbox = Qt::DoubleSpinBox.new
		user_fetch_interval_ceckbox.value  = Settings["user_fetch_interval"].to_f
		layout.addWidget(user_fetch_interval_ceckbox,1,1)


    photo_mark_interval_label = Qt::Label.new
		photo_mark_interval_label.text = "Интервал между отмечанием на фотографии"
		layout.addWidget(photo_mark_interval_label,2,0)
		photo_mark_interval_ceckbox = Qt::DoubleSpinBox.new
		photo_mark_interval_ceckbox.value  = Settings["photo_mark_interval"].to_f
		layout.addWidget(photo_mark_interval_ceckbox,2,1)


    like_interval_label = Qt::Label.new
		like_interval_label.text = "Интервал между лайками"
		layout.addWidget(like_interval_label,3,0)
		like_interval_ceckbox = Qt::DoubleSpinBox.new
		like_interval_ceckbox.value  = Settings["like_interval"].to_f
		layout.addWidget(like_interval_ceckbox,3,1)

    mail_interval_label = Qt::Label.new
		mail_interval_label.text = "Интервал между почтой"
		layout.addWidget(mail_interval_label,4,0)
		mail_interval_ceckbox = Qt::DoubleSpinBox.new
		mail_interval_ceckbox.value  = Settings["mail_interval"].to_f
		layout.addWidget(mail_interval_ceckbox,4,1)


    post_interval_label = Qt::Label.new
		post_interval_label.text = "Интервал между сообщениями на стене"
		layout.addWidget(post_interval_label,5,0)
		post_interval_ceckbox = Qt::DoubleSpinBox.new
		post_interval_ceckbox.value  = Settings["post_interval"].to_f
		layout.addWidget(post_interval_ceckbox,5,1)


    invite_interval_label = Qt::Label.new
		invite_interval_label.text = "Интервал между приглашениями"
		layout.addWidget(invite_interval_label,6,0)
		invite_interval_ceckbox = Qt::DoubleSpinBox.new
		invite_interval_ceckbox.value  = Settings["invite_interval"].to_f
		layout.addWidget(invite_interval_ceckbox,6,1)





    captcha_solver_label = Qt::Label.new
		captcha_solver_label.text = "Разгадывание капчи"
		layout.addWidget(captcha_solver_label,7,0)
		captcha_solver_combo = Qt::ComboBox.new

		captcha_solver_combo.insertItem(0,"Вручную")
    captcha_solver_combo.insertItem(1,"antigate.com")


    window.antigate_key_label = Qt::Label.new
		window.antigate_key_label.text = "Ключ api. Можно узнать тут:\nhttp://antigate.com/panel.php?action=showkey"
		layout.addWidget(window.antigate_key_label,8,0)
		window.antigate_key_textbox = Qt::LineEdit.new
		window.antigate_key_textbox.text  = Settings["antigate_key"].to_s
		layout.addWidget(window.antigate_key_textbox,8,1)



    connect(captcha_solver_combo,SIGNAL('currentIndexChanged ( int )'),window,SLOT('update_captcha_solver ( int )'))
    if(Settings["captcha_solver"]=="1")
      captcha_solver_combo.setCurrentIndex(1)
      window.update_captcha_solver(1)
    else
      captcha_solver_combo.setCurrentIndex(0)
      window.update_captcha_solver(0)
    end
		layout.addWidget(captcha_solver_combo,7,1)

    login_interval_label = Qt::Label.new
		login_interval_label.text = "Интервал между входами в систему"
		layout.addWidget(login_interval_label,9,0)
		login_interval_ceckbox = Qt::DoubleSpinBox.new
		login_interval_ceckbox.value  = (Settings["login_interval"].nil?)? 4.0:Settings["login_interval"].to_f
		layout.addWidget(login_interval_ceckbox,9,1)


    exit_button = Qt::PushButton.new("Ок",window)
		layout.addWidget(exit_button,10,1,Qt::AlignRight)
		connect(exit_button,SIGNAL('clicked()'),window,SLOT('accept()'))


		layout.setContentsMargins(50,50,50,50)
		layout.HorizontalSpacing = 75
		layout.VerticalSpacing = 30
		window.windowTitle = "Настройки"
		window.setLayout(layout)
		if(window.exec!=0)
			Settings["use_anonymizer"] = use_anonymizer_ceckbox.checked.to_s
      Settings["user_fetch_interval"] = user_fetch_interval_ceckbox.value.to_s
      Settings["photo_mark_interval"] = photo_mark_interval_ceckbox.value.to_s
      Settings["like_interval"] = like_interval_ceckbox.value.to_s
      Settings["mail_interval"] = mail_interval_ceckbox.value.to_s
      Settings["post_interval"] = post_interval_ceckbox.value.to_s
      Settings["invite_interval"] = invite_interval_ceckbox.value.to_s
      Settings["login_interval"] = login_interval_ceckbox.value.to_s
      Settings["captcha_solver"] = captcha_solver_combo.currentIndex.to_s
      if(captcha_solver_combo.currentIndex == 0)
        Settings["antigate_key"] = nil
      else
        Settings["antigate_key"] = window.antigate_key_textbox.text.to_s
      end
		Settings.save		
	  end
  end

  def update_captcha_solver ( index )
    if(index == 1)
      self.antigate_key_label.visible = true
      self.antigate_key_textbox.visible = true
    else
      self.antigate_key_label.visible = false
      self.antigate_key_textbox.visible = false
    end

  end

		
end
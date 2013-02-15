require "./data.rb"
require "Qt"
require 'qtwebkit'
require "../lib/utfto1251.rb"

class MultiBrowserTab < Qt::Widget
  slots 'url_changed ( const QUrl & )' , 'return_pressed()' , 'tab_changed()'
	
  attr_accessor :email,:password

  
  def tab_changed()
	load_vk if(@list_widget.currentItem && @list_widget.currentItem.text == email)
  end
  
  def return_pressed()
	text = @adress.text
	text = "http://" + text if(!(text =~ /http:\/\//) && !(text =~ /https:\/\//))
	
	
	@webview.load(Qt::Url.new(text))
  end
  
  def url_changed(url)
	@adress.text = url.toString.force_encoding("UTF-8")
  end
  
  def set_vk(email,password,list_widget)
	@email,@password,@list_widget = email,password,list_widget
	
  end
  
  def load_vk()
	unless @loaded
		url = Qt::Url.new
		array = Qt::ByteArray.new
		#array.append("http://vk.com/login.php?m=1&email=#{email}&pass=#{UtfToWin.new.urlencode(password)}")
		array.append("http://login.vk.com/?act=login&email=#{email}&pass=#{UtfToWin.new.urlencode(password)}")
		url.setEncodedUrl(array)
		@webview.load(url)
	end
	@loaded = true
  end
  
  def initialize
    super
	
	@loaded = false
    layout = Qt::VBoxLayout.new



    @webview = Qt::WebView.new
	
    @adress = Qt::LineEdit.new
	
	
	hlayout = Qt::HBoxLayout.new
	
	@back = Qt::PushButton.new
	@back.flat = true
	@back.setIcon(Qt::Icon.new("images/multibrowser_back.png"))
	@refresh = Qt::PushButton.new
	@refresh.flat = true
	@refresh.setIcon(Qt::Icon.new("images/multibrowser_refresh.png"))
	
	hlayout.addWidget(@back)
	hlayout.addWidget(@refresh)
	hlayout.addWidget(@adress)
	@adress.setStyleSheet("QLineEdit {border: 2px groove gray; border-radius: 10px;height:25px}")
	@progress = Qt::ProgressBar.new
	@progress.setMaximum(100)
	
	
    layout.addLayout(hlayout)
    layout.addWidget(@webview)
	layout.addWidget(@progress)
	
	connect(@adress,SIGNAL('returnPressed ()'),self,SLOT('return_pressed ()'))
	connect(@webview,SIGNAL('urlChanged ( const QUrl & )'),self,SLOT('url_changed ( const QUrl & )'))
	connect(@webview,SIGNAL('loadProgress ( int )'),@progress,SLOT('setValue ( int )'))
	connect(@webview,SIGNAL('loadFinished(bool)'),@progress,SLOT('hide()'))
	connect(@webview,SIGNAL('loadStarted()'),@progress,SLOT('show()'))
	connect(@back,SIGNAL('clicked()'),@webview,SLOT('back()'))
	connect(@refresh,SIGNAL('clicked()'),@webview,SLOT('reload()'))
	
	
	
    self.setLayout(layout)

  end


  

end

class MultiBrowser < Qt::Widget

  slots 'tab_changed()'
  
  def check_empty
	if(@hash.length == 0)
		@list.hide()
		@no_accounts_message.show()
	else
		@list.show()	
		@no_accounts_message.hide()
		@list.currentRow = 0 unless @list.currentItem
	end
  end
  
  
  def tab_changed
	@hash.each_value{|x|x.hide()}
	if(@list.currentItem)
		tab = @hash[@list.currentItem.text]
		tab.show() if tab
	end
  
  end
  
  def update_user_list
  
	accounts = $db[:account].to_a
	
	accounts.each do |acc|
		unless(@hash.has_key?(acc[:email]))
			add_tab(acc)
		end
    end
	
	@hash.each_key do |email|
		remove_tab(email) unless accounts.find{|x|x[:email] == email}
	
	end
	
	check_empty()
  end
  
  
  def remove_tab(email)
	@hash[email].hide()
	@hash.delete(email) 
    
	(0..(@list.count-1)).each do |i| 
		if(@list.item(i).text == email)
			@list.takeItem(i) 
			break
		end
	end
  end
  
  def add_tab(acc,first = false)
    tab = MultiBrowserTab.new
	tab.set_vk(acc[:email],acc[:password],@list)
	tab.hide
	@layout.addWidget(tab)
	@hash[acc[:email]] = tab
	
	Qt::Object.connect(@list,SIGNAL('currentRowChanged(int)'),tab,SLOT('tab_changed()'))
	Qt::Object.connect(@list,SIGNAL('currentRowChanged(int)'),self,SLOT('tab_changed()'))
	
	
	newItem = Qt::ListWidgetItem.new
	newItem.setIcon(Qt::Icon.new("images/user.png"))
	newItem.setText(acc[:email])
	@list.insertItem(@list.count, newItem)
	if first
		tab.load_vk() 
		newItem.setSelected(first)
	end
	tab
  end

  def initialize
    super
    
	self.windowTitle = "Мультибраузер"
    self.resize(800, 600)
	@central_layout = Qt::HBoxLayout.new
    @splitter = Qt::Splitter.new
	@central_layout.addWidget(@splitter)
	@layout = Qt::HBoxLayout.new
	@widget = Qt::Widget.new
	@widget.setLayout(@layout)
	@list = Qt::ListWidget.new
    @list.setSelectionMode(Qt::AbstractItemView::SingleSelection)
	
	
	self.setLayout(@central_layout)
	
	
	first = true
	@hash = {}
	@splitter.addWidget(@list)
	@splitter.addWidget(@widget)
	@no_accounts_message = Qt::Label.new()
	@no_accounts_message.text = "Вы не ввели ни одного аккаунта. Это можно сделать в меню Файл -> Аккаунты"
	@no_accounts_message.setAlignment(Qt::AlignCenter)
	@layout.addWidget(@no_accounts_message)
	$db[:account].each do |acc|
		tab = add_tab(acc,first)
		first = false
    end
	@list.currentRow = 0 unless first
	check_empty()
	
	
    self.setWindowIcon(Qt::Icon.new("images/logo.png"))
    #Update user_list
	block_log_update = Proc.new do
		update_user_list
	end
	@timer_tasks_update=Qt::Timer.new(window)
	invoke_tasks_update=Qt::BlockInvocation.new(@timer_tasks_update, block_log_update, "invoke()")
	Qt::Object.connect(@timer_tasks_update, SIGNAL("timeout()"), invoke_tasks_update, SLOT("invoke()"))
	@timer_tasks_update.start(5000)
  end
end


class Element
	
	def initialize(element)
		@element = element
	end
	
	def text(text_to_set)
		@element.setAttribute("value", text_to_set)
	end
	
	def click
		puts @element
		@element.evaluateJavaScript("this.click()")
	end
	
end


class Browser < Qt::Widget


	def initialize
		super
		
		self.windowTitle = "Браузер"
		self.resize(800, 600)
		@webview = Qt::WebView.new
		@layout = Qt::VBoxLayout.new
		@progress = Qt::ProgressBar.new
		@progress.setMaximum(100)
		connect(@webview,SIGNAL('loadProgress ( int )'),@progress,SLOT('setValue ( int )'))
		connect(@webview,SIGNAL('loadFinished(bool)'),@progress,SLOT('hide()'))
		connect(@webview,SIGNAL('loadStarted()'),@progress,SLOT('show()'))
	
		@layout.addWidget(@webview)
		@layout.addWidget(@progress)
		self.setLayout(@layout)
		
		show
	end
	
	def css(selector)
		el = @webview.page.mainFrame.findFirstElement(selector)
		return nil unless el
		Element.new(el)
	end
	
	
	
	
	def load(url)
		@webview.load(Qt::Url.new(url))
		loop = Qt::EventLoop.new
        connect(@webview,SIGNAL('loadFinished(bool)'), loop, SLOT('quit()'))
        loop.exec
		self
	end

end





#MultiBrowser.new.show

#browser = Browser.new
#google_page = browser.load("http://google.com/")
#sleep 1
#google_page.css('input[name="q"]').text("dota")
#sleep 1
#google_page.css('button[name="btnG"]').click()
#sleep 1


#$app.exec

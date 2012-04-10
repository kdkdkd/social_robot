require "Qt"
require 'qtwebkit'



class Element
	
	
	def eval(script)
		@element.evaluateJavaScript(script)
	end
	
	def get_href
		get_attr("href")
	end
	
	def get_attr(name)
		@element.attribute(name).force_encoding("UTF-8")
	end
	
	def to_s
		@element.toOuterXml().force_encoding("UTF-8")
	end
	
	
	def initialize(element,parent)
		@element = element
		@parent = parent
	end
	
	def focus
		eval("this.blur();this.focus();")
	end
	
	def set_value(text_to_set)
		focus
		@element.setAttribute("value", text_to_set)
		@element
	end
	

	
	def click
		eval("var myEvt = document.createEvent('MouseEvents');myEvt.initEvent('click',true,true);this.dispatchEvent(myEvt);")
		@parent.wait
		@parent
	end
	
end



class Browser < Qt::Widget

	slots 'url_changed ( const QUrl & )','stop()','timeout()'
	
	def stop
		@webview.setHtml("stopped")
	end
	
	def timeout
		@webview.setHtml("timeout")
	end

	def url_changed(url)
		@adress.text = url.toString.force_encoding("UTF-8")
	end

	def initialize
		super
		
		self.windowTitle = "Браузер"
		self.resize(800, 600)
		@adress = Qt::LineEdit.new
		@webview = Qt::WebView.new
		
		@layout = Qt::VBoxLayout.new
		@progress = Qt::ProgressBar.new
		@progress.setMaximum(100)
		connect(@webview,SIGNAL('loadProgress ( int )'),@progress,SLOT('setValue ( int )'))
		connect(@webview,SIGNAL('loadFinished(bool)'),@progress,SLOT('hide()'))
		connect(@webview,SIGNAL('loadStarted()'),@progress,SLOT('show()'))
		connect(@webview,SIGNAL('urlChanged ( const QUrl & )'),self,SLOT('url_changed ( const QUrl & )'))
		@layout.addWidget(@adress)
		@layout.addWidget(@webview)
		@layout.addWidget(@progress)
		
		@adress.setStyleSheet("QLineEdit {border: 2px groove gray; border-radius: 10px;height:25px}")
		self.setLayout(@layout)
		
		
	end
	
	
	def disable_images
		@webview.page.settings.setAttribute(0,false)
	end
	
	def set_proxy(server,port,user = "", password = "")
		@webview.page.networkAccessManager.setProxy(Qt::NetworkProxy.new(3,server,port.to_i,user,password) ) 
	end
	
	
	
	#Search your domain in google
	def google(q,domain,lang)
		load("http://www.google.com/search?ie=UTF-8&hl=#{lang}&q=#{q}")
		clicked = false
		depth = 0
		while true
			return self if click_by_href(domain)
			if(lang == "ru")
				next_string = ">Следующая<"
			else
				next_string = ">Next<"
			end
			return nil unless click_by_html(next_string)
			self.sleep 5
			depth += 1 
			return nil if depth > 30
		end
		nil
	
	end
	
	def tab
		self
	end
	
	def show_browser(name,parent_widget)
		parent_widget.new_browser_tab(name,self)
		show
	end
	
	def first_css(selector)
		el = @webview.page.mainFrame.findFirstElement(selector)
		return nil unless el
		Element.new(el,self)
	end
	
	def all_css(selector)
		res = []
		list = @webview.page.mainFrame.findAllElements(selector)
		list.count.times{|i|res.push(Element.new(list[i],self))}
		res
	end
	
	def click_any_link(number,sleep_time)
		(number-1).times do
			any_link = all_css('a').sample
			any_link.click if(any_link)
			self.sleep(sleep_time)
		end
		any_link = all_css('a').sample
		any_link.click if(any_link)
			
	end
	
	def click_by_html(html)
		el = find_by_html(html)
		if el
			return el.click
		else
			return nil
		end
	end
	
	def find_by_html(html)
		all_css('a').find{|a|a.to_s.index(html)}
	end
	
	def click_by_href(href)
		el = find_by_href(href)
		if el
			return el.click
		else
			return nil
		end
	end
	
	def find_by_href(href)
		all_css('a').find{|a|a.get_href.index(href)}
	end
	
	
	def load(url)
		
		@webview.load(Qt::Url.new(url))
		wait
		self
	end
	
	def wait
		loop = Qt::EventLoop.new
        connect(@webview,SIGNAL('loadFinished(bool)'), loop, SLOT('quit()'))
		
		timer=Qt::Timer.new
		Qt::Object.connect(timer, SIGNAL("timeout()"), loop, SLOT('quit()'))
		Qt::Object.connect(timer, SIGNAL("timeout()"), self, SLOT('timeout()'))
		timer.start(30000)

        loop.exec
		timer.stop
	end
	
	
	def sleep(time_to_sleep)
		loop = Qt::EventLoop.new
		timer=Qt::Timer.new
		Qt::Object.connect(timer, SIGNAL("timeout()"), loop, SLOT('quit()'))
		timer.start(time_to_sleep * 1000)
        loop.exec
	end
end


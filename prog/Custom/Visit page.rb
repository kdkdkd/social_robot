
ar = $db[:proxy].to_a


res = ask("адрес картинки" => "string", "реферер" => "string")


agents = ['Opera/9.80 (Windows NT 6.1; U; ru) Presto/2.10.229 Version/11.61'] + (Mechanize::AGENT_ALIASES.keys - ['Mechanize']).map{|x| Mechanize::AGENT_ALIASES[x].dup}

i = 0
while true
	agent_browser =  agents.sample
	agent = Mechanize.new{ |agent|  agent.user_agent = agent_browser}
	agent.request_headers["Referer"]=res[1]

	safe{
		
		
		server = ""
		if(ar.length>0 && Settings["use_proxy"] == "true")
			server = ar[i][:server]
			port = ar[i][:port]
			login = ar[i][:login]
			pass = ar[i][:password]
			server.force_encoding("UTF-8")
			port.force_encoding("UTF-8")
			pass.force_encoding("UTF-8") if pass
			login.force_encoding("UTF-8") if login
			agent.set_proxy(server,port.to_i,login,pass)
		end
		agent.get(res[0])
		"Зашел как #{agent_browser} #{server}".print
		if(ar.length>0 && Settings["use_proxy"] == "true")
			server.print
		end
	}

	
	
	if(ar.length>0)
                	i = i+1
	                i %=ar.length
                end
	sleep 1
end
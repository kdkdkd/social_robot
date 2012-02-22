
ar = $db[:proxy].to_a


res = ask("адрес каритнки" => "string", "реферер" => "string")




i = 0
while true
	agent_browser =  (Mechanize::AGENT_ALIASES.keys - ['Mechanize']).sample.dup
	agent = Mechanize.new{ |agent|  agent.user_agent_alias =agent_browser}
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
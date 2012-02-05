require 'mechanize'
class Antigate
	

	def self.solve(captcha_file,key)
		
		agent = Mechanize.new
		f = File.new(captcha_file, "rb")
		res_post_captcha = agent.post('http://antigate.com/in.php', {"key" => key,"file"=>f, "method" => "post", "soft_id" => "360"}).body
		f.close
		if(res_post_captcha =~ /^OK/)
			id = res_post_captcha.split("|").last
			sleep 10
			while true
				res_captcha = agent.get("http://antigate.com/res.php",{"key" => key,"action" => "get", "id" => id}).body
				if(res_captcha =~ /^OK/)
					return res_captcha.split("|").last
				elsif(res_captcha=="CAPCHA_NOT_READY")
					sleep 5
				else
    				raise res_captcha
				end
			end
		else
			raise res_post_captcha 
		end
	end


end
require 'mechanize'
class Antigate
	@@last_captcha_failed_val = nil
	def Antigate.last_captcha_failed=(value)
		@@last_captcha_failed_val=value
	end
	def Antigate.last_captcha_failed
		@@last_captcha_failed_val
	end


	def self.solve(captcha_file,key)
		if(!Antigate.last_captcha_failed.nil? && Time.new - Antigate.last_captcha_failed < 100)
      raise "antigate failed recently. please wait"
    end
		agent = Mechanize.new
		f = File.new(captcha_file, "rb")
		res_post_captcha = agent.post('http://antigate.com/in.php', {"key" => key,"file"=>f, "method" => "post"}).body
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
				elsif (res_captcha=="ERROR_NO_SLOT_AVAILABLE")
					raise res_captcha
				elsif (res_captcha=="ERROR_CAPTCHA_UNSOLVABLE")
					raise res_captcha
				elsif (res_captcha=="ERROR_BAD_DUPLICATES")
					raise res_captcha
        else
          Antigate.last_captcha_failed = Time.now
					raise res_captcha

				end
			end
		else
			raise res_post_captcha 
		end
	end


end
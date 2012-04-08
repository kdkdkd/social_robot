

class UtfToWin
	def initialize
		@converter = {}
		(128..256).each {|c| next if c==152;cp = [c].pack('c*').force_encoding("cp1251"); @converter[cp.encode("UTF-8")] = cp }
	end
	
	def urlencode(str)
		begin
			res = ""
			res.force_encoding("cp1251")
			str.each_char do |k|

        k_as_cp = @converter[k]
		if(k_as_cp)
			k_as_cp = "%" + k_as_cp.bytes.to_a[0].to_s(16)
		else
				k_as_cp = k
		end
         
        res += k_as_cp
      end
		rescue
			res = str
		end
		res		
	end
	
	def encode(str)
		begin
			res = ""
			res.force_encoding("cp1251")
			str.each_char do |k|

        k_as_cp = @converter[k]
        k_as_cp = k unless k_as_cp
        res += k_as_cp
      end
		rescue
			res = str
		end
		res		
	end
end
		

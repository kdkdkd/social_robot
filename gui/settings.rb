require 'nokogiri'

class Settings
	@@doc = nil
	@@file_path = "../../settings/settings.xml"
	
	#Load document once
	def self.load_if_nil
		Settings.reload unless @@doc
	end
	
	def self.reload
		File.open(@@file_path) do |f|
			@@doc = Nokogiri::XML(f)
		end
	end
	
	#Load option value return nil if not present
	def self.[](key)
		load_if_nil
		res = @@doc.xpath("//#{key}")
		return nil if res.length == 0
		return res[0].text
	end
	
	
	#Save document
	def self.save
		File.open(@@file_path, 'w') {|f| f.write(@@doc.to_xml) } if @@doc
	end
	
	#Set value, if nil cleared
	def self.[]=(key,value)
		load_if_nil
		res = @@doc.xpath("//#{key}")[0]
		if value.nil?
			res.remove if res
			return 
		else
			if res
				res.content = value
				return
			end
			new_setting = Nokogiri::XML::Node.new key, @@doc
			new_setting.content = value
			@@doc.xpath("//settings")[0].add_child(new_setting)	
		end
	end
	
end


class Updater
	def last_version
		return @last_version if @last_version
		@last_version = Mechanize.new.get("https://github.com/downloads/kdkdkd/social_robot/version.txt").body
		@last_version
	end
	def current_version
		IO.read("../version.txt")
	end
	def update
		return if current_version == last_version
		new_dir = "../../#{last_version}"
		#Clean old
		FileUtils.rm_rf new_dir if File.exists?(new_dir) && File.directory?(new_dir)
		Dir::mkdir(new_dir)
		current_zip = File.join(new_dir,"current.zip")
		#download
		Mechanize.new.get("https://github.com/downloads/kdkdkd/social_robot/current.zip").save(current_zip)
		rf = File.expand_path("../../")
		#extract
		system("\"#{File.join(rf,"7zip","7za.exe")}\" x \"-o#{File.expand_path(new_dir)}\" \"#{File.expand_path(current_zip)}\"")
		#delete archive
		File.delete(current_zip)
		#Update batch
		File.open("../../SocialRobotConsole.bat","w") do |bat|
			bat<<"cd #{last_version}/gui\n"
			bat<<"\"%~dp0ruby/bin/ruby.exe\" \"%~dp0#{last_version}/gui/gui.rb\"\n"
			bat<<"pause"
		end
		
	end
end
require "./utfto1251.rb"
require "./vk.rb"

include Vkontakte
me = User.login("abbbbbbbbbb@gmail.com","фффффф")
ask_login do
	me
end
progress do |text|
  puts text
end
#puts User.parse("/id165405476").avatar.album



#puts User.login("+380982061671","vovan17111996vovan").balance
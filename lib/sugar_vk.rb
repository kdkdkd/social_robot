#pretty string is used to display different object in nice format
#array extension is used to make constructions like this me.friends.friends.print. This code will output nice formatted html



class Array
  def download(*params)
		self.inject([]){|a,x| a.push(x.download(*params)) if x.respond_to?('download');a}.uniq
	end
	def mark(*params)
		self.each{|x| x.mark(*params) if x.respond_to?('mark')}
	end
	def invite(*params)
		self.each{|x| x.invite(*params) if x.respond_to?('invite')}
	end
	def uninvite(*params)
		self.each{|x| x.uninvite(*params) if x.respond_to?('uninvite')}
	end
	def remove(*params)
		self.each{|x| x.remove(*params) if x.respond_to?('remove')}
	end
	def friends(*params)
		self.inject([]){|a,x| x.friends(*params).each{|f| a.push(f)} if x.respond_to?('friends');a}.uniq
	end
	def wall(*params)
		self.inject([]){|a,x| x.wall(*params).each{|f| a.push(f)} if x.respond_to?('wall');a}.uniq
	end
	def music(*params)
		self.inject([]){|a,x| x.music(*params).each{|m| a.push(m)} if x.respond_to?('music');a}.uniq
	end
	def albums(*params)
		self.inject([]){|a,x| x.albums(*params).each{|m| a.push(m)} if x.respond_to?('albums');a}.uniq
	end
	def photos(*params)
		self.inject([]){|a,x| x.photos(*params).each{|m| a.push(m)} if x.respond_to?('photos');a}.uniq
	end
	def like(*params)
		self.each{|x| x.like(*params) if x.respond_to?('like')}
	end
	def unlike(*params)
		self.each{|x| x.unlike(*params) if x.respond_to?('unlike')}
	end
	def post(*params)
		self.inject([]){|a,x| a.push(x.post(*params)) if x.respond_to?('post');a}.uniq
	end
	def mail(*params)
		self.inject([]){|a,x| a.push(x.mail(*params)) if x.respond_to?('mail');a}.uniq
	end

	def all(search)
		search.force_encoding("UTF-8")
		self.select(){|x| x.to_s.index(search)}
	end
	def one(search)
		search.force_encoding("UTF-8")
		self.find(){|x| x.to_s.index(search)}
	end
	def pretty_string
		res = ""
		b = "["
		b.print_indentation = print_indentation
		res << b.pretty_string << "<br/>"
		self.each_with_index{|xm,i| x = xm;print_indentation_xm = x.print_indentation;x.print_indentation = print_indentation + 1; res << x.pretty_string;  res << "," if i < length - 1  ;res<<"<br/>";x.print_indentation = print_indentation_xm}
		
		b = "]"
		b.print_indentation = print_indentation
		res << b.pretty_string
	end
	
end

class Hash
    
	def pretty_string
		res = ""
		b = "{"
		b.print_indentation = print_indentation
		res << b.pretty_string << "<br/>"
		i = 0
		self.each do |xm,ym|
            x = xm
			y = ym
			print_indentation_xm = x.print_indentation
			print_indentation_ym = y.print_indentation
			
			y.print_indentation = 0;
			
			
			add = ""
			if y.class.name == "Array" || y.class.name == "Hash"
				y.print_indentation = print_indentation + 1
				add = "<br/>"
			end
			y_str = add + y.pretty_string
			
			x.print_indentation = print_indentation + 1
			
			res << x.pretty_string << " => " << y_str
			res << "," if i < length - 1
			res<<"<br/>"
			i+=1
			x.print_indentation = print_indentation_xm
			y.print_indentation = print_indentation_ym
			
			
		end
		
		b = "}"
		b.print_indentation = print_indentation
		res << b.pretty_string
	end
end


module Vkontakte
	class User
		def pretty_string
			res = "<img src = 'images/user.png'/>#{@name.to_s + ((@name)? " (" : "") + "<a href='#{Vkontakte::vkontakte_location}/#{ ((@id.to_s =~ /^\d+$/)? "id":"") + @id}'>#{@id}</a>" + ((@name)? ")" : "") }"
			res.print_indentation = print_indentation
			res.pretty_string
	    end
	end
	class Image
		def pretty_string
			res = "<img src = 'images/photo.png'/>#{album.name.to_s + " (<a href='#{link}'>#{@id}</a>)"}"
			res.print_indentation = print_indentation
			res.pretty_string
	    end
	end
	
	class Album
		def pretty_string
			res = "<img src = 'images/album.png'/>#{name.to_s + " (<a href='#{Vkontakte::vkontakte_location}/album#{user.id}_#{id}'>#{@id}</a>)"}"
			res.print_indentation = print_indentation
			res.pretty_string
	    end
	end
	
end


class Object
	
	def print
		@print_indentation = 0
		log self.pretty_string
	end

	def pretty_string
		("&nbsp;" * (4 * print_indentation)) + self.to_s
	end
	
	def print_indentation=(value)
		@print_indentation = value
	end
	def print_indentation
		@print_indentation || 0
	end
end


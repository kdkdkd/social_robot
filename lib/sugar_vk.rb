class Array
	def download
		self.each{|x| x.download if x.respond_to?('download')}
	end
	def invite(message=nil,connector=nil)
		self.each{|x| x.invite(message,connector) if x.respond_to?('invite')}
	end
	def uninvite(connector=nil)
		self.each{|x| x.uninvite(connector) if x.respond_to?('uninvite')}
	end
	def remove
		self.each{|x| x.remove if x.respond_to?('remove')}
	end
	def friends
		self.inject([]){|a,x| x.friends.each{|f| a.push(f)} if x.respond_to?('friends');a}.uniq
	end
	def wall(offset = 0)
		self.inject([]){|a,x| x.wall(offset).each{|f| a.push(f)} if x.respond_to?('wall');a}.uniq
	end
	def music
		self.inject([]){|a,x| x.music.each{|m| a.push(m)} if x.respond_to?('music');a}.uniq
	end
	def albums
		self.inject([]){|a,x| x.albums.each{|m| a.push(m)} if x.respond_to?('albums');a}.uniq
	end
	def photos
		self.inject([]){|a,x| x.photos.each{|m| a.push(m)} if x.respond_to?('photos');a}.uniq
	end
	def like
		self.each{|x| x.like if x.respond_to?('like')}
	end
	def unlike
		self.each{|x| x.unlike if x.respond_to?('unlike')}
	end
	def post(msg,connector=nil)
		self.inject([]){|a,x| a.push(x.post(msg,connector)) if x.respond_to?('post');a}.uniq
	end
	def mail(message, title = "",connector=nil)
		self.inject([]){|a,x| a.push(x.mail(message,title,connector)) if x.respond_to?('mail');a}.uniq
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
		res << b.pretty_string << "\n"
		self.each_with_index{|xm,i| x = xm.dup;x.print_indentation = print_indentation + 1; res << x.pretty_string;  res << "," if i < length - 1  ;res<<"\n"}
		
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
		res << b.pretty_string << "\n"
		i = 0
		self.each do |xm,ym| 
			x = xm.dup;y = ym.dup
			y.print_indentation = 0;
			x.print_indentation = print_indentation + 1
			
			add = ""
			if y.class.name == "Array" || y.class.name == "Hash"
				y.print_indentation = print_indentation + 1
				add = "\n"
			end
			y_str = add + y.pretty_string
			
			
			res << x.pretty_string << " => " << y_str
			res << "," if i < length - 1
			res<<"\n"
			i+=1
		end
		
		b = "}"
		b.print_indentation = print_indentation
		res << b.pretty_string
	end
end


class Object
	
	def print
		@print_indentation = 0
		log self.pretty_string
	end

	def pretty_string
		(" " * (4 * print_indentation)) + self.to_s
	end
	
	def print_indentation=(value)
		@print_indentation = value
	end
	def print_indentation
		@print_indentation || 0
	end
end


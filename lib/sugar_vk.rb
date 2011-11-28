class Array
	def download
		self.each{|x| x.download if x.respond_to?('download')}
	end
	def remove
		self.each{|x| x.remove if x.respond_to?('remove')}
	end
	def friends
		self.inject([]){|a,x| x.friends.each{|f| a.push(f)} if x.respond_to?('friends');a}.uniq
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


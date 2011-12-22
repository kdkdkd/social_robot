class Array
	def download(*params)
		self.each{|x| x.download(*params) if x.respond_to?('download')}
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


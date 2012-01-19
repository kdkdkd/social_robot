#pretty string is used to display different object in nice format
#array extension is used to make constructions like this me.friends.friends.print. This code will output nice formatted html



class Array
  #download something and display total on progress bar
  def download(*params)
    i = 0
		self.inject([]){|a,x| i+=1; show_progress(i,length) if defined?(show_progress);a.push(x.download(*params)) if x.respond_to?('download');a}.uniq
  end
  #do not display total
  def download_no_progress(*params)
		self.inject([]){|a,x| a.push(x.download(*params)) if x.respond_to?('download');a}.uniq
  end

  def mark(*params)
    i = 0
		self.each{|x| i+=1; show_progress(i,length) if defined?(show_progress);x.mark(*params) if x.respond_to?('mark')}
  end
  #do not display total
	def mark_no_progress(*params)
		self.each{|x| x.mark(*params) if x.respond_to?('mark')}
  end

  def invite(*params)
    i = 0
		self.each{|x| i+=1; show_progress(i,length) if defined?(show_progress); x.invite(*params) if x.respond_to?('invite')}
	end
  #do not display total
	def invite_no_progress(*params)
		self.each{|x| x.invite(*params) if x.respond_to?('invite')}
  end

	def uninvite(*params)
    i = 0
		self.each{|x| i+=1; show_progress(i,length) if defined?(show_progress); x.uninvite(*params) if x.respond_to?('uninvite')}
  end
  #do not display total
  def uninvite_no_progress(*params)
		self.each{|x| x.uninvite(*params) if x.respond_to?('uninvite')}
  end

	def remove(*params)
    i = 0
		self.each{|x| i+=1; show_progress(i,length) if defined?(show_progress); x.remove(*params) if x.respond_to?('remove')}
  end
  #do not display total
  def remove(*params)
		self.each{|x| x.remove(*params) if x.respond_to?('remove')}
  end

	def friends(*params)
		self.inject([]){|a,x| x.friends(*params).each{|f| a.push(f)} if x.respond_to?('friends');a}.uniq
  end
  #display total
  def friends_with_progress(*params)
    i = 0
		self.inject([]){|a,x| i+=1; show_progress(i,length) if defined?(show_progress); x.friends(*params).each{|f| a.push(f)} if x.respond_to?('friends');a}.uniq
  end

  def groups(*params)
		self.inject([]){|a,x| x.groups(*params).each{|f| a.push(f)} if x.respond_to?('groups');a}.uniq
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
    i = 0
		self.each{|x| i+=1; show_progress(i,length) if defined?(show_progress); x.like(*params) if x.respond_to?('like')}
  end
  #do not display total
  def like_no_progress(*params)
		self.each{|x| x.like(*params) if x.respond_to?('like')}
  end


	def unlike(*params)
		self.each{|x| x.unlike(*params) if x.respond_to?('unlike')}
  end

  #do not display total
  def unlike_no_progress(*params)
    i = 0
		self.each{|x| i+=1; show_progress(i,length) if defined?(show_progress); x.unlike(*params) if x.respond_to?('unlike')}
  end

  def post(*params)
		self.inject([]){|a,x| a.push(x.post(*params)) if x.respond_to?('post');a}.uniq
  end
  #do not display total
	def post_no_progress(*params)
    i = 0
		self.inject([]){|a,x| i+=1; show_progress(i,length) if defined?(show_progress); a.push(x.post(*params)) if x.respond_to?('post');a}.uniq
  end

  def mail(*params)
		self.inject([]){|a,x| a.push(x.mail(*params)) if x.respond_to?('mail');a}.uniq
  end
  #do not display total
	def mail_no_progress(*params)
    i = 0
		self.inject([]){|a,x|  i+=1; show_progress(i,length) if defined?(show_progress);a.push(x.mail(*params)) if x.respond_to?('mail');a}.uniq
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
      begin
         x = xm.dup
      rescue
         x = xm
      end
      begin
         y = ym.dup
      rescue
         y = xm
      end

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


  class Group
		def pretty_string
			res = "<img src = 'images/group.png'/>#{@name.to_s + ((@name)? " (" : "") + "<a href='#{Vkontakte::vkontakte_location}/#{ ((@id.to_s =~ /^\d+$/)? "club":"") + @id}'>#{@id}</a>" + ((@name)? ")" : "") }"
			res.print_indentation = print_indentation
			res.pretty_string
	    end
  end

  class Music
		def pretty_string
			res = "<img src = 'images/music.png'/>#{author} - #{name} (<a href='#{link}'>#{@id}</a>)"
			res.print_indentation = print_indentation
			res.pretty_string
	    end
	end
	
	
	class Post
		def pretty_string
		    text_output = text
			text_output = (text.length>20) ? text[0..17] + "..." : text
			
			res = "<img src = 'images/post.png'/> #{text_output}"
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


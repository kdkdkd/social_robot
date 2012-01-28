#pretty string is used to display different object in nice format
#array extension is used to make constructions like this me.friends.friends.print. This code will output nice formatted html



class Array

	#download something and display total on progress bar
	def download(*params)
		i = 0
		self.inject([])	do |a,x| 
			i+=1
			show_progress(i,length) if defined?(show_progress)
			if x.respond_to?('download')
				res_one = safe{ x.download(*params) }
				a.push(res_one) unless res_one.nil?
			end
			a
		end.uniq
	end

	#do not display total
	def download_no_progress(*params)
		self.inject([]) do |a,x| 
			if x.respond_to?('download')
				res_one = safe{ x.download(*params) }
				a.push(res_one) unless res_one.nil? 
			end
			a 
		end.uniq
	end

	def mark(*params)
		i = 0
		self.each do |x| 
			i+=1
			show_progress(i,length) if defined?(show_progress)
			safe{ x.mark(*params) } if x.respond_to?('mark')
		end
	end
	
	#do not display total
	def mark_no_progress(*params)
		self.each{|x| safe{x.mark(*params)} if x.respond_to?('mark')}
	end

	def invite(*params)
		i = 0
		self.each{|x| i+=1; show_progress(i,length) if defined?(show_progress); safe{x.invite(*params)} if x.respond_to?('invite')}
	end
	
	#do not display total
	def invite_no_progress(*params)
		self.each{|x| safe{x.invite(*params)} if x.respond_to?('invite')}
	end

	def uninvite(*params)
		i = 0
		self.each{|x| i+=1; show_progress(i,length) if defined?(show_progress); safe{x.uninvite(*params)} if x.respond_to?('uninvite')}
	end
	
	#do not display total
	def uninvite_no_progress(*params)
		self.each{|x| safe{x.uninvite(*params)} if x.respond_to?('uninvite')}
	end

	def remove(*params)
		i = 0
		self.each{|x| i+=1; show_progress(i,length) if defined?(show_progress); safe{x.remove(*params)} if x.respond_to?('remove')}
	end
	
	#do not display total
	def remove_no_progress(*params)
		self.each{|x| safe{x.remove(*params)} if x.respond_to?('remove')}
	end

	def friends(*params)
		self.inject([]) do |a,x| 
			if x.respond_to?('friends')
				res_friends = safe{x.friends(*params)}
				res_friends.each{|f| a.push(f)} unless res_friends.nil?
			end
			a
		end.uniq
	end
  
	#display total
	def friends_with_progress(*params)
		i = 0
		self.inject([]) do |a,x| 
			i+=1; show_progress(i,length) if defined?(show_progress); 
			if x.respond_to?('friends')
				res_friends = safe{x.friends(*params)}
				res_friends.each{|f| a.push(f)} unless res_friends.nil?
			end
			a
		end.uniq
	end

	def groups(*params)
		self.inject([]) do |a,x| 
			if x.respond_to?('groups')
				res_groups = safe{x.groups(*params)}
				res_groups.each{|f| a.push(f)} unless res_groups.nil?
			end
			a
		end.uniq
	end

	def wall(*params)
		self.inject([]) do |a,x| 
			if x.respond_to?('wall')
				res_wall = safe{x.wall(*params)}
				res_wall.each{|f| a.push(f)} unless res_wall.nil?
			end
			a
		end.uniq
	end
	
	def music(*params)
		self.inject([]) do |a,x| 
			if x.respond_to?('music')
				res_music = safe{x.music(*params)}
				res_music.each{|f| a.push(f)} unless res_music.nil?
			end
			a
		end.uniq
	end

	def albums(*params)
		self.inject([]) do |a,x| 
			if x.respond_to?('albums')
				res_albums = safe{x.albums(*params)}
				res_albums.each{|f| a.push(f)} unless res_albums.nil?
			end
			a
		end.uniq
	end
	
	
	def photos(*params)
		self.inject([]) do |a,x| 
			if x.respond_to?('photos')
				res_photos = safe{x.photos(*params)}
				res_photos.each{|f| a.push(f)} unless res_photos.nil?
			end
			a
		end.uniq
	end

	def like_no_progress(*params)
		i = 0
		self.each{|x| i+=1; show_progress(i,length) if defined?(show_progress); safe{x.like(*params)} if x.respond_to?('like')}
	end
	
	def like(*params)
		self.each{|x| safe{x.like(*params)} if x.respond_to?('like')}
	end


	def unlike_no_progress(*params)
		self.each{|x| safe{x.unlike(*params)} if x.respond_to?('unlike')}
	end

	def unlike(*params)
		i = 0
		self.each{|x| i+=1; show_progress(i,length) if defined?(show_progress); safe{ x.unlike(*params) } if x.respond_to?('unlike')}
	end

	def post_no_progress(*params)
		self.inject([]) do |a,x| 
			if x.respond_to?('post')
				res_post = safe{x.post(*params)}
				a.push(res_post) if res_post
			end
			a
		end.uniq
	end
	

	def post(*params)
		i = 0
		self.inject([]) do |a,x| 
			i+=1
			show_progress(i,length) if defined?(show_progress)
			if x.respond_to?('post')
				res_post = safe{x.post(*params)}
				a.push(res_post) unless res_post.nil?
			end
			a
		end.uniq
	end

	def mail_no_progress(*params)
		self.inject([]) do |a,x| 
			if x.respond_to?('mail')
				res_mail = safe{x.mail(*params)}
				a.push(res_mail) unless res_mail.nil?
			end
			a
		end.uniq
	end
	
	def mail(*params)
		i = 0
		self.inject([]) do |a,x|  
			i+=1
			show_progress(i,length) if defined?(show_progress)
			if x.respond_to?('mail')
				res_mail = safe{x.mail(*params)}
				a.push(res_mail) unless res_mail.nil?
			end
			a
		end.uniq
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
		res = []
		b = "["
		b.print_indentation = print_indentation
		res << b.pretty_string
		self.each_with_index{|xm,i| x = xm;print_indentation_xm = x.print_indentation;x.print_indentation = print_indentation + 1; res << x.pretty_string;  x.print_indentation = print_indentation_xm}
		
		b = "]"
		b.print_indentation = print_indentation
		res << b.pretty_string
	end
	
end

class Hash
    
	def pretty_string
		res = []
		b = "{"
		b.print_indentation = print_indentation
		res << b.pretty_string
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
			
			
			add = false
			if y.class.name == "Array" || y.class.name == "Hash"
				y.print_indentation = print_indentation + 1
				add = true
			end
			y_str = y.pretty_string
			
			x.print_indentation = print_indentation + 1

      all_str =  x.pretty_string + " => "
      all_str += y_str unless(add)
			res << all_str
      res << y_str if add
			#res << "," if i < length - 1
			#res<<"<br/>"
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
			res = "<img src = 'images/photo.png'/>#{album.name.to_s + " (<a href='#{Vkontakte::vkontakte_location}/photo#{album.user.id}_#{id}'>#{@id}</a>)"}"
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
			text_output = (text.length>90) ? text[0..87] + "..." : text
			text_output.gsub!(/\s+/," ")

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


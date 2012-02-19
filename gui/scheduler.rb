
$atom_mutex = Mutex.new




#A simple task like send one mail or post message on wall
class Atom
  attr_accessor :id, :name, :param0,:param1,:param2,:param3,:param4,:param5,:param6,:param7,:param8,:param9, :task_id, :from, :to

  #Set status to waiting or failed
  def failed(error)
    attempts = $db[:atom][:id => id][:attempts]
    if(attempts<3)
      $db[:atom].filter('id = ?', id).update(:state => "waiting" , :attempts => attempts + 1, :error => error)
    else
      $db[:atom].filter('id = ?', id).update(:state => "failed", :error => error)
    end
  end

  #Set status to done
  def done
    $db[:atom].filter('id = ?', id).update(:state => "done")
  end

  #Set status to action
  def action
    $db[:atom].filter('id = ?', id).update(:state => "action")
  end

  #execute self
  def execute()
    #action
	
    user_from = safe{Users.user(from)}
	if(!user_from)
      failed "Не найден пользователь"
    end
	user_to = safe{User.id(to,user_from)}

    if(!user_to)
      failed "Не найден получатель"
    end
   


    case(name)
      when "send_mail" then
        param1 = nil if param1 && param1.length == 0
        param2 = nil if param2 && param2.length == 0
        param3 = nil if param3 && param3.length == 0
		"Шлю сообщение от #{from} к #{user_to}".print
        safe{user_to.mail(param0,param1,param2,param3,param4,user_from)}
		
        #"#{from} #{to}".print
        done
		return
    end
    failed "Не найдено действие"
  end

  def initialize(id_set)
    @id = id_set
    item = $db[:atom][:id => @id]
    @name = item[:name]
    @param0 = item[:param0]
    @param1 = item[:param1]
    @param2 = item[:param2]
    @param3 = item[:param3]
    @param4 = item[:param4]
    @param5 = item[:param5]
    @param6 = item[:param6]
    @param7 = item[:param7]
    @param8 = item[:param8]
    @param9 = item[:param9]
    @task_id = item[:task_id]
    @from = item[:from]
    @to = item[:to]
  end

  
  #Allowed atoms in that moment
  @@cache = []
  
  #Last time search shows empty values
  @@last_time_was_empty = nil
  
  def Atom.next()
		
			not_ready_to_search = false
			
				if(@@last_time_was_empty && Time.now - @@last_time_was_empty < 3)
					not_ready_to_search = true
				end
			
			
			return nil if(not_ready_to_search)
			
			res = nil
			
			
				res = @@cache.sample
				if(res)
					@@cache.delete(res)
					res = Atom.new(res[:id])
				end
			
			
			return res if res
			
			
			waiting = $db[:atom].filter(:state => "waiting").to_a



			
			#Remove all, that don't have access
			user_list = Users.user_list
			waiting = waiting.find_all{|w| user_list.find{|u| u[0] == w[:from] && u[2]}}
			if(waiting.length == 0)
				@@last_time_was_empty = Time.now
			end
			
			
			#Remove all, that action takes place
			action = $db[:atom].filter(:state => "action").to_a
			waiting = waiting.find_all{|w| action.find{|a| a[:from] == w[:from]}.nil?}
			#If can't login now, remove all that should be login
			if(Vkontakte::last_user_login && Time.new - Vkontakte::last_user_login < Vkontakte::user_login_interval)
			   waiting = waiting.find_all{|w| Users.user_cache.find{|u| u.email == w[:from]}}
			else
			   first = true
			   waiting = waiting.find_all do |w|
				 res = Users.user_cache.find{|u| u.email == w[:from]}
				 #Filter all, that doesn't reach timeout
				 if(!res && first)
				  first = false
				  res = true
				 end
				 res
			   end
			end

			#filtering which are not ready to act
			waiting.find_all do |w|
			  res = Users.user_cache.find{|u| u.email == w[:from]}
			  res_bool = true
			  if(res)
				if(w[:name] == "send_mail")
				  res_bool = !(res.connect.last_user_mail && (Time.new - res.connect.last_user_mail<Vkontakte::mail_interval))
				end
			  end
			  res_bool
			end


			#If action can't be done yet

			waiting.uniq! {|s| s[:from]}
			
			
			
			
			
			res = nil
			 
				@@cache = waiting
				res = @@cache.sample
				if(res)
					@@cache.delete(res)
					res = Atom.new(res[:id])
				end
			
			return res
		
		


		

  end
  
  
  @@workers = []
  
  def Atom.create_workers
    $logger.info "CREATE"
	25.times{
		thread = Thread.new do
			while true
			
				
				atom = nil
				$atom_mutex.synchronize{ 
					atom = Atom.next()
					if atom
						atom.action 
					end
				}
				
				
				if(atom)
					Thread.current["id"] = atom.task_id + 10000
					"Выполняю задание #{atom.id}".print
					begin
						atom.execute
					rescue Exception => e
						e.message.print
					end
				end
				sleep 0.5
				
			end	
		end
		thread.priority = -2
		@@workers<<thread
	}
  
  end


end


$mutex_task_database = Mutex.new 
#A bundle of tasks, like send message to all friends, all subtasks are atoms and stored in database
class TaskDatabase
  attr_accessor :id

  def initialize(id_new)
    @id = id_new
  end

  @@cache = []
  
  def TaskDatabase.insert_cache(var)
	
	$mutex_task_database.synchronize{ 
		@@cache<<var
	}
  end  
  
  def TaskDatabase.flush
	$mutex_task_database.synchronize{ 
		$db[:atom].import([:name,:from,:to,:param0,:param1,:param2,:param3,:param4,:param5,:param6,:param7,:param8,:param9,:attempts,:state,:task_id,:error], @@cache) if @@cache.length>0
		@@cache = []
	}
  end

  #schedule mail send
  def mail(message, from=nil, to=nil, attach_photo = nil, attach_video = nil, attach_music = nil, title = "")
    TaskDatabase.insert_cache(["send_mail",from,to,message,attach_photo.to_s,attach_video.to_s,attach_music.to_s,title.to_s,nil,nil,nil,nil,nil,0,"waiting",@id,nil])
    
  end
end


$mutex_users = Mutex.new


#A class, that holds all task, and all necessary to execute them
class Users

  #list of users - array of type User
  @@users = []

  #if all users already was fetched
  @@users_all = false


  #is fetching is performed right now, used for multithreading
  @@fetching = false

  def Users.add_user(user)
	$mutex_users.synchronize{
		@@users << user
	}
  end

  #Find one user by email or login
  def Users.user(email)
    unless email
      return Users.users.sample
    end
    res = nil
	$mutex_users.synchronize{
		res = @@users.find{|u|u.email == email}
		if res
			return res
		end
	}
    res = nil
    
	res = Users.user_list.find{|u| u[0] == email}
    
    unless res
      return nil
    end
	"Вход : #{email}".print
    u = safe{User.login(res[0],res[1],hash)}
			if u
			$mutex_users.synchronize{
				@@users.push(u)
			}
  			"Зашел #{res[0]}".print
        return u
			else
				"Не зашел #{res[0]}".print
        res[2] = false
        return nil
		end
  end

  #Find list of users
  def Users.user_list
    user_list = []
		$db[:account].each{|acc| user_list.push([acc[:email],acc[:password],true])}
		user_list.uniq!{|a|a[0]}
    user_list
  end

  def Users.user_cache
	$mutex_users.synchronize{
     @@users
     }
  end

  #Login to all users in multi account
  def Users.users
	res = nil
	$mutex_users.synchronize{
		res = @@users if(@@users_all)
	}
	return res if res
    users = []
		user_logins = []
		user_list.each do |user|
      next if user.nil?
			hash = $db[:account][:email => user[0]][:hash]
			u = safe{User.login(user[0],user[1],hash)}
			if u
   			users.push(u)
  			"Зашел #{user[0]}".print
        yield u
			else
				"Не зашел #{user[0]}".print
			end

    end
	$mutex_users.synchronize{
		@@users = users
	}
    users
  end
end

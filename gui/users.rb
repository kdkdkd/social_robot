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

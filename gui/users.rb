$mutex_users = Mutex.new
$mutex_bad = Mutex.new

#A class, that holds all task, and all necessary to execute them
class Users

  #list of users - array of type User
  @@users = []

  #user with login failed
  @@bad_list = []

  def Users.add_user(user)
	$mutex_users.synchronize{
		@@users << user
	}
  end

  def Users.user_cache
    $mutex_users.synchronize{
      @@users
    }
  end

  def Users.bad?(email)
    $mutex_bad.synchronize{
      !@@bad_list.index(email).nil?
    }
  end

  def Users.bad(email)
    $mutex_bad.synchronize{
      @@bad_list<<email
    }
  end



  #Find one user by email or login
  def Users.user(email)
    return nil if Users.bad?(email)
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
    u = safe{User.login(res[0],res[1])}
			if u
        Users.add_user(u)
  			"Зашел #{res[0]}".print
        return u
      else
        Users.bad(res[0])
				"Не зашел #{res[0]}".print

        return nil
		end
  end

  #Find list of users
  def Users.user_list
    user_list = []
		$db[:account].each{|acc| user_list.push([acc[:email],acc[:password]])}
		user_list.uniq!{|a|a[0]}
    user_list
  end



  #Login to all users in multi account
  def Users.users
	  res = nil

    users = []
		user_logins = []
		user_list.each do |user|
      next if user.nil?
			#hash = $db[:account][:email => user[0]][:hash]
      found_user = nil
      $mutex_users.synchronize{
        found_user = @@users.find{|u|u.email == user[0]}

      }
      was_login = false
      if(found_user)
        u = found_user
      else
        unless(Users.bad?(user[0]))
          was_login = true
          u = safe{User.login(user[0],user[1])}
          Users.bad(user[0]) unless u
        end

      end



			if u
   			users.push(u)
  			"Зашел #{user[0]}".print if was_login
        do_stop = yield(u)

         Users.add_user(u) if was_login
         break if do_stop == "STOP"
			else
				"Не зашел #{user[0]}".print if was_login
			end

    end

    users
  end
end

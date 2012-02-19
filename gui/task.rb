
#A task, which is not preserved.
#Usually this task is just marks what work should be done and creates TaskDatabase
class Task
  attr_accessor :id, :name, :state, :date_started, :progress_current, :progress_total, :progress_text, :tab

  @@id = 0

  def Task.id
    @@id
  end
  
  def progress_total_database
     $db[:atom].join_table(:inner, :task, :id=>:task_id).filter(:task_id=>id - 10000).count
  end

  def progress_current_database
     
  
     $db[:atom].join_table(:inner, :task, :id=>id - 10000).filter(:task_id=>id - 10000,:state => ["done","failed"]).count
	
  end

  def initialize(name, tab)
    @name = name
    @state = "action"
    @date_started = Time.now
    @progress_current = 0
    @progress_total = nil
    @progress_text = "Запуск..."
    @task_database = nil
    @id = @@id
	@tab = tab
    @@id += 1
  end

  
  #all tasks in the system. Array of Task class.
  @@prepare_tasks = []


  def Task.add_task(new_task)
    @@prepare_tasks<<new_task
  end


  def Task.all_tasks
    @@prepare_tasks
  end
  
  #find task by id
  def Task.find_id(id)
    @@prepare_tasks.find{|t|t.id.to_s == id.to_s}
  end
  
  #remove task by id
  def Task.remove(id)
    @@prepare_tasks.delete_if {|t|t.id.to_s == id.to_s}
  end


  
end

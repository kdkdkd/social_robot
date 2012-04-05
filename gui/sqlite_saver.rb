class SqliteSaver
  def initialize
    @mutex = Mutex.new
    @add_to_history = []
    Thread.new do
      while true
        @mutex.synchronize{
          if(@add_to_history.length>0)
            $db[:history_item].import([:object_id, :history_list_id], @add_to_history)
            @add_to_history = []
          end
        }
        sleep 1
      end
    end
  end

  def add_to_history(object_id,history_list_id)
    @mutex.synchronize{
      @add_to_history.push([object_id,history_list_id])
    }
  end



end
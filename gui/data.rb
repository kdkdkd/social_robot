require "sequel"

Sequel::Model.plugin :force_encoding, 'UTF-8'


class RobotDatabase

	@@maximum_migration = 7
	
	def initialize(database_name)
		@db = Sequel.connect(:adapter=>'sqlite', :database =>database_name, :timeout=>99999999)
		migration_present = @db["SELECT * FROM sqlite_master WHERE type='table'"].map(:tbl_name).include?("migration")
		unless migration_present
			@db.create_table(:migration) do
				primary_key :id
			end
			@db[:migration].insert(:id => 1)
		end
	end
	
	def db
		@db
	end
	
	def update()
		migration_table_first = @db[:migration].first
		((migration_table_first[:id] + 1) .. @@maximum_migration).each{|migration_number|migrate(migration_number)}
		@db[:migration].update(:id => @@maximum_migration)
	end
	
	def migrate(index)
		case(index)
			when 2 then
				@db.create_table(:proxy) do
					String :server
					String :port
					String :login
					String :password
					String :active
				end
			when 3 then
				@db.create_table(:account) do
					String :email
					String :password
					String :hash
					String :name
        end

      when 4 then
				@db.create_table(:task) do
					primary_key :id
					String :name, :text=>true
					String :date
          Integer :priority
        end

      when 5 then
				@db.create_table(:atom) do
					primary_key :id
					String :name
          String :from
          String :to
          String :param0, :text=>true
          String :param1, :text=>true
          String :param2, :text=>true
          String :param3, :text=>true
          String :param4, :text=>true
          String :param5, :text=>true
          String :param6, :text=>true
          String :param7, :text=>true
          String :param8, :text=>true
          String :param9, :text=>true
          Integer :attempts
          String :state
          Integer :task_id
          String :error, :text=>true
        end

        when 6 then
				@db.create_table(:list) do
					primary_key :id
					String :name, :text=>true
        end
        @db.create_table(:user) do
          String :id
					String :name
          Integer :list_id
        end

      when 7 then
        @db.create_table(:history_list) do
          primary_key :id
          String :name, :text=>true
          String :date
          Integer :list_id
        end
        @db.create_table(:history_item) do
          primary_key :id
          String :object_id
          Integer :history_list_id
        end
        @db.alter_table(:list) do
          add_column :visible, Integer, :default=>1
        end


	    end
	end

end

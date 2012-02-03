require "sequel"

Sequel::Model.plugin :force_encoding, 'UTF-8'


class RobotDatabase

	@@maximum_migration = 3
	
	def initialize(database_name)
		@db = Sequel.sqlite(database_name)
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
		end
	
	end

end

worker_processes 2
timeout 60
preload_app true

before_fork do |_server, _worker|
  ActiveRecord::Base.connection.disconnect! if defined? ActiveRecord::Base
end

after_fork do |_server, _worker|
  ActiveRecord::Base.establish_connection if defined? ActiveRecord::Base
end

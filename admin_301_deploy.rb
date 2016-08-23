namespace :rion do
  DINING_ENV = ENV['DINING_ENV']
  APP_NAME = ENV['APP_NAME']
  BASE_DIR = ENV['BASE_DIR']
  SHELL_DIR = ENV['SHELL_DIR']
  RELEASE_DIR = ENV['RELEASE_DIR']
  NFS_BACKUP_DIR = ENV['NFS_BACKUP_DIR']
  BUILD_DIR = ENV['BUILD_DIR']

  task :echo_env do
    run_locally do
      info "#{DINING_ENV}"
      info "#{APP_NAME}"
      info "#{BASE_DIR}"
      info "#{SHELL_DIR}"
      info "#{RELEASE_DIR}"
      info "#{NFS_BACKUP_DIR}"
      info "#{BUILD_DIR}"
    end
  end
  
  task :deploy do
    invoke "rion:make_release_dir"
    invoke "rion:upload_release_item"
    invoke "rion:stop_tomcat"
    invoke "rion:release"
    invoke "rion:start_tomcat"
    invoke "rion:check_released_dir"
  end
  
  task :make_release_dir do
    on roles(:web_server) do |host|
      execute(:ls, "-la", "#{BASE_DIR}")
      execute(:mkdir, "-p", "#{NFS_BACKUP_DIR}")
      execute(:ls, "-la", "#{RELEASE_DIR}")
    end
  end
  
  task :upload_release_item do
    on roles(:web_server) do |host|
      upload! "#{BUILD_DIR}admin.war", "#{NFS_BACKUP_DIR}"
    end
  end
  
  task :stop_tomcat do
    on roles(:web_server) do |host|
      execute("/etc/init.d/_tomcat-dining-admin01 stop")
      sleep 5 #停止待ち
    end
  end
    
  task :release do
    on roles(:web_server) do |host|
      execute(:rm,  "-rf", "#{RELEASE_DIR}admin")
      execute(:ln,  "-snf", "#{NFS_BACKUP_DIR}admin.war", "#{RELEASE_DIR}")
    end
  end
  
  task :start_tomcat do
    on roles(:web_server) do |host|
      execute("/etc/init.d/_tomcat-dining-admin01 start")
      sleep 5 #起動待ち
    end
  end
  
  task :check_released_dir do
    on roles(:web_server) do |host|
      sleep 5 #warの展開が早すぎるので少し待つ
      execute(:ls, "-la", "#{RELEASE_DIR}admin")
    end
  end
end

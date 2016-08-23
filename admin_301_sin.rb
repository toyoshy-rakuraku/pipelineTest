namespace :sin301 do
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
  
  task :sin do
    invoke "sin301:change_sin"
    invoke "sin301:start_nekokan"
  end
  
  task :change_sin do
    on roles(:web_server) do |host|
      execute(:ls, "/usr/local/apache/vhosts/admin.dining.intra-tool.rakuten.co.jp/htdocs/wwwcheck.jsp.bk")
      execute(:mv, "/usr/local/apache/vhosts/admin.dining.intra-tool.rakuten.co.jp/htdocs/wwwcheck.jsp.bk /usr/local/apache/vhosts/admin.dining.intra-tool.rakuten.co.jp/htdocs/wwwcheck.jsp")
      
    end
  end

  task :start_nekokan do
    on roles(:web_server) do |host|
      execute("/usr/local/rms/jerry_com/tool/nekokan/bin/nekokan.sh start")
      sleep 5 #起動待ち
    end
  end
  
end

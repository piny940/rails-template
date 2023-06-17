# rootパスのディレクトリを指定
rails_root = File.expand_path('../../', __FILE__)

# アプリケーションサーバの性能を決定する
worker_processes 2

# 追記に記載してます。入れた方がいいです。
ENV['BUNDLE_GEMFILE'] = rails_root + "/Gemfile"

# アプリケーションの設置されているディレクトリを指定
working_directory rails_root.to_s

# プロセスの停止などに必要なPIDファイルの保存先を指定。
pid File.expand_path('../../tmp/pids/unicorn.pid', __FILE__)

# ポート番号を指定
# listen '/var/www/rails_template/shared/tmp/sockets/unicorn.sock'
listen 8080

# Unicornのエラーログと通常ログの位置を指定。
stderr_path File.expand_path('../../log/unicorn_stderr.log', __FILE__)
stdout_path File.expand_path('../../log/unicorn_stdout.log', __FILE__)

# 応答時間を待つ上限時間を設定
timeout 30

# ダウンタイムなしでUnicornを再起動時する
preload_app true

GC.respond_to?(:copy_on_write_friendly=) && GC.copy_on_write_friendly = true

check_client_connection false

run_once = true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.connection.disconnect!

  if run_once
    run_once = false # prevent from firing again
  end

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH => e
      logger.error e
    end
  end
end

after_fork do |_server, _worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end

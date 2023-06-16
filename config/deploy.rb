# config valid for current version and patch releases of Capistrano
lock '~> 3.17.3'

set :application, 'rails_template'
set :repo_url, 'git@github.com:piny940/rails-template.git'
set :branch, 'main'

# sharedディレクトリに入れるファイルを指定
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads'

# secrets.ymlをsharedに入れる設定
append :linked_files, "config/database.yml"
set :linked_files, fetch(:linked_files, []).push('config/secrets.yml')

# SSH接続設定
set :ssh_options, {
  auth_methods: ['publickey'],
  keys: ['~/.ssh/kagoya'],
  verify_host_key: :never
}

# 保存しておく世代の設定
set :keep_releases, 5

# rbenvの設定
set :rbenv_type, :user
set :rbenv_ruby, '3.1.2'
set :optional_env_vars, %w[RAILS_TEMPLATE_DATABASE_PASSWORD BUNDLE_GEMFILE REDIS_URL RAILS_MAX_THREADS TEST_PG_USER TEST_PG_PASSWORD TEST_PG_HOST MY_APP_DATABASE_URL RAILS_MASTER_KEY RAILS_SERVE_STATIC_FILES RAILS_LOG_TO_STDOUT CI GOOGLE_APPLICATION_CREDENTIALS RAILS_MIN_THREADS RAILS_ENV PORT PIDFILE WEB_CONCURRENCY]

# Postgresql
set :pg_without_sudo, false
set :pg_host, 'db.piny940.com'
set :pg_database, 'rails_template_production'
set :pg_username, 'rails_template'
# set :pg_generate_random_password, true
# set :pg_ask_for_password, true
set :pg_generate_random_password, true
set :pg_extensions, %w[citext hstore]
set :pg_encoding, 'UTF-8'
set :pg_pool, '100'

# Dotenv
invoke 'dotenv:read'
invoke 'dotenv:check'
invoke 'dotenv:setup'

# ここからUnicornの設定
# Unicornのプロセスの指定
set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }

# Unicornの設定ファイルの指定
set :unicorn_config_path, -> { "#{current_path}/config/unicorn.rb" }

# Unicornを再起動するための記述
after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end

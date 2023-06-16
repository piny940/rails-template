# config valid for current version and patch releases of Capistrano
lock '~> 3.17.3'

set :application, 'rails_template'
set :repo_url, 'git@github.com:piny940/rails-template.git'
set :branch, 'main'

# sharedディレクトリに入れるファイルを指定
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads'

# secrets.ymlをsharedに入れる設定
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

# Dotenv
invoke 'dotenv:read'
invoke 'dotenv:check'
invoke 'dotenv:setup'
set :env_file, ".env.#{stage}"

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

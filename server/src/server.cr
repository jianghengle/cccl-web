require "mysql"
require "crecto"
require "kemal"
require "json"
require "crypto/bcrypt/password"

require "./http/models/*"
require "./http/errors/*"
require "./http/controllers/*"
require "./http/middleware/*"

module Repo
  extend Crecto::Repo

  config do |conf|
    conf.adapter = Crecto::Adapters::Mysql
    conf.uri = ENV["DB_URL"]
  end
end

Query = Crecto::Repo::Query

module MyServer
  class Server
    def initialize
      # Middlewares
      add_handler MyServer::HttpAPI::ApiHandler.new

      get "/" do |env|
        env.redirect "/index.html"
      end

      post "/get_auth_token" do |env|
        HttpAPI::UserController.get_auth_token(env)
      end

      post "/get_block_by_name" do |env|
        HttpAPI::BlockController.get_block_by_name(env)
      end

      post "/update_block" do |env|
        HttpAPI::BlockController.update_block(env)
      end

      post "/delete_block" do |env|
        HttpAPI::BlockController.delete_block(env)
      end

      post "/add_schedule_block" do |env|
        HttpAPI::BlockController.add_schedule_block(env)
      end

      post "/add_blog_block" do |env|
        HttpAPI::BlockController.add_blog_block(env)
      end

      get "/get_schedule_blocks" do |env|
        HttpAPI::BlockController.get_schedule_blocks(env)
      end

      get "/get_blog_blocks" do |env|
        HttpAPI::BlockController.get_blog_blocks(env)
      end

      get "/get_recent_schedule_blocks" do |env|
        HttpAPI::BlockController.get_recent_schedule_blocks(env)
      end

      get "/get_block/:id" do |env|
        HttpAPI::BlockController.get_block(env)
      end

      post "/get_files" do |env|
        HttpAPI::FileController.get_files(env)
      end

      get "/get_file/:id" do |env|
        HttpAPI::FileController.get_file(env)
      end

      post "/create_file" do |env|
        HttpAPI::FileController.create_file(env)
      end

      post "/update_file/:id" do |env|
        HttpAPI::FileController.update_file(env)
      end

      post "/delete_file" do |env|
        HttpAPI::FileController.delete_file(env)
      end

      post "/create_directory" do |env|
        HttpAPI::FileController.create_directory(env)
      end

      post "/delete_directory" do |env|
        HttpAPI::FileController.delete_directory(env)
      end

      get "/get_directories" do |env|
        HttpAPI::FileController.get_directories(env)
      end

      post "/move_file" do |env|
        HttpAPI::FileController.move_file(env)
      end

      get "/get_home_files" do |env|
        HttpAPI::FileController.get_home_files(env)
      end

      get "/get_all_menus" do |env|
        HttpAPI::MenuController.get_all_menus(env)
      end

      post "/create_menu" do |env|
        HttpAPI::MenuController.create_menu(env)
      end

      post "/update_menu" do |env|
        HttpAPI::MenuController.update_menu(env)
      end

      post "/delete_menu" do |env|
        HttpAPI::MenuController.delete_menu(env)
      end

      serve_static({"gzip" => true, "dir_listing" => true})

      port = 3000
      port = ENV["CCCL_PORT"].to_i if ENV.has_key?("CCCL_PORT")
      Kemal.run port
    end
  end
end

MyServer::Server.new

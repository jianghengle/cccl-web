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

      get "/get_schedule_blocks" do |env|
        HttpAPI::BlockController.get_schedule_blocks(env)
      end

      get "/get_recent_schedule_blocks" do |env|
        HttpAPI::BlockController.get_recent_schedule_blocks(env)
      end

      serve_static({"gzip" => true, "dir_listing" => true})

      Kemal.run
    end
  end
end

MyServer::Server.new
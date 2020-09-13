require "mysql"
require "crecto-admin"

module Repo
  extend Crecto::Repo
  config do |conf|
    conf.adapter = Crecto::Adapters::Mysql
    conf.uri = ENV["DB_URL"]
  end
end

class User < Crecto::Model
  schema "users" do
    field :username, String
    field :encrypted_password, String
    field :auth_token, String
    field :role, String
  end

  def self.collection_attributes
    return [:username, :role, :created_at, :updated_at]
  end

  def self.form_attributes
    [{:username, "string"},
     {:encrypted_password, "password"},
     {:auth_token, "string"},
     {:role, "enum", ["Normal", "Admin"]}]
  end

  def self.can_access(user)
    return false unless user.is_a? User
    user.role.to_s == "Admin"
  end
end

class Block < Crecto::Model
  schema "blocks" do
    field :category, String
    field :name, String
    field :time, Time
    field :content, String
    field :color, String
  end

  def self.collection_attributes
    return [:category, :name, :time, :created_at, :updated_at]
  end

  def self.form_attributes
    [{:category, "enum", ["Normal", "Schedule", "Blog", "Page"]},
     {:name, "string"},
     :time,
     {:content, "text"},
     {:color, "string"}]
  end

  def self.can_access(user)
    return false unless user.is_a? User
    user.role.to_s == "Admin"
  end
end

class MyFile < Crecto::Model
  schema "files" do
    field :name, String
    field :file_type, String
    field :url, String
    field :info, String
    field :path, String
  end

  def self.can_access(user)
    return false unless user.is_a? User
    user.role.to_s == "Admin"
  end
end

class Menu < Crecto::Model
  schema "menus" do
    field :name, String
    field :parent_id, Int32
    field :menu_index, Int32
    field :link, String
    field :block_id, Int32
  end

  def self.collection_attributes
    return [:name, :parent_id, :menu_index, :created_at, :updated_at]
  end

  def self.form_attributes
    [{:name, "string"},
     :parent_id,
     :menu_index,
     {:link, "string"},
     :block_id]
  end

  def self.can_access(user)
    return false unless user.is_a? User
    user.role.to_s == "Admin"
  end
end

CrectoAdmin.config do |config|
  config.auth_enabled = true
  config.auth = CrectoAdmin::DatabaseAuth
  config.auth_repo = Repo
  config.auth_model = User
  config.auth_model_identifier = :username
  config.auth_model_password = :encrypted_password
  config.app_name = "CCCL Admin"
end

init_admin()

admin_resource(User, Repo)
admin_resource(Block, Repo)
admin_resource(MyFile, Repo)
admin_resource(Menu, Repo)

Kemal::Session.config do |config|
  config.secret = "sTHxjX3R"
  config.secret = ENV["ADMIN_SECRET"] if ENV.has_key?("ADMIN_SECRET")
end

Kemal.run 3001

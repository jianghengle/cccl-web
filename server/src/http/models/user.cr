module MyServer
  module HttpAPI
    class User < Crecto::Model
      schema "users" do
        field :username, String
        field :encrypted_password, String
        field :auth_token, String
        field :role, String
      end

      def to_json
        String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"username\":" << @username.to_json << ","
          str << "\"role\":" << @privileges.to_json << ","
          str << "\"createdTime\":" << @created_at.as(Time).to_unix
          str << "}"
        end
      end

      def self.get_user(username : String, password : String)
        user = Repo.get_by(User, username: username)
        raise "Cannot find user" if user.nil?
        raise "Cannot verify password" unless Crypto::Bcrypt::Password.new(user.encrypted_password.not_nil!) == password
        user
      end

      def self.get_user_by_token(token : String)
        user = Repo.get_by(User, auth_token: token)
        raise "Cannot find user" if user.nil?
        user
      end
    end
  end
end

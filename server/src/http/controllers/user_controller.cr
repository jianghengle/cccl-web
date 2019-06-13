require "./controller_base"

module MyServer
  module HttpAPI
    module UserController
      include MyServer::HttpAPI::ControllerBase
      extend self

      def get_auth_token(ctx)
        begin
          username = get_param!(ctx, "username")
          password = get_param!(ctx, "password")

          user = User.get_user(username, password)
          token = user.auth_token.to_s

          {token: token}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end
    end
  end
end

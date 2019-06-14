require "./controller_base"

module MyServer
  module HttpAPI
    module BlockController
      include MyServer::HttpAPI::ControllerBase
      extend self

      def get_block_by_name(ctx)
        begin
          name = get_param!(ctx, "name")
          block = Block.get_by_name(name)
          block.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def update_block(ctx)
        begin
          user = verify_token(ctx)

          id = get_param!(ctx, "id").to_i
          name = get_param!(ctx, "name")
          time = get_param!(ctx, "time").to_i
          content = get_param!(ctx, "content")
          p content

          Block.update(id, name, time, content)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end
    end
  end
end

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

      def get_schedule_blocks(ctx)
        begin
          blocks = Block.get_schedule_blocks
          "[" + (blocks.join(", ") { |i| i.to_json }) + "]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def get_block(ctx)
        begin
          id = get_param!(ctx, "id").to_i
          block = Block.get(id)
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
          color = get_param!(ctx, "color")

          Block.update(id, name, time, content, color)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def delete_block(ctx)
        begin
          user = verify_token(ctx)

          id = get_param!(ctx, "id").to_i

          Block.delete(id)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def add_schedule_block(ctx)
        begin
          user = verify_token(ctx)

          name = get_param!(ctx, "name")
          time = get_param!(ctx, "time").to_i
          content = get_param!(ctx, "content")
          color = get_param!(ctx, "color")

          block = Block.create("Schedule", name, time, content, color)
          block.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def get_recent_schedule_blocks(ctx)
        begin
          blocks = Block.get_recent_schedule_blocks
          "[" + (blocks.join(", ") { |i| i.to_json }) + "]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def add_blog_block(ctx)
        begin
          user = verify_token(ctx)

          name = get_param!(ctx, "name")
          time = get_param!(ctx, "time").to_i
          content = get_param!(ctx, "content")
          color = get_param!(ctx, "color")

          block = Block.create("Blog", name, time, content, color)
          block.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def get_blog_blocks(ctx)
        begin
          blocks = Block.get_blog_blocks
          "[" + (blocks.join(", ") { |i| i.to_json }) + "]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end
    end
  end
end

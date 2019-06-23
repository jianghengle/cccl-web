require "./controller_base"

module MyServer
  module HttpAPI
    module FileController
      include MyServer::HttpAPI::ControllerBase
      extend self

      def get_files(ctx)
        begin
          path = get_param!(ctx, "path")
          items = MyFile.get_files(path)
          arr = [] of String
          "[" + (items.join(", ") { |i| i.to_json }) + "]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def get_home_files(ctx)
        begin
          items = MyFile.get_home_files
          arr = [] of String
          "[" + (items.join(", ") { |i| i.to_json }) + "]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def get_file(ctx)
        begin
          id = get_param!(ctx, "id").to_i
          file = MyFile.get_file(id)
          file.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def create_file(ctx)
        begin
          user = verify_token(ctx)

          MyFile.create_file(ctx)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def update_file(ctx)
        begin
          user = verify_token(ctx)

          id = get_param!(ctx, "id").to_i
          file = MyFile.get_file(id)
          file.info = get_param!(ctx, "info")
          file.file_type = get_param!(ctx, "fileType")

          MyFile.update_file(file)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def delete_file(ctx)
        begin
          user = verify_token(ctx)

          file_id = get_param!(ctx, "fileId").to_i
          MyFile.delete_file(file_id)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def create_directory(ctx)
        begin
          user = verify_token(ctx)
          path = get_param!(ctx, "path")
          name = get_param!(ctx, "name")
          MyFile.create_directory(path, name)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def delete_directory(ctx)
        begin
          user = verify_token(ctx)
          path = get_param!(ctx, "path")
          MyFile.delete_directory(path)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def get_directories(ctx)
        begin
          directories = MyFile.get_directories
          "[" + (directories.join(", ") { |i| i.to_json }) + "]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def move_file(ctx)
        begin
          user = verify_token(ctx)

          file_id = get_param!(ctx, "fileId").to_i
          move_to = get_param!(ctx, "moveTo")
          MyFile.move_file(file_id, move_to)
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

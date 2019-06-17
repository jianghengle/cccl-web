module MyServer
  module HttpAPI
    class MyFile < Crecto::Model
      schema "files" do
        field :name, String
        field :file_type, String
        field :url, String
        field :info, String
      end

      def to_json
        result = String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"name\":" << @name.to_json << ","
          str << "\"fileType\":" << @file_type.to_json << ","
          str << "\"url\":" << @url.to_json << ","
          str << "\"info\":" << @info.to_json
          str << "}"
        end
        result
      end

      def self.get_files
        items = Repo.all(MyFile)
        return items.as(Array) unless items.nil?
        [] of MyFile
      end

      def self.get_file(id)
        file = Repo.get(MyFile, id)
        raise "cannot find file" if file.nil?
        file.as(MyFile)
      end

      def self.create_file(env)
        upload_file = "Yes"
        file = MyFile.new
        HTTP::FormData.parse(env.request) do |part|
          if part.name == "uploadFile"
            upload_file = part.body.gets_to_end
          elsif part.name == "name"
            file.name = part.body.gets_to_end
          elsif part.name == "fileType"
            file.file_type = part.body.gets_to_end
          elsif part.name == "url"
            file.url = part.body.gets_to_end
          elsif part.name == "info"
            file.info = part.body.gets_to_end
          elsif part.name == "file"
            if upload_file == "Yes"
              raise "No static dir setup" unless ENV.has_key?("CCCL_STATIC")
              data_dir = File.join(ENV["CCCL_STATIC"], file.file_type.to_s + "s")

              filename = part.filename
              raise "No filename included in upload" unless filename.is_a?(String)

              unique_name = MyFile.get_unique_filename(data_dir, filename)
              target_path = File.join(data_dir, unique_name)
              File.open(target_path, "w") do |f|
                IO.copy(part.body, f)
              end

              file.name = unique_name
              file.url = "/" + file.file_type.to_s + "s/" + unique_name
            end
          end
        end

        changeset = Repo.insert(file)
        raise changeset.errors.to_s unless changeset.valid?
      end

      def self.get_unique_filename(path, filename)
        ext = File.extname(filename)
        name = filename[0, (filename.size - ext.size)]
        new_name = filename
        i = 0
        while File.exists?(File.join(path, new_name))
          i = i + 1
          new_name = name + "_" + i.to_s + ext
        end
        new_name
      end

      def self.update_file(file)
        changeset = Repo.update(file)
        raise changeset.errors.to_s unless changeset.valid?
      end

      def self.delete_file(file_id)
        file = Repo.get!(MyFile, file_id)
        changeset = Repo.delete(file)
        raise changeset.errors.to_s unless changeset.valid?

        if (file.url.to_s.starts_with?("/"))
          raise "No static dir setup" unless ENV.has_key?("CCCL_STATIC")
          full_path = File.join(ENV["CCCL_STATIC"], file.url.to_s)
          if File.exists?(full_path)
            File.delete(full_path)
          end
        end
      end
    end
  end
end

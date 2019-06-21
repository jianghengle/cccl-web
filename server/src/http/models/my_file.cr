module MyServer
  module HttpAPI
    class MyFile < Crecto::Model
      schema "files" do
        field :name, String
        field :file_type, String
        field :url, String
        field :info, String
        field :path, String
      end

      def to_json
        result = String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"name\":" << @name.to_json << ","
          str << "\"fileType\":" << @file_type.to_json << ","
          str << "\"url\":" << @url.to_json << ","
          str << "\"path\":" << @path.to_json << ","
          str << "\"info\":" << @info.to_json
          str << "}"
        end
        result
      end

      def self.get_files(path)
        if path.empty?
          query = Query.where(path: nil)
        else
          query = Query.where(path: path)
        end
        items = Repo.all(MyFile, query)
        return items.as(Array) unless items.nil?
        [] of MyFile
      end

      def self.get_directories
        query = Query.where(file_type: "Directory")
        items = Repo.all(MyFile, query)
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
          elsif part.name == "path"
            path = part.body.gets_to_end
            file.path = path unless path.empty?
          elsif part.name == "fileType"
            file.file_type = part.body.gets_to_end
          elsif part.name == "url"
            file.url = part.body.gets_to_end
          elsif part.name == "info"
            file.info = part.body.gets_to_end
          elsif part.name == "file"
            if upload_file == "Yes"
              raise "No static dir setup" unless ENV.has_key?("CCCL_STATIC")
              path = ""
              path = file.path.to_s unless file.path.nil?
              data_dir = File.join(ENV["CCCL_STATIC"], path)

              filename = part.filename
              raise "No filename included in upload" unless filename.is_a?(String)

              unique_name = MyFile.get_unique_filename(data_dir, filename)
              target_path = File.join(data_dir, unique_name)
              File.open(target_path, "w") do |f|
                IO.copy(part.body, f)
              end

              file.name = unique_name
              file.url = "/" + File.join(path, unique_name)
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

      def self.move_file(file_id, move_to)
        file = Repo.get!(MyFile, file_id)

        raise "No static dir setup" unless ENV.has_key?("CCCL_STATIC")
        if file.path.nil?
          source_full_path = File.join(ENV["CCCL_STATIC"], file.name.to_s)
        else
          source_full_path = File.join(ENV["CCCL_STATIC"], file.path.to_s, file.name.to_s)
        end

        if (move_to == "/")
          target_path = ENV["CCCL_STATIC"]
          file.path = nil
        else
          target_path = File.join(ENV["CCCL_STATIC"], move_to)
          file.path = move_to.lchop
        end

        if (file.url.to_s.starts_with?("/"))
          MyFile.copy_file(source_full_path, target_path)
          File.delete(source_full_path)
          file.url = "/" + File.join(file.path.to_s, file.name.to_s)
        end

        changeset = Repo.update(file)
        raise changeset.errors.to_s unless changeset.valid?
      end

      def self.create_directory(path, name)
        raise "No static dir setup" unless ENV.has_key?("CCCL_STATIC")
        full_path = File.join(ENV["CCCL_STATIC"], path, name)
        Dir.mkdir(full_path)

        directory = MyFile.new
        directory.name = name
        directory.file_type = "Directory"
        directory.path = path unless path.empty?

        changeset = Repo.insert(directory)
        raise changeset.errors.to_s unless changeset.valid?
      end

      def self.delete_directory(path)
        return if path.empty?

        name = File.basename(path)
        parent_path = File.dirname(path)
        if parent_path == "."
          query = Query.where(name: name).where(file_type: "Directory").where(path: nil)
        else
          query = Query.where(name: name).where(file_type: "Directory").where(path: parent_path)
        end
        directory = Repo.get_by(MyFile, query).as(MyFile)
        Repo.delete(directory)

        query = Query.where("path LIKE '#{path}%'")
        Repo.delete_all(MyFile, query)

        raise "No static dir setup" unless ENV.has_key?("CCCL_STATIC")
        full_path = File.join(ENV["CCCL_STATIC"], path)
        MyFile.delete_files(full_path)
      end

      def self.delete_files(path)
        return unless File.exists?(path)
        if File.file?(path)
          File.delete(path)
        else
          Dir.each path do |filename|
            if filename.to_s != "." && filename.to_s != ".."
              p = path + "/" + filename
              MyFile.delete_files(p)
            end
          end
          Dir.rmdir(path)
        end
      end

      def self.copy_file(source_full_path, target_path)
        filename = File.basename(source_full_path)
        new_full_path = File.join(target_path, filename)
        File.open(new_full_path, "w", 0o660) do |tf|
          File.open(source_full_path) do |sf|
            IO.copy(sf, tf)
          end
        end
      end
    end
  end
end

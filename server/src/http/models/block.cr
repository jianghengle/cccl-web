module MyServer
  module HttpAPI
    class Block < Crecto::Model
      schema "blocks" do
        field :category, String
        field :name, String
        field :time, Time
        field :content, String
      end

      def to_json
        String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"category\":" << @category.to_json << ","
          str << "\"name\":" << @name.to_json << ","
          str << "\"time\":" << @time.as(Time).to_unix << ","
          str << "\"content\":" << @content.to_json
          str << "}"
        end
      end

      def self.get_by_name(name : String)
        block = Repo.get_by(Block, name: name, category: "Normal")
        raise "Cannot find block" if block.nil?
        block
      end

      def self.update(id, name, time, content)
        block = Repo.get(Block, id)
        raise "Cannot find block" if block.nil?

        block.name = name
        block.content = content
        block.time = Time.unix(time)
        changeset = Repo.update(block)
        raise changeset.errors.to_s unless changeset.valid?
      end
    end
  end
end

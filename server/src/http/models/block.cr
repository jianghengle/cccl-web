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
        block = Repo.get_by(Block, name: name)
        raise "Cannot find block" if block.nil?
        block
      end
    end
  end
end

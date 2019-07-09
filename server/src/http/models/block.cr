module MyServer
  module HttpAPI
    class Block < Crecto::Model
      schema "blocks" do
        field :category, String
        field :name, String
        field :time, Time
        field :content, String
        field :color, String
      end

      def to_json
        String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"category\":" << @category.to_json << ","
          str << "\"name\":" << @name.to_json << ","
          str << "\"time\":" << @time.as(Time).to_unix << ","
          str << "\"color\":" << @color.to_json << ","
          str << "\"content\":" << @content.to_json
          str << "}"
        end
      end

      def self.get_by_name(name : String)
        block = Repo.get_by(Block, name: name, category: "Normal")
        raise "Cannot find block" if block.nil?
        block
      end

      def self.get(id)
        block = Repo.get(Block, id)
        raise "cannot find block" if block.nil?
        block.as(Block)
      end

      def self.get_schedule_blocks
        query = Query.where(category: "Schedule")
        blocks = Repo.all(Block, query)
        return blocks.as(Array) unless blocks.nil?
        [] of Block
      end

      def self.get_blog_blocks
        query = Query.where(category: "Blog")
        blocks = Repo.all(Block, query)
        return blocks.as(Array) unless blocks.nil?
        [] of Block
      end

      def self.get_recent_schedule_blocks
        query = Query.where(category: "Schedule")
        blocks = Repo.all(Block, query)
        return [] of Block if blocks.nil?
        blocks = blocks.as(Array)

        now = Time.utc_now
        blocks.select do |b|
          span = b.time.as(Time) - now
          span.total_days > -0.5 && span.total_days < 7
        end
      end

      def self.update(id, name, time, content, color)
        block = Repo.get(Block, id)
        raise "Cannot find block" if block.nil?

        block.name = name
        block.content = content
        block.time = Time.unix(time)
        block.color = color
        changeset = Repo.update(block)
        raise changeset.errors.to_s unless changeset.valid?
      end

      def self.delete(id)
        block = Repo.get(Block, id)
        raise "Cannot find block" if block.nil?
        raise "Cannot delete normal block" if block.category.to_s == "Normal"
        changeset = Repo.delete(block)
        raise changeset.errors.to_s unless changeset.valid?
      end

      def self.create(category, name, time, content, color)
        block = Block.new
        block.category = category
        block.name = name
        block.content = content
        block.time = Time.unix(time)
        block.color = color

        changeset = Repo.insert(block)
        raise changeset.errors.to_s unless changeset.valid?
        changeset.changes.each do |change|
          if (change.has_key?(:id))
            block.id = change[:id].as(Int32)
          end
        end
        block
      end
    end
  end
end

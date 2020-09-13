module MyServer
   module HttpAPI
      class Menu < Crecto::Model
         schema "menus" do
            field :name, String
            field :parent_id, Int32
            field :menu_index, Int32
            field :link, String
            field :block_id, Int32
         end
   
         def to_json
            String.build do |str|
               str << "{"
               str << "\"id\":" << @id << ","
               str << "\"name\":" << @name.to_json << ","
               str << "\"parentId\":" << @parent_id.to_json << ","
               str << "\"menuIndex\":" << @menu_index.to_json << ","
               str << "\"link\":" << @link.to_json << ","
               str << "\"blockId\":" << @block_id.to_json
               str << "}"
            end
         end

         def self.get(id)
            menu = Repo.get(Menu, id)
            raise "cannot find menu" if menu.nil?
            menu.as(Menu)
          end

         def self.get_all_menus_json
            all_menus = Menu.get_all_menus
            return "[]" if all_menus.empty?
            groups = Menu.group_menus(all_menus)
            groups_str = groups.map do |group|
               "[" + group.join(", ") { |i| i.to_json } + "]"
            end
            "[" + groups_str.join(", ") + "]"
         end

         def self.group_menus(menus)
            parents_map = {} of String => Array(Menu)
            children_map = {} of String => Array(Menu)
            menus.each do |menu|
               parent_id = menu.parent_id
               if parent_id.nil?
                  parents_map[menu.id.to_s] = [menu]
               else
                  children_map[parent_id.to_s] = [] of Menu unless children_map.has_key? parent_id.to_s
                  children_map[parent_id.to_s] << menu
               end
            end
            parents_map.each do |parent_id, group|
               if children_map.has_key? parent_id
                  children = children_map[parent_id].sort { |a, b| a.menu_index.as(Int32) <=> b.menu_index.as(Int32) }
                  group.concat(children)
               end
            end
            parents_map.values.sort { |a, b| a[0].menu_index.as(Int32) <=> b[0].menu_index.as(Int32) }
         end

         def self.get_all_menus
            query = Query.new
            all_menus = Repo.all(Menu, query)
            return all_menus.as(Array) unless all_menus.nil?
            [] of Menu
         end

         def self.create_menu(parent_id, name, menu_index, url)
            block = Block.create("Page", name, 0, "", nil)

            menu = Menu.new
            menu.parent_id = parent_id
            menu.name = name
            menu.menu_index = menu_index
            menu.link = url
            menu.block_id = block.id.as(Int32)

            changeset = Repo.insert(menu)
            raise changeset.errors.to_s unless changeset.valid?
            
            menu
         end

         def self.update_menu(id, name, menu_index, url)
            menu = Menu.get(id)
            menu.name = name
            menu.name = name
            menu.menu_index = menu_index
            menu.link = url

            changeset = Repo.update(menu)
            raise changeset.errors.to_s unless changeset.valid?

            menu
         end

         def self.delete_menu(id)
            menu = Menu.get(id)
            if menu.parent_id.nil?
               sub_menus = Menu.get_sub_menus(menu)
               sub_menus.each do |sub_menu|
                  Menu.delete_menu_and_block(sub_menu)
               end
            end
            Menu.delete_menu_and_block(menu)
         end

         def self.get_sub_menus(menu)
            query = Query.where(parent_id: menu.id.as(Int32))
            sub_menus = Repo.all(Menu, query)
            return sub_menus.as(Array) unless sub_menus.nil?
            [] of Menu
         end

         def self.delete_menu_and_block(menu)
            unless menu.block_id.nil?
               query = Query.where(id: menu.block_id.as(Int32))
               Repo.delete_all(Block, query)
            end
            Repo.delete(menu)
         end
     end
   end
 end
 
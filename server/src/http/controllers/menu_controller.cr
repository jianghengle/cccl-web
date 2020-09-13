require "./controller_base"

module MyServer
  module HttpAPI
      module MenuController
         include MyServer::HttpAPI::ControllerBase
         extend self

         def get_all_menus(ctx)
            begin
               Menu.get_all_menus_json
            rescue ex : InsufficientParameters
               error(ctx, "Not all required parameters were present")
            rescue e : Exception
               error(ctx, e.message.to_s)
            end
         end

         
         def create_menu(ctx)
            begin
               user = verify_token(ctx)

               parent_id_param = get_param(ctx, "parentId")
               if parent_id_param.nil?
                  parent_id = nil 
               else
                  parent_id = parent_id_param.to_i {nil}
               end

               name = get_param!(ctx, "name")
               menu_index = get_param!(ctx, "menuIndex").to_i
               url = get_param!(ctx, "url")

               Menu.create_menu(parent_id, name, menu_index, url)
               {ok: true}.to_json
            rescue ex : InsufficientParameters
               error(ctx, "Not all required parameters were present")
            rescue e : Exception
               error(ctx, e.message.to_s)
            end
         end

         def update_menu(ctx)
            begin
               user = verify_token(ctx)

               id = get_param!(ctx, "id").to_i
               name = get_param!(ctx, "name")
               menu_index = get_param!(ctx, "menuIndex").to_i
               url = get_param!(ctx, "url")

               Menu.update_menu(id, name, menu_index, url)
               {ok: true}.to_json
            rescue ex : InsufficientParameters
               error(ctx, "Not all required parameters were present")
            rescue e : Exception
               error(ctx, e.message.to_s)
            end
         end

         def delete_menu(ctx)
            begin
               user = verify_token(ctx)
               id = get_param!(ctx, "id").to_i
               Menu.delete_menu(id)
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

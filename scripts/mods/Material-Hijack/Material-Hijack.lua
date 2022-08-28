local mod = get_mod("Material-Hijack")

-- Your mod code goes here.
-- https://vmf-docs.verminti.de



local dict = { --this table is just for debugging 
    texture_map_c0ba2942 = "textures/default_col",
    texture_map_59cd86b9 = "textures/default_normal",
    texture_map_0205ba86 = "textures/default_packed",
    texture_map_71d74d4d = "textures/default_emis",
    texture_map_ee282ea2 = "textures/default_emis",
    texture_map_4617b8e0 = "textures/default_emis",
} 

--this function is depricated
local function check_unit_slots(material, slot_name, texture_path, unit)
    if slot_name == nil or texture_path == nil then 
        -- mod:error("Slot "..tostring(slot_name).." not found in "..tostring(unit).." or texture path is "..tostring(texture_path)) 
        local j = nil --for personal debug printing
    -- elseif texture_path == nil then
    --     print("|    |"..slot_name.."|    |"..tostring(dict[slot_name]))
    --     Material.set_texture(material, slot_name, dict[slot_name])
    else
        -- print("|    |"..slot_name.."|    |"..texture_path)
        Material.set_texture(material, slot_name, texture_path)
    end
end

local function replace_textures(unit)
    if Unit.has_data(unit, "mat_to_use") then
        local mat_slots = {}
        local colors = {}
        local normals = {}
        local MABs = {}
        local emis_colors = {}
        local emis_details = {}

        local mat = Unit.get_data(unit, "mat_to_use")
        local package_to_use = mat
        if Unit.has_data(unit, "mat_package") then
            package_to_use = Unit.get_data(unit, "mat_package")
        end
        Managers.package:load(package_to_use, "global")

        local count = 1
        while Unit.get_data(unit, "mat_slots", "slot"..tostring(count)) do 
            mat_slots[count] = Unit.get_data(unit, "mat_slots", "slot"..tostring(count))
            count = count + 1
        end

        -- mod:echo(count)

        local num_mats = count - 1
        local dict = {}
        for i=1, num_mats, 1 do
            colors[i] = "textures/default_col"
            normals[i] = "textures/T_Texture_NR"
            MABs[i] = "textures/T_Texture_MOS"
            emis_colors[i] = "textures/default_emis"
            emis_details[i] = "textures/default_emis"

            
            dict[mat_slots[i]] = {}
            -- if Unit.has_data(unit, "mat_slots", "slot"..tostring(i)) then 
            --     mat_slots[i] = Unit.get_data(unit, "mat_slots", "slot"..tostring(i))
            -- end
            if Unit.has_data(unit, "colors", "slot"..tostring(i)) then 
                colors[i] = Unit.get_data(unit, "colors", "slot"..tostring(i))
                dict[mat_slots[i]]['color_slot'] = Unit.get_data(unit, "colors", "slot"..tostring(i))
                -- mod:echo("slot"..tostring(i)..":    "..tostring(colors[i]))
            else
                dict[mat_slots[i]]['color_slot'] = colors[i]
            end
            if Unit.has_data(unit, "normals", "slot"..tostring(i)) then --normals is normal with roughness in the alpha channel
                normals[i] = Unit.get_data(unit, "normals", "slot"..tostring(i))     
                dict[mat_slots[i]]['norm_slot'] = Unit.get_data(unit, "normals", "slot"..tostring(i))
            else
                dict[mat_slots[i]]['norm_slot'] = normals[i]
            end
            if Unit.has_data(unit, "MABs", "slot"..tostring(i)) then --MABs is metal, ambient occlussion, and subsurface scattering(sss); should be called "packed textures"
                MABs[i] = Unit.get_data(unit, "MABs", "slot"..tostring(i))   
                dict[mat_slots[i]]['MAB_slot'] = Unit.get_data(unit, "MABs", "slot"..tostring(i))
            else
                dict[mat_slots[i]]['MAB_slot'] = MABs[i]
            end
            if Unit.has_data(unit, "emis_colors", "slot"..tostring(i)) then --controls the color/patterns of the emmissive map but not the overall shape of the map
                emis_colors[i] = Unit.get_data(unit, "emis_colors", "slot"..tostring(i))  
                dict[mat_slots[i]]['emis_col_slot'] = Unit.get_data(unit, "emis_colors", "slot"..tostring(i))          
            end
            if Unit.has_data(unit, "emis_details", "slot"..tostring(i)) then --not sure what this does actually as it doesn't seem to affect the emmissive map
                emis_details[i] = Unit.get_data(unit, "emis_details", "slot"..tostring(i))    
                dict[mat_slots[i]]['emis_det_slot'] = Unit.get_data(unit, "emis_details", "slot"..tostring(i))      
            end
        end



        -- local color_slot = Unit.get_data(unit, "color_slot")
        -- local norm_slot = Unit.get_data(unit, "norm_slot")
        -- local MAB_slot = Unit.get_data(unit, "MAB_slot")
        -- local emis_col_slot = Unit.get_data(unit, "emis_col_slot")
        -- local emis_det_slot = Unit.get_data(unit, "emis_det_slot")
        -- local num_meshes = Unit.num_meshes(unit)
        -- for index, mat_slot in pairs(mat_slots) do 
        --     Unit.set_material(unit, mat_slot, mat)
        --     -- print(mat_slot)
        --     -- print(index)
        --     for i = 0, num_meshes - 1, 1 do
        --         local mesh = Unit.mesh(unit, i)
        --         local num_mats = Mesh.num_materials(mesh)
        --         for j = 0, num_mats - 1, 1 do
        --             local mat = Mesh.material(mesh, j)
        --             -- print(mat)
        --             check_unit_slots(mat, color_slot, colors[j+1], unit)
        --             mod:echo(tostring(mat_slot)..":   "..tostring(colors[j+1]))
        --             check_unit_slots(mat, norm_slot, normals[j+1], unit)
        --             check_unit_slots(mat, MAB_slot, MABs[j+1], unit)
        --             check_unit_slots(mat, emis_col_slot, emis_colors[j+1], unit)
        --             check_unit_slots(mat, emis_det_slot, emis_details[j+1], unit)
        --         end
        --     end
        -- end


        for mat_slot, texture in pairs(dict) do 
            Unit.set_material(unit, mat_slot, mat)
            local num_meshes = Unit.num_meshes(unit)
            -- mod:echo(tostring(mat_slot).." : "..tostring(texture))
            for i = 0, num_meshes - 1, 1 do
                local mesh = Unit.mesh(unit, i)
                local num_mats = Mesh.num_materials(mesh)
                for j = 0, num_mats - 1, 1 do
                    if Mesh.has_material(mesh, mat_slot) then
                        local mater = Mesh.material(mesh, mat_slot)
                        for text_slot, map in pairs(texture) do
                            -- mod:echo(tostring(text_slot)..":     "..tostring(map))
                            Material.set_texture(mater, Unit.get_data(unit, text_slot), map)                            
                            -- mod:echo(tostring(unit).." : "..tostring(text_slot).." : "..tostring(map))
                        end
                    end
                end
            end
        end

    end
    if Unit.has_data(unit, "mat_list") then
        local num_mats = Unit.get_data(unit, "num_mats")

        for i=1, num_mats do 
            local mat_slot = Unit.get_data(unit, "mat_slots", "slot"..tostring(i))
            local mat = Unit.get_data(unit, "mat_list", "slot"..tostring(i))
            -- print(mat)
            -- print(mat_slot)
            -- Managers.package:load(mat, "global")
            Unit.set_material(unit, mat_slot, mat)
        end
    end
end

--these hooks cover the spawning of all unit types that are not local/client only game objects
mod:hook(GearUtils, "create_equipment", --this hook is probably reduntant with the spawn_local_unit hook
function(func, world, slot_name, item_data, unit_1p, unit_3p, is_bot, unit_template, extra_extension_data, ammo_percent, override_item_template, override_item_units)
    replace_textures(unit_1p)
    replace_textures(unit_3p)
    return func(world, slot_name, item_data, unit_1p, unit_3p, is_bot, unit_template, extra_extension_data, ammo_percent, override_item_template, override_item_units)
end)

-- mod:hook(UnitSpawner, 'create_unit_extensions', function (func, self, world, unit, unit_template_name, extension_init_data)
--     replace_textures(unit)
--     -- local bones = Unit.bones(unit)
--     -- if bones then
--     --     for k,v in pairs(bones) do 
--     --         print('"'..tostring(v)..'",')
--     --     end
--     -- end
--     return func(self, world, unit, unit_template_name, extension_init_data)
-- end)

mod:hook(UnitSpawner, 'spawn_local_unit', function (func, self, unit_name, position, rotation, material)
    local unit = World.spawn_unit(self.world, unit_name, position, rotation, material)
	local unit_unique_id = self.unit_unique_id
	self.unit_unique_id = unit_unique_id + 1

	Unit.set_data(unit, "unique_id", unit_unique_id)
	Unit.set_data(unit, "unit_name", unit_name)

	POSITION_LOOKUP[unit] = Unit.world_position(unit, 0)
    replace_textures(unit)
	return unit
end)


mod:hook(HeroPreviewer, '_spawn_item_unit', function (func, self, unit, item_slot_type, item_template, unit_attachment_node_linking, scene_graph_links, material_settings)
    replace_textures(unit)
    return func(self, unit, item_slot_type, item_template, unit_attachment_node_linking, scene_graph_links, material_settings)
end)

-- mod:hook(ScriptUnit,'extension', function (func, unit, system_name)
--     replace_textures(unit)
--     return func(unit, system_name)
-- end)

local function spawn_package_to_player (package_name)
	local player = Managers.player:local_player()
	local world = Managers.world:world("level_world")
  
	if world and player and player.player_unit then
	  local player_unit = player.player_unit
  
	  local position = Unit.local_position(player_unit, 0) + Vector3(0, 0, 1)
	  local rotation = Unit.local_rotation(player_unit, 0)
	  local unit = World.spawn_unit(world, package_name, position, rotation)
  
	  mod:chat_broadcast(#NetworkLookup.inventory_packages + 1)
	  return unit
	end
  
	return nil
end
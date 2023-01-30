local mod = get_mod("Material-Hijack")

mod:dofile("scripts/mods/Material-Hijack/anim_texture_extension")

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

local function replace_textures(unit)
    if Unit.has_data(unit, "mat_to_use") then
        local mat_slots = {}
        local colors = {}
        local normals = {}
        local MABs = {}
        local emis_colors = {}
        local emis_details = {}

        --if material and package resource do not share the same path this will load the package if the package path is provided
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
            
            --use "clean" textures maps for each slot in case no texture is provided by a unit
            colors[i] = "textures/default_col"
            normals[i] = "textures/T_Texture_NR"
            MABs[i] = "textures/T_Texture_MOS"
            emis_colors[i] = "textures/default_emis"
            emis_details[i] = "textures/default_emis"

            
            dict[mat_slots[i]] = {}

            if Unit.has_data(unit, "colors", "slot"..tostring(i)) then 
                colors[i] = Unit.get_data(unit, "colors", "slot"..tostring(i))
                dict[mat_slots[i]]['color_slot'] = Unit.get_data(unit, "colors", "slot"..tostring(i))
            else
                dict[mat_slots[i]]['color_slot'] = colors[i]
            end
            if Unit.has_data(unit, "normals", "slot"..tostring(i)) then --normals is normal with roughness in the alpha channel
                normals[i] = Unit.get_data(unit, "normals", "slot"..tostring(i))     
                dict[mat_slots[i]]['norm_slot'] = Unit.get_data(unit, "normals", "slot"..tostring(i)) or "texture_map"
            else
                dict[mat_slots[i]]['norm_slot'] = normals[i]
            end
            if Unit.has_data(unit, "MABs", "slot"..tostring(i)) then --MABs is metal, ambient occlussion, and subsurface scattering(sss); should be called "packed textures"
                MABs[i] = Unit.get_data(unit, "MABs", "slot"..tostring(i))   
                dict[mat_slots[i]]['MAB_slot'] = Unit.get_data(unit, "MABs", "slot"..tostring(i)) or "texture_map"
            else
                dict[mat_slots[i]]['MAB_slot'] = MABs[i]
            end
            if Unit.has_data(unit, "emis_colors", "slot"..tostring(i)) then --controls the color/patterns of the emmissive map but not the overall shape of the map
                emis_colors[i] = Unit.get_data(unit, "emis_colors", "slot"..tostring(i))  
                dict[mat_slots[i]]['emis_col_slot'] = Unit.get_data(unit, "emis_colors", "slot"..tostring(i)) or "texture_map"      
            end
            if Unit.has_data(unit, "emis_details", "slot"..tostring(i)) then --not sure what this does actually as it doesn't seem to affect the emmissive map
                emis_details[i] = Unit.get_data(unit, "emis_details", "slot"..tostring(i))    
                dict[mat_slots[i]]['emis_det_slot'] = Unit.get_data(unit, "emis_details", "slot"..tostring(i)) or "texture_map"    
            end
        end

        for mat_slot, texture in pairs(dict) do 
            Unit.set_material(unit, mat_slot, mat)
            local num_meshes = Unit.num_meshes(unit)
            for i = 0, num_meshes - 1, 1 do
                local mesh = Unit.mesh(unit, i)
                local num_mats = Mesh.num_materials(mesh)
                for j = 0, num_mats - 1, 1 do
                    if Mesh.has_material(mesh, mat_slot) then
                        local mater = Mesh.material(mesh, mat_slot)
                        for text_slot, map in pairs(texture) do
                            local tex_name = Unit.get_data(unit, text_slot) or "texture_map"
                            Material.set_texture(mater, tex_name, map)
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
            Unit.set_material(unit, mat_slot, mat)
        end
    end
end


local function add_particles(unit, world)

    if Unit.has_data(unit, "particles") then

        local node_part_pairs = Unit.get_data(unit, "particles", "node_part_pairs")

        for i=1, node_part_pairs, 1 do
            local pacakge = Unit.get_data(unit, "particles", "node_map",tostring(i),"package")
            if pacakge then
                Managers.package:load(pacakge, "global")
            end

            local fx = Unit.get_data(unit, "particles",tostring(i),"fx")
            local node = Unit.get_data(unit, "particles",tostring(i),"node")

            local translation_rotation = Matrix4x4.identity()
            if Unit.has_data(unit, "particles",tostring(i),"offset") then
                local x = Unit.get_data(unit, "particles",tostring(i),"offset", "x")
                local y = Unit.get_data(unit, "particles",tostring(i),"offset", "y")
                local z = Unit.get_data(unit, "particles",tostring(i),"offset", "z")

                Matrix4x4.set_element(translation_rotation, 4, 1, x)
                Matrix4x4.set_element(translation_rotation, 4, 2, y)
                Matrix4x4.set_element(translation_rotation, 4, 3, z)

            end

            local particle_id = World.create_particles(world, fx, Vector3(0,0,0))
            World.link_particles(world, particle_id, unit, node, translation_rotation,"destroy")
            Unit.set_data(unit, "has_linked_particles", particle_id)
        end
    end
end

mod:hook(Unit, "set_unit_visibility", function(func, unit, visibility)
    local world = Unit.world(unit)
    if Unit.get_data(unit, "inactive_particles") then
        if visibility then
            add_particles(unit, world)
            Unit.set_data(unit, "inactive_particles", false)
        end
    end
    if Unit.has_data(unit, "has_linked_particles") then
        
        if not visibility then 
            World.destroy_particles ( world, Unit.get_data(unit, "has_linked_particles") )
            Unit.set_data(unit, "inactive_particles", true)
        end
    end

    
    return func(unit, visibility)
end)

mod:hook(Unit, "set_visibility", function(func, unit, group, visibility)
    local world = Unit.world(unit)
    if Unit.get_data(unit, "inactive_particles") then
        if visibility then
            add_particles(unit, world)
            Unit.set_data(unit, "inactive_particles", false)
        end
    end
    if Unit.has_data(unit, "has_linked_particles") then

        if not visibility then 
            World.destroy_particles ( world, Unit.get_data(unit, "has_linked_particles") )
            Unit.set_data(unit, "inactive_particles", true)
        end
    end

    
    return func(unit, group, visibility)
end)


mod:hook(Unit, "set_mesh_visibility", function(func, unit, mesh, visibility, context)
    local world = Unit.world(unit)
    if Unit.get_data(unit, "inactive_particles") then
        if visibility then
            add_particles(unit, world)
            Unit.set_data(unit, "inactive_particles", false)
        end
    end
    if Unit.has_data(unit, "has_linked_particles") then
        
        if not visibility then 
            World.destroy_particles ( world, Unit.get_data(unit, "has_linked_particles") )
            Unit.set_data(unit, "inactive_particles", true)
        end
    end

    
    return func(unit, mesh, visibility, context)
end)

--these hooks cover the spawning of all unit types that are not local/client only game objects
mod:hook(GearUtils, "create_equipment", --this hook is probably reduntant with the spawn_local_unit hook
function(func, world, slot_name, item_data, unit_1p, unit_3p, is_bot, unit_template, extra_extension_data, ammo_percent, override_item_template, override_item_units)
    replace_textures(unit_1p)
    replace_textures(unit_3p)
    add_particles(unit_1p, world)
    add_particles(unit_3p, world)
    -- AnimTextureExtension:new(unit_1p)
    -- AnimTextureExtension:new(unit_3p)
    return func(world, slot_name, item_data, unit_1p, unit_3p, is_bot, unit_template, extra_extension_data, ammo_percent, override_item_template, override_item_units)
end)

mod:hook(UnitSpawner, 'spawn_local_unit', function (func, self, unit_name, position, rotation, material)
    local unit = World.spawn_unit(self.world, unit_name, position, rotation, material)
	local unit_unique_id = self.unit_unique_id
	self.unit_unique_id = unit_unique_id + 1

	Unit.set_data(unit, "unique_id", unit_unique_id)
	Unit.set_data(unit, "unit_name", unit_name)
    mod:echo(unit_name)

	POSITION_LOOKUP[unit] = Unit.world_position(unit, 0)
    replace_textures(unit)
    add_particles(unit, self.world)
    local new = AnimTextureExtension:new(unit)
    if new.unit_time then
        mod.texture_animations[unit] = new
    end
	return unit
end)


mod:hook(HeroPreviewer, '_spawn_item_unit', function (func, self, unit, item_slot_type, item_template, unit_attachment_node_linking, scene_graph_links, material_settings)
    replace_textures(unit)
    add_particles(unit, self.world)
    local new = AnimTextureExtension:new(unit)
    if new.unit_time then
        mod.texture_animations[unit] = new
    end
    return func(self, unit, item_slot_type, item_template, unit_attachment_node_linking, scene_graph_links, material_settings)
end)

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


mod.texture_animations = {}
mod.update = function(dt)
    for unit, object in pairs(mod.texture_animations) do
        object:update(dt, unit)
    end
end
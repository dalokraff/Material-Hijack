# Material-Hijack
This mod is ment as a modding utility for Vermintide 2; adding in a few lua hooks to make loading custom units and their textures easier. Instead of having to define a material file and have the proper shader nodes/files when building your own mod bundle with [VMB](https://github.com/Vermintide-Mod-Framework/Vermintide-Mod-Builder), this mod will let you choose an in game material to apply to your custom unit and then replace that material's texture maps with your own. 

[Steamworkshop Page](https://steamcommunity.com/sharedfiles/filedetails/?id=2771980886)


## Using the Mod
To enable this mod's functionality on your custom unit, you will need to include several keys in your custom unit's data table. You can define a unit's data table by placing such a table in the corresponding unit's `.unit` file. Below you can see how the data block for the `.unit` file on one of the shields in [Loremaster's Armoury](https://github.com/dalokraff/Loremasters-Armoury/blob/main/units/Kerillian_elf_shield/Kerillian_elf_shield_heroClean_mesh_Eataine01.unit) is defined.
##### Example Data Block
```
data = [
    mat_slots = {
        slot1 = "handle",
        slot2 = "shield"
    }

    mat_to_use = "units/weapons/player/wpn_empire_handgun_02_t2/wpn_empire_handgun_02_t2"

    colors = {
        slot1 = "textures/Kerillian_elf_shield_heroClean_Saphery01/Kerillian_elf_shield_handle_diffuse"
        slot2 =  "textures/Kerillian_elf_shield_heroClean_Eataine01/Kerillian_elf_shield_heroClean_Eataine01_diffuse"
    }
    normals = {
        slot1 = "textures/elf_shield/Handle/Kerillian_elf_shield_handle_normal"
        slot2 = "textures/elf_shield/Shield/Kerillian_elf_shield_heroClean_normal"
    }
    MABs = {
        slot1 = "textures/elf_shield/Handle/Kerillian_elf_shield_handle_combined"
        slot2 = "textures/elf_shield/Shield/Kerillian_elf_shield_heroClean_combined"
    }

    color_slot = "texture_map_c0ba2942" 
    norm_slot = "texture_map_59cd86b9"
    MAB_slot = "texture_map_0205ba86"
]
```
- The `mat_slots` table refers to the name of the material objects(slots) on the included FBX file for the unit. This FBX happens to have two materials attached to it called, `handle` and `shield`.

- The `mat_to_use` key refers to the in game material file you plan on "hijacking" and `color_slot`, `norm_slot`, and `MAB_slot` keys refer to the name of the texture map on the hijacked material; you will need select an appropriate material to hijack based on your unit's properties. 

- The `colors`, `normals`, and `MABs` tables are keys corressponding to the respective `mat_slots` whos values are file paths to the texture resources for your unit. 

To save yourself some time searching for the right material and texture map combinations you can just copy [some combinations I've already found](#known-combinations).
## Finding a Material
Picking the material you want to hijack can be tricky as you will need to know respective file path to the material resource, and generally speaking this is not readily avaible to players or modders of Vermintide 2. Using some guess work about the file structure and naming convention Fatshark used for their games we can overcome this hurlde though. Generally speaking weapon skins found in the game's global [`WeaponSkins`](https://github.com/Aussiemon/Vermintide-2-Source-Code/blob/master/scripts/settings/equipment/weapon_skins.lua) table have the same `.unit` and `.material` file paths. From the starting example the resource path, `units/weapons/player/wpn_empire_handgun_02_t2/wpn_empire_handgun_02_t2`, is both the path of the `.unit` and `.material` file.

## Choosing a Material
Now that you know where you can find some material files at you need to choose one. While most in game materials have diffuse, normal, metallic, and roughness channels; some channels like the alpha and emmissive are not present on every material so you'll want to make sure you pick a material that has all the material channels you plan using for your unit. I've basically just guessed and checked to determine if a given material has a channel or not. The glowing weapons have emmissive channels while the non-glowing ones typically do not. Items with "whispy" details like the flame dagger and helmets with feathers have alpha channles for the heat radiation and feather textures respectively. 

## Finding the Texture Maps
Once you've choosen a material you'll need to figure out the names of the corresponding texture maps for that material. This is no easy endevour and basically requires that you guess and check. Below is a list of all texture map names I found by searching the material files, using the [VT2 Bundle Unpacker](https://gitlab.com/lschwiderski/vt2_bundle_unpacker). Each map name corresponds to some sort of compressed texture resource. Following the [above example](#example-data-block), ```texture_map_59cd86b9``` is the texture map name of the normal channel used by the ```units/weapons/player/wpn_empire_handgun_02_t2/wpn_empire_handgun_02_t2.material``` material. 
<details>
  <summary>Reveal Map names</summary>
  
  ### Texture Maps
  ```texture_map_06d47a4f```
```texture_map_b1e5220a```
```texture_map_ac93ba11```
```texture_map_922f2a62```
```texture_map_e36a0c9b```
```texture_map_6a76765f```
```texture_map_2d8dcef6```
```texture_map_93129ec5```
```texture_map_5f5756f6```
```texture_map_9174a138```
```texture_map_6dbcca1f```
```texture_map_ed815032```
```texture_map_0c27b399```
```texture_map_5fdd2834```
```texture_map_e4087a35```
```texture_map_871dd4d7```
```texture_map_b842229b```
```texture_map_39684367```
```texture_map_cc2a0934```
```texture_map_50da37af```
```texture_map_c7359812```
```texture_map_2b03a640```
```texture_map_96fa1363```
```texture_map_f9695dc3```
```texture_map_4c1294de```
```texture_map_487709b9```
```texture_map_a6c7069f```
```texture_map_1edf1c79```
```texture_map_ee4df551```
```texture_map_fbc309ad```
```texture_map_7529ee12```
```texture_map_23a8ae40```
```texture_map_8be86958```
```texture_map_d219e246```
```texture_map_4a1f0315```
```texture_map_516798e3```
```texture_map_6f89a455```
```texture_map_8f6fa466```
```texture_map_6e114674```
```texture_map_990e13c4```
```texture_map_8354636d```
```texture_map_adc91f83```
```texture_map_35e14de4```
```texture_map_95d987e0```
```texture_map_db1abb7a```
```texture_map_5de4ecdd```
```texture_map_a5959c63```
```texture_map_9f5f126f```
```texture_map_2c6e2f20```
```texture_map_59cd86b9```
```texture_map_b788717c```
```texture_map_c0ba2942```
```texture_map_210ab329```
```texture_map_4068ab27```
```texture_map_arnd```
```texture_map_6f973cd6```
```texture_map_073106ab```
```texture_map_8f9ecaf5```
```texture_map_535bc097```
```texture_map_2ec31fb6```
```texture_map_eb8299ff```
```texture_map_7f6cc052```
```texture_map_8902b774```
```texture_map_5b69ac17```
```texture_map_0205ba86```
```texture_map_ee282ea2```
```texture_map_71d74d4d```
```texture_map_1cf504ab```
```texture_map_41c53566```
```texture_map_c73b3212```
```texture_map_abb81538```
```texture_map_64cc5eb8```
```texture_map_861dbfdc```
```texture_map_aeb505ca```
```texture_map_df3fc4db```
```texture_map_5d71ae0e```
```texture_map_52f212ce```
```texture_map_4d497c66```
```texture_map_afd9bc92```
```texture_map_ef750d37```
```texture_map_b07081f1```
```texture_map_136a11d3```
```texture_map_1afe3d73```
```texture_map_43a7e68f```
```texture_map_02af90f8```
```texture_map_8bf37d8e```
```texture_map_27b67fd2```
```texture_map_e55d7237```
```texture_map_3a32040d```
```texture_map_3c7cc1ab```
```texture_map_3968d594```
```texture_map_6fa04758```
```texture_map_26af1253```
```texture_map_5a39a121```
```texture_map_3a96bb42```
```texture_map_4fdb6745```
```texture_map_a66b2338```
```texture_map_828c12fd```
```texture_map_8d3ea251```
```texture_map_3cdd08be```
```texture_map_34ab297a```
```texture_map_61a32ff5```
```texture_map_f3a2c54d```
```texture_map_cd5e9898```
```texture_map_344aab54```
```texture_map_7c21dae6```
```texture_map_90573df2```
```texture_map_a8d5e6d8```
```texture_map_5d8c9098```
```texture_map_c033ee2e```
```texture_map_5d6b44ee```
```texture_map_63fbb8ea```
```texture_map_f3af270d```
```texture_map_dea0d874```
```texture_map_5a5dfe48```
```texture_map_f2ed9837```
```texture_map_205db735```
```texture_map_8776fcfe```
```texture_map_455c20c3```
```texture_map_6495176d```
```texture_map_2992e6ce```
```texture_map_819e3698```
```texture_map_68ac8714```
```texture_map_32248fa3```
```texture_map_4fb4d9e2```
```texture_map_396aacf1```
```texture_map_ca875092```
```texture_map_f6a5f6e6```
```texture_map_47def289```
```texture_map_a7375fd4```
```texture_map_d0b66787```
```texture_map_a043df23```
```texture_map_16de7ddb```
```texture_map_267b3a76```
```texture_map_d5e9786b```
```texture_map_a4031633```
```texture_map_26349c28```
```texture_map_12db845a```
```texture_map_6aa7032a```
```texture_map_66dd7c52```
```texture_map_1487b6ce```
```texture_map_26f3387c```
```texture_map_6b043557```
```texture_map_bf94af1f```
```texture_map_defc9fe5```
```texture_map_6d5b9f11```
```texture_map_2f29fb19```
```texture_map_5e198820```
```texture_map_6a801de5```
```texture_map_502c6e03```
```texture_map_67b7fd8d```
```texture_map_d7e519a4```
```texture_map_6696aff0```
```texture_map_4c5be184```
```texture_map_80ce860f```
```texture_map_087dabd3```
```texture_map_5043e1aa```
```texture_map_e88ddd67```
```texture_map_69060949```
```texture_map_92ccb024```
```texture_map_f9e4e6d3```
```texture_map_e3f65272```
```texture_map_da911a89```
```texture_map_572b5321```
```texture_map_0841f4ac```
```texture_map_9d58198b```
```texture_map_6ecf67ed```
```texture_map_c55018c6```
```texture_map_557ce311```
```texture_map_bdaf92c1```
```texture_map_2ad36d81```
```texture_map_6f68fa8b```
```texture_map_d3d74e30```
```texture_map_3ad24ce8```
```texture_map_5d911871```
```texture_map_d07b8516```
```texture_map_8cba04ab```
```texture_map_954a4880```
```texture_map_90e4c6b6```
```texture_map_bf942c22```
```texture_map_bc05da54```
```texture_map_cd1badc9```
```texture_map_58bb6ce1```
```texture_map_dfe76c2b```
```texture_map_4792c7d1```
```texture_map_39306fc7```
```texture_map_0ac6a77b```
```texture_map_8a25bae9```
```texture_map_3f7e63d4```
```texture_map_8588e5f8```
```texture_map_2ca5b6cd```
```texture_map_681b4ef5```
```texture_map_b84a37af```
```texture_map_29c8aaa8```
```texture_map_1ec3ec18```
```texture_map_e147ee10```
```texture_map_fefe1200```
```texture_map_0b61a550```
```texture_map_30ef865f```
```texture_map_fa4fef95```
```texture_map_27b4984e```
```texture_map_abce6733```
```texture_map_2ac25966```
```texture_map_8afa120c```
```texture_map_88ed2ad6```
```texture_map_7be2e2d8```
```texture_map_625e1cb5```
```texture_map_1199822b```
```texture_map_8d59467e```
```texture_map_b4a86e95```
```texture_map_4617b8e0```
```texture_map_2ced4a3d```
```texture_map_c0cbd013```
```texture_map_1aca79c7```
```texture_map_9a04533c```
```texture_map_f4602362```
```texture_map_c7d2cd39```
```texture_map_201b1f36```
```texture_map_e3803a22```
```texture_map_865e5cdf```
```texture_map_e3ced763```
```texture_map_fea33392```
```texture_map_8cc0970d```
```texture_map_a62625c3```
```texture_map_7b8a9c32```
```texture_map_ba18d1a6```
```texture_map_6e1807cc```
```texture_map_7175345d```
```texture_map_d5102a2c```
```texture_map_a190f88f```
```texture_map_4f4e1b87```
```texture_map_64a77490```
```texture_map_e28fefd3```
```texture_map_cad2bc28```
```texture_map_6134ccc2```
```texture_map_c71bed64```
```texture_map_ab4749b8```
```texture_map_0ae7d149```
```texture_map_3909492f```
```texture_map_be3dd686```
```texture_map_5eeef82c```
```texture_map_80d91ed2```
```texture_map_9e09b83d```
```texture_map_a3811c5b```
```texture_map_3c1e2d5b```
```texture_map_ec0b65a4```
```texture_map_344e055c```
```texture_map_dd948f95```
```texture_map_c7412f63```
```texture_map_68fea70c```
```texture_map_0b4f2d69```
```texture_map_df2c903b```
```texture_map_ed729ef3```
```texture_map_2ac53419```
```texture_map_7c5d5cb7```
```texture_map_8229c8a3```
```texture_map_1f2f8ce7```
```texture_map_9cc0c7ae```
```texture_map_3587a9f9```
```texture_map_5a74cbae```
```texture_map_8ebf3f4f```
```texture_map_69vxb1c2```
```texture_map_25358245```
```texture_map_79dd5bc3```
```texture_map_c047fe91```
```texture_map_28ff8f9a```
```texture_map_ead19055```
```texture_map_5bd0d796```
```texture_map_9a5d6634```
```texture_map_a08c5666```
```texture_map_2023804d```
```texture_map_5a342567```
```texture_map_75b1e4da```
```texture_map_f674d9b0```
```texture_map_b568a094```
```texture_map_120c747b```
```texture_map_f98eb6f8```
```texture_map_a366ef75```
```texture_map_4d5e26a0```
```texture_map_4e9602a4```
```texture_map_a7cfb9a2```
```texture_map_6f27d867```
```texture_map_ecf638fe```
```texture_map_3```
```texture_map_2```
```texture_map_1```
```texture_map_73e840d0```
```texture_map_7df3f90e```
```texture_map_553555e1```
```texture_map_f790f638```
```texture_map_7ed95cd9```
```texture_map_fa3c5186```
```texture_map_c5b95543```
```texture_map_829a0122```
```texture_map_b57b3286```
```texture_map_fcec6e24```
```texture_map_4926021a```
```texture_map_8de8635b```
```texture_map_250ca29a```
```texture_map_b20261a5```
```texture_map_0fa2d3b9```
```texture_map_61422015```
```texture_map_d91a7bc1```
```texture_map_c6238fdf```
```texture_map_c353edfd```
```texture_map_1df4634a```
```texture_map_56e96371```
```texture_map_a81cd985```
```texture_map_2fd9f0dd```
```texture_map_f20262e3```
```texture_map_b59dc47f```
```texture_map_38e6401a```
```texture_map_ec778206```
```texture_map_8f8b7691```
```texture_map_12e36ac1```
```texture_map_c01156b8```
```texture_map_fcfa8b8d```
```texture_map_020c5ceb```
```texture_map_0b7e05e8```
```texture_map_173784e5```
```texture_map_060b2913```
```texture_map_90524d42```
```texture_map_8e43ad18```
```texture_map_67fc3861```
```texture_map_ed46107f```
```texture_map_3dcad4c7```
```texture_map_ef557244```
```texture_map_7f4303da```
```texture_map_a761c6dc```
```texture_map_f45f7afc```
```texture_map_2879779e```
```texture_map_a476dc80```
```texture_map_bcc8203a```
```texture_map_885b01a6```
```texture_map_3c2ce796```
```texture_map_1ecfb5b8```
```texture_map_deb2ffb0```
```texture_map_5d83deb1```
```texture_map_fae72135```
```texture_map_23c7f21c```
```texture_map_42c97c8d```
```texture_map_d9f93aec```
```texture_map_f34aef0b```
```texture_map_e70dc8ca```
```texture_map_78d2611a```
```texture_map_d70982f8```
```texture_map_c480712e```
```texture_map_1f36327b```
```texture_map_3981a879```
```texture_map_49070a80```
```texture_map_0b3375ea```
```texture_map_93b6d158```
```texture_map_c53fcaa4```
```texture_map_85a8eff0```
```texture_map_b23ddce8```
```texture_map_ddd81f08```
```texture_map_c9a46c0e```
```texture_map_96d37975```
```texture_map_21c74317```
```texture_map_412b4863```
```texture_map_7ba7653f```
```texture_map_75f61d05```
```texture_map_d08bfe8d```
```texture_map_e66e7236```
```texture_map_4eead3c5```
```texture_map_5f0710b2```
```texture_map_red_normal```
```texture_map_6519a2cf```
```texture_map_green_normal```
```texture_map_base_normal```
```texture_map_b07e4257```
```texture_map_9fadcad4```
```texture_map_0ac51e25```
```texture_map_2f6d4b6a```
```texture_map_0e4ff8d1```
```texture_map_5100d116```
```texture_map_70d9edda```
```texture_map_6aee54c7```
```texture_map_e6e83fa8```
```texture_map_b39c9993```
```texture_map_8e814987```
```texture_map_f7701559```
```texture_map_30f89cf7```
```texture_map_4606f155```
```texture_map_484b9bee```
```texture_map_825d29b1```
```texture_map_f24d2eb5```
```texture_map_34ad06f3```
```texture_map_74dd8f06```
```texture_map_29e82edd```
```texture_map_5dc187c6```
```texture_map_dd13a053```
```texture_map_0e1ee60e```
```texture_map_c6a1d4d0```
```texture_map_d3b280ee```
```texture_map_c924212f```
```texture_map_f017a28a```
</details>

## Known Combinations
In the intrest of saving time, I typically only use a few, already guessed material and texture map combinations
|Material|Color Map|Normal Map|MABs Map|Emissive Color Map|Emissive Detail Map|
|--------|---------|----------|--------|------------------|-------------------|
|```units/weapons/player/wpn_empire_handgun_02_t2/wpn_empire_handgun_02_t2```|texture_map_c0ba2942|texture_map_59cd86b9|texture_map_0205ba86|N/A|N/A|
|```units/weapons/player/wpn_we_dagger_01_t1/wpn_we_dagger_01_t1_runed_01_3p```|texture_map_c0ba2942|texture_map_59cd86b9|texture_map_0205ba86|texture_map_71d74d4d|texture_map_ee282ea2|


## Nuances of Texture Resources
Due to some peculairites with the ``` Material.set_texture()``` function provided by Stingray's Lua API, the texture image resources that need to be provided, end up being packed textures. The color texture must provide the color and alpha channel inputs for the material in it's respective image's RGBA channels. The normal texture provides the normal channel input for the material. The MABs and Emissives maps are a bit more complicated. The MABs texture will provide the metallic channel in image's red channel, the roughness in the images green channel, and the blood splatter shape(think of how weapons get blood decals on them when you hit enemies) in the blue channel. The emisive color texture provides the RGB color for the materials emissive channel. The emissive detail map provides the shape of the emissive channel using just an image's gray/black and white channel.

## More Information
This mod hooks only a few lua functions provied by the game to intercept the majority of non level units spawned by the game, and apply the hijacked materials to them: ```UnitSpawner.spawn_local_unit()```, ```GearUtils."create_equipment()```, and ```HeroPreviewer._spawn_item_unit()```. These three functions cover the vast majority of scenarios where you'd want to spawn a custom unit in game. As a consequence, instead of using ```World.spawn_unit()``` you will need to use the ```UnitSpawner.spawn_local_unit()``` which takes the same arguements; if you use ```World.destroy_unit()``` to remove a unit spawned with ```UnitSpawner.spawn_local_unit()```, you must first remove the unit from the game's global ```POSITION_LOOKUP``` table. 
It is enough to simple do:
```
POSITION_LOOKUP[unit] = nil
World.destroy_unit(world, unit)
``` 

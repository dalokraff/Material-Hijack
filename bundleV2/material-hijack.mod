return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`Material-Hijack` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("Material-Hijack", {
			mod_script       = "scripts/mods/Material-Hijack/Material-Hijack",
			mod_data         = "scripts/mods/Material-Hijack/Material-Hijack_data",
			mod_localization = "scripts/mods/Material-Hijack/Material-Hijack_localization",
		})
	end,
	packages = {
		"resource_packages/Material-Hijack/Material-Hijack",
	},
}

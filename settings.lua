data:extend({
	{
		type = "bool-setting",
		name = "show-tite-grid-for-user",
		default_value = true,
		setting_type = "runtime-per-user",
	},
	{
		type = "double-setting",
		name = "show-tite-grid-width",
		default_value = 0.007,
		minimum_value = 0,
		maximum_value = 32,
		setting_type = "runtime-global",
	},
	{
		type = "double-setting",
		name = "show-tite-grid-length",
		default_value = 0.1,
		minimum_value = 0,
		maximum_value = 32,
		setting_type = "runtime-global",
	},
})


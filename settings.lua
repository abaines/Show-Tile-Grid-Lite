data:extend({
	{
		type = "string-setting",
		name = "show-tite-grid-for-user",
		default_value = "Always",
		setting_type = "runtime-per-user",
		allowed_values = {"Always", "Never"},
	},
	-- runtime-global
	{
		type = "double-setting",
		name = "show-tite-grid-width",
		default_value = 0.0,
		minimum_value = 0,
		maximum_value = 32,
		setting_type = "runtime-global",
	},
	{
		type = "double-setting",
		name = "show-tite-grid-length",
		default_value = 1,
		minimum_value = 0,
		maximum_value = 16,
		setting_type = "runtime-global",
	},
	{
		type = "string-setting",
		name = "show-tite-grid-shape",
		default_value = "Cross",
		setting_type = "runtime-global",
		allowed_values = {"Cross", "Circle"},
	},
	-- color
	{
		type = "double-setting",
		name = "show-tite-grid-color-r",
		default_value = 0.3,
		minimum_value = 0,
		maximum_value = 1,
		setting_type = "runtime-global",
	},
	{
		type = "double-setting",
		name = "show-tite-grid-color-g",
		default_value = 0.0,
		minimum_value = 0,
		maximum_value = 1,
		setting_type = "runtime-global",
	},
	{
		type = "double-setting",
		name = "show-tite-grid-color-b",
		default_value = 0.0,
		minimum_value = 0,
		maximum_value = 1,
		setting_type = "runtime-global",
	},
	{
		type = "double-setting",
		name = "show-tite-grid-color-a",
		default_value = 0.0,
		minimum_value = 0,
		maximum_value = 1,
		setting_type = "runtime-global",
	},
})


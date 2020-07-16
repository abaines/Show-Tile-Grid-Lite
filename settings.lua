-- Kizrak

data:extend({
	{
		type = "string-setting",
		name = "show-tile-grid-for-user",
		default_value = "Auto",
		setting_type = "runtime-per-user",
		allowed_values = {"Always", "Auto", "Never"},
	},
	-- runtime-global
	{
		type = "double-setting",
		name = "show-tile-grid-width",
		default_value = 0.0,
		minimum_value = 0,
		maximum_value = 32,
		setting_type = "runtime-global",
		order = "c-a",
	},
	{
		type = "double-setting",
		name = "show-tile-grid-length",
		default_value = 1,
		minimum_value = 0,
		maximum_value = 16,
		setting_type = "runtime-global",
		order = "a-d",
	},
	{
		type = "string-setting",
		name = "show-tile-grid-shape",
		default_value = "Cross",
		setting_type = "runtime-global",
		allowed_values = {"Cross", "Circle"},
		order = "a-b",
	},
	-- color
	{
		type = "double-setting",
		name = "show-tile-grid-color-r",
		default_value = 0.5,
		minimum_value = 0,
		maximum_value = 1,
		setting_type = "runtime-global",
		order = "b-color-1",
	},
	{
		type = "double-setting",
		name = "show-tile-grid-color-g",
		default_value = 0.2,
		minimum_value = 0,
		maximum_value = 1,
		setting_type = "runtime-global",
		order = "b-color-2",
	},
	{
		type = "double-setting",
		name = "show-tile-grid-color-b",
		default_value = 0.0,
		minimum_value = 0,
		maximum_value = 1,
		setting_type = "runtime-global",
		order = "b-color-3",
	},
	{
		type = "double-setting",
		name = "show-tile-grid-color-a",
		default_value = 0.0,
		minimum_value = 0,
		maximum_value = 1,
		setting_type = "runtime-global",
		order = "b-color-4",
	},
})


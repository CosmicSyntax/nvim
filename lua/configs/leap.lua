-- LEAP!
local leap = require("leap")
leap.add_default_mappings()
leap.opts.special_keys = {
	repeat_search = '<tab>',
	next_phase_one_target = '<tab>',
	next_target = {'<tab>', ';'},
	prev_target = {'<s-tab>', ','},
}

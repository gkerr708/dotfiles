require("git"):setup {
	-- Order of status signs showing in the linemode
	order = 1500,
}

require("spot"):setup {
	metadata_section = {
		enable = true,
		hash_cmd = "xxhsum",
		hash_filesize_limit = 150,
		relative_time = true,
		time_format = "%Y-%m-%d %H:%M",
		show_compression = true,
	},
	plugins_section = { enable = true },
}

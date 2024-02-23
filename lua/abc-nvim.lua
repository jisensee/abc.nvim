ABC_PLAY_JOB = nil

local function stop()
	if ABC_PLAY_JOB then
		vim.fn.jobstop(ABC_PLAY_JOB)
	end
	ABC_PLAY_JOB = nil
end

local function get_track_no()
	local buffer_no = vim.api.nvim_get_current_buf()
	local win_no = vim.api.nvim_get_current_win()
	local current_line = vim.api.nvim_win_get_cursor(win_no)[1]
	local lines = vim.api.nvim_buf_get_lines(buffer_no, 0, current_line, false)

	local track_no = 1
	for i = 1, #lines do
		local line = lines[#lines + 1 - i]
		local match = string.match(line, "^X:%s*(%d+)")
		if match then
			track_no = match
			break
		end
	end

	return track_no
end

local function play()
	if ABC_PLAY_JOB then
		stop()
	end

	local track_no = get_track_no()
	local input_file = vim.fn.expand("%:p")
	local output_midi = "/tmp/output.mid"

	local abc2midi = "abc2midi " .. input_file .. " " .. track_no .. "  -o " .. output_midi

	local timidity = "timidity " .. output_midi

	ABC_PLAY_JOB = vim.fn.jobstart(abc2midi .. "&&" .. timidity)
end

ABC_PREVIEW_JOB = nil
PREVIEW_AUTO_CMD_GROUP = "AbcPreview"

local function stop_preview()
	if ABC_PREVIEW_JOB then
		vim.fn.jobstop(ABC_PREVIEW_JOB)
	end
	ABC_PREVIEW_JOB = nil
	vim.api.nvim_clear_autocmds({
		group = PREVIEW_AUTO_CMD_GROUP,
	})
end

local function preview()
	if ABC_PREVIEW_JOB then
		stop_preview()
	end

	local input_file = vim.fn.expand("%:p")
	local output_svg = "/tmp/output.svg"

	local abcm2ps = "abcm2ps " .. input_file .. " -X -O " .. output_svg

	vim.api.nvim_create_augroup(PREVIEW_AUTO_CMD_GROUP, { clear = true })
	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		pattern = { "*.abc" },
		callback = function()
			vim.fn.jobstart(abcm2ps)
		end,
	})

	if not ABC_PREVIEW_JOB then
		local live_server = "live-server " .. output_svg
		ABC_PREVIEW_JOB = vim.fn.jobstart(abcm2ps .. "&&" .. live_server)
	end
end

local function setup()
	vim.api.nvim_create_user_command("AbcPlay", play, {})
	vim.api.nvim_create_user_command("AbcStop", stop, {})
	vim.api.nvim_create_user_command("AbcPreview", preview, {})
	vim.api.nvim_create_user_command("AbcPreviewStop", stop_preview, {})
end

return {
	setup = setup,
	play = play,
	stop = stop,
	preview = preview,
	preview_stop = stop_preview,
}

--- @module 'blink-cmp'
local defaults = require("blink-cmp-progress.defaults")
local async = require("blink.cmp.lib.async")
local keywords
local config

--- @class blink.cmp.Source
local ProgressSource = {}

---Include the trigger character when accepting a completion.
---@param context blink.cmp.Context
local function transform(items, context)
	return vim.tbl_map(function(entry)
		return vim.tbl_deep_extend("force", entry, {
			kind = items.kind,
			textEdit = {
				range = {
					start = { line = context.cursor[1] - 1, character = context.bounds.start_col - 1 },
					["end"] = { line = context.cursor[1] - 1, character = context.cursor[2] },
				},
			},
		})
	end, items)
end

function ProgressSource.new(opts)
	local self = setmetatable({}, { __index = ProgressSource })
	config = vim.tbl_deep_extend("keep", opts or {}, defaults)
	if not keywords then
		keywords = require("blink-cmp-progress.keywords").get()
	end
	return self
end

function ProgressSource:get_completions(context, callback)
	local task = async.task.empty():map(function()
      local filtered = {}
		local is_char_trigger = vim.list_contains(
			self:get_trigger_characters(),
			context.line:sub(context.bounds.start_col - 1, context.bounds.start_col - 1)
		)

      if is_char_trigger then
         filtered = vim.tbl_filter(function (item)
            if item.kind == 2 or item.kind == 10 then
               return true
            end
            return false
         end, keywords)
      end

		callback({
			is_incomplete_forward = true,
			is_incomplete_backward = true,
			-- items = transform(keywords, context),
			items = is_char_trigger and transform(filtered, context) or transform(keywords, context),
			context = context,
		})
	end)
	return function()
		task:cancel()
	end
end

function ProgressSource:resolve(item, callback)
	local resolved = vim.deepcopy(item)
	if config.insert then
		resolved.textEdit.newText = resolved.insertText
	end
	return callback(resolved)
end

function ProgressSource:get_trigger_characters()
	return { ":" }
end

return ProgressSource

-- ~/.config/nvim/lua/claude-commands.lua

local M = {}

-- Helper: get visual selection
local function get_visual_selection()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])

  if #lines == 0 then return "" end

  -- Trim first and last line to selection bounds
  lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
  lines[1] = string.sub(lines[1], start_pos[3])

  return table.concat(lines, "\n")
end

-- Helper: send to Claude Code via terminal
local function send_to_claude(prompt, code)
  local full_prompt = prompt .. "\n\n```\n" .. code .. "\n```"

  -- Option 1: Open in a split terminal
  vim.cmd("vsplit | terminal claude")
  vim.defer_fn(function()
    local chan = vim.b.terminal_job_id
    if chan then
      vim.fn.chansend(chan, full_prompt .. "\n")
    end
  end, 500)  -- Small delay for terminal to initialize
end

-- Commands
function M.why()
  local code = get_visual_selection()
  send_to_claude("Explain why this code works (or doesn't). Don't suggest fixes yet.", code)
end

function M.edge()
  local code = get_visual_selection()
  send_to_claude("List edge cases and potential failure modes for this code. Be terse.", code)
end

function M.sig()
  local code = get_visual_selection()
  send_to_claude("Show the function signature and brief usage. Nothing more.", code)
end

function M.alt()
  local code = get_visual_selection()
  send_to_claude("Suggest one alternative approach. Describe it, don't implement it.", code)
end

function M.review()
  local code = get_visual_selection()
  send_to_claude("Review this code for issues. Keep it short.", code)
end

return M

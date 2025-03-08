FrontmatterUpdate = { alias = {}, tags = {}, fields = {} }
--
--modify the frontmatter in any way
--
--@param newFrontmatter FrontmatterUpdate
local function modifyFrontmatter(newFrontmatter)
  -- Get the `obsidian.Client` instance.
  local client = require("obsidian").get_client()

  -- Get the `obsidian.Note` instance corresponding to the current buffer.
  local note = assert(client:current_note(), "Current obsidian note not found")

  --print(vim.inspect(newFrontmatter))

  if not (newFrontmatter.alias == nil) and not (next(newFrontmatter.alias) == nil) then
    for _, v in ipairs(newFrontmatter.alias) do
      note.add_alias(note, v)
    end
  end

  --print("new fields:".. vim.inspect(newFrontmatter.fields))
  --print("next field:".. vim.inspect(next(newFrontmatter.fields)))
  --print("conditions: " .. vim.inspect(not (newFrontmatter.fields== nil)).. " and " .. vim.inspect(not (next(newFrontmatter.fields) == nil)))
  if not (newFrontmatter.tags == nil) and not (next(newFrontmatter.tags) == nil) then
    for _, v in ipairs(newFrontmatter.tags) do
      --print("tag: " .. vim.inspect(v))
      --print("note: " .. vim.inspect(note))
      --print("note has_tag: " .. vim.inspect(note.has_tag))
      note.add_tag(note, v)
    end
  end

  if not (newFrontmatter.fields == nil) and not (next(newFrontmatter.fields) == nil) then
    for k, v in pairs(newFrontmatter.fields) do
      --print("field: " .. vim.inspect(k)..";"..vim.inspect(v))
      --print("note: " .. vim.inspect(note))
      note.add_field(note, k, v)
    end
  end

  --print(vim.inspect(note.tags))
  --print(vim.inspect(note.alias))
  -- Save the updated frontmatter back to the buffer.
  note:save_to_buffer()
end

local function addTag(tag)
  modifyFrontmatter({ tags = { tag } })
end

local function addOrUpdateField(key, value)
  modifyFrontmatter({ fields = { [key] = value } })
end



-- Optional, alternatively you can customize the frontmatter data.
---@param note
---@return table
local function noteFrontmatterFunc(note)
  -- Add the title of the note as an alias.
  if note.title then
    note:add_alias(note.title)
  end

  local out = { id = note.id, aliases = note.aliases, tags = note.tags }

  -- Add persistent custom fields default values here
  -- The default value will be overwritten by the actual value
  out["quality"] = "raw"
  out["creation_date"] = os.date("%d-%m-%Y")

  -- `note.metadata` contains any manually added fields in the frontmatter.
  -- So here we just make sure those fields are kept in the frontmatter.
  if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
    for k, v in pairs(note.metadata) do
      out[k] = v
    end
  end

  -- Could add custom field that update at each write here, they will overwrite the previous value

  return out
end

local function noteIdFunc(title)
  -- Create note IDs in a Zettelkasten format with a timestamp and a prefix.
  -- In this case a note with the title 'My new note' will be given an ID that looks
  -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
  title = tostring(title)
  local prefix = ""
  if title ~= nil then
    -- If title is given, transform it into valid file name.
    prefix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
  else
    -- If title is nil, just add 4 random uppercase letters to the prefix.
    for _ = 1, 4 do
      prefix = prefix .. string.char(math.random(65, 90))
    end
  end
  return prefix .. "-" .. tostring(os.time())
end



return { note_id_func = noteIdFunc, add_tag = addTag, note_frontmatter_func = noteFrontmatterFunc, add_or_update_field =
addOrUpdateField }


Obsidian = require("obsidian")
Path = require("obsidian.path")
Note = require("obsidian.note")

FrontmatterUpdate = { alias = {}, tags = {}, fields = {} }
--
--modify the frontmatter in any way
--
--@param newFrontmatter FrontmatterUpdate
local function modifyFrontmatter(newFrontmatter, note)
  -- Get the `obsidian.Client` instance.
  local client = Obsidian.get_client()

  -- Get the `obsidian.Note` instance corresponding to the current buffer.
  note = note and note or assert(client:current_note(), "Current obsidian note not found")

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
  return note
end

--TODO: Function that searches through metadata
local function searchFields()
  -- Get the `obsidian.Client` instance.
  local client = Obsidian.get_client()
  local workspace = Obsidian.workspace.get_workspace_for_cwd()
  -- Get the `obsidian.Note` instance corresponding to the current buffer.
  local note = assert(client:current_note(), "Current obsidian note not found")


end

local function addTag(tag)
  local note = modifyFrontmatter({ tags = { tag } })

  note:save_to_buffer()
end

local function addOrUpdateField(key, value)
  local note = modifyFrontmatter({ fields = { [key] = value } })
  note:save_to_buffer()
end



-- Optional, alternatively you can customize the frontmatter data.
---@param note Obsidian.note
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
  out["creation_date"] = os.date("%b|%m-%a|%d-%Y")

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


--- Get the path to a periodic note.
---
---@param datetime integer|?
---@param periodicity string|?
---
---@return Obsidian.Path, string (Path, ID) The path and ID of the note.
function periodicNotePath(periodicity, datetime)
  datetime = datetime and datetime or os.time()
  periodicity = periodicity and periodicity or "daily" 

  print(vim.inspect(datetime))
  local client = Obsidian.get_client()

  ---@type Obsidian.Path
  local path = Obsidian.Path:new(client.dir)

  if client.opts.daily_notes.folder ~= nil then
    ---@type Obsidian.Path
    ---@diagnostic disable-next-line: assign-type-mismatch
    path = path / client.opts.daily_notes.folder
  elseif client.opts.notes_subdir ~= nil then
    ---@type Obsidian.Path
    ---@diagnostic disable-next-line: assign-type-mismatch
    path = path / client.opts.notes_subdir
  end

  local id
  if client.opts.daily_notes.date_format ~= nil then
    id = periodicity.."-"..tostring(os.date(client.opts.daily_notes.date_format, datetime))
  else
    id = periodicity.."-"..tostring(os.date("%Y-%m-%d", datetime))
  end

  path = path / (id .. ".md")

  -- ID may contain additional path components, so make sure we use the stem.
  id = path.stem

  print(vim.inspect(path).."- id: ".. vim.inspect(id))

  return path, id
end


--- Open (or create) the daily note.
---
---@param datetime integer
---@param periodicity string
---@param opts { no_write: boolean, load: }
---
---@private
function periodicNotes(periodicity, datetime, opts)
  opts = opts or {}
  local client = Obsidian.get_client()


  local path, id = periodicNotePath(periodicity, datetime)

  ---@type string|?
  local alias
  if client.opts.daily_notes.alias_format ~= nil then
    alias = periodicity .."-".. tostring(os.date(client.opts.daily_notes.alias_format, datetime))
  end

  ---@type Obsidian.Note
  local note
  if path:exists() then
    note = Note.from_file(path, opts.load)
  else
    note = Note.new(id, {}, client.opts.daily_notes.default_tags or {}, path)

    if alias then
      note:add_alias(alias)
      note.title = alias
    end
    local weekOfMonth = math.ceil(tonumber(os.date("%d"))/7)
    note = modifyFrontmatter({ fields = { ["date"] = os.date("%d-%a|"..weekOfMonth.."|%m-%b|%Y", datetime), ["periodicity"] = periodicity } }, note)

    local templatePath = client.templates_dir(client)
    print("templatePath"..vim.inspect(templatePath))
    -- Ecrire avec template choisi en fct de la périodicité de la note
    if not opts.no_write then
      client:write_note(note) --{ template = tostring(templatePath).."/"..periodicity..".md"})-- templatesl_dir fonction de client qui prend un workspace
    end
  end
  print(vim.inspect(note).."-type:"..type(note))
  client.open_note(client, note)
end

function quickNote()
    local name = vim.fn.input("Enter quick note name: ")
    if name ~= "" then
        vim.cmd("!mycli notes quick" .. name)
    end
end

return { note_id_func = noteIdFunc, add_tag = addTag, note_frontmatter_func = noteFrontmatterFunc, add_or_update_field =
addOrUpdateField, periodic_notes = periodicNotes, quick_note = quickNote}

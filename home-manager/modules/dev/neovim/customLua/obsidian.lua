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

  print(vim.inspect(newFrontmatter))

  if not newFrontmatter.alias == nil and not next(newFrontmatter.alias) == nil then
    for _, v in ipairs(newFrontmatter.alias) do
      note.add_alias(v)
    end
  end

  print("new tags:".. vim.inspect(newFrontmatter.tags))
  print("next tag:".. vim.inspect(next(newFrontmatter.tags)))
  print("conditions: " .. vim.inspect(not (newFrontmatter.tags == nil)).. " and " .. vim.inspect(not (next(newFrontmatter.tags) == nil)))
  if not (newFrontmatter.tags == nil) and not (next(newFrontmatter.tags) == nil) then
    for _, v in ipairs(newFrontmatter.tags) do
      print("tag: " .. vim.inspect(v))
      print("note: " .. vim.inspect(note))
      print("note has_tag: " .. vim.inspect(note.has_tag))
      note.add_tag(note, v)
    end
  end

  if not newFrontmatter.fields == nil and not next(newFrontmatter.fields) == nil then
    for k, v in pairs(newFrontmatter.fields) do
      note.add_field(k, v)
    end
  end

  print(vim.inspect(note.tags))
  print(vim.inspect(note.alias))
  -- Save the updated frontmatter back to the buffer.
  note:save_to_buffer()
end

local function addTag(tag)
  modifyFrontmatter({ tags = { tag } })
end

local function noteIdFunc(title)
  -- Create note IDs in a Zettelkasten format with a timestamp and a prefix.
  -- In this case a note with the title 'My new note' will be given an ID that looks
  -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
  print("noteIdFunc")
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



return { noteIdFunc = noteIdFunc, addTag = addTag } 

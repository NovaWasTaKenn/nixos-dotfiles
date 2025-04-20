-- remove_frontmatter.lua
local logging = require("pandoc-logging")

function Pandoc(pandoc)
	logging.temp("pandoc", pandoc)
end

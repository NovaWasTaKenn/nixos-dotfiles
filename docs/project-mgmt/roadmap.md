
- nix managed vscode
    - Extensions :  Base ok, rest as needed
    - Carefull with telescope filter on files to show (searches even in packages dirs / git dirs / other technical dirs. Cant ignore hidden file otherwise no edit of files such as .env, .gitignore)
    - perso vs pro profiles : opencode vs copilot / claude
    - Keybinds for obsidian docs
        - Quick note
        - Telescope on '<space>ff' same as nvim
        - Ability to search and open a specific note from any project

- Fix nvim config 
    - Scope of nvim : quick edits where opening a whole vscode is annoying
    - Perhaps fix telescope filter on files to show (searches even in packages dirs / git dirs / other technical dirs. Cant ignore hidden file otherwise no edit of files such as .env, .gitignore)

- Obsidian features / automations (Ran via keybind or terminal command) :
    - Backup / Sync through github
    - Sync in project docs folder with obsidian notes 
        - Different tone/content for run/contribution oriented docs vs longer term lessons learned obsidian notes -> perhaps ia agent bridging the gap
        - One project can impact multiple techs / concept so multiple obsidian notes 
        - Agent needs to extract learnings from the docs and update related obsidian notes / create new ones for new concepts
        
    - Per project
        - Note containing a quick description, reference to its docs, the roadmap / feature list progress and the repo. Perhaps project completness too
        - Duplication of docs from project dir
        - Issues / Features tickets
    - Ticket system for projects 
        - Template for the note
        - Quick creation of the note in obsidian and depending on config duplication to jira
    - Use existing cli 
    - Docs upload to confluence

- Generic asynchronious agent automation that pull from one or multiple notes and updates notes (config with agent prompt, rules to restrict input and output notes, templates for note creation)
    - Needs study of existing solutions for agentic automations with tools, ...
    - Probably runs on homelab, plan for run via systemd service as backup

- Cli :
    - Finish config cmd
    - Extract repeated logic to shared utils
    - Add commands for the different obsidian / note system features


- Onboard homelab and dotfiles to Obsidian 

#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure
#! nix-shell -p bash libnotify

cd ~/Documents
workspaces=$(ls)
echo $workspaces

  urgencyLevels=("low" "normal" "critical")
for workspace in $workspaces;
do
  echo $workspace

  if [ -d "./$workspace/10-Inbox" ]; then 
    cd "./$workspace/10-Inbox"
  else 
   break 
  fi

  inboxCount=$(ls | wc -l)
  urgencyIndex=$(( ((inboxCount-5) / 5) ))  # Divide inboxCount by 5
  if [ $urgencyIndex -gt 2 ]; then
    urgencyIndex=2  # Ensure we don't go out of bounds (we only have 3 levels)
  fi

  urgencyLevel=${urgencyLevels[$urgencyIndex]}
  if [ $inboxCount -ge 5 ]; then 
    notify-send "Obsidian: Inbox full" "Workspace: $workspace has $inboxCount notes in Inbox" -a "Obsidian" -u $urgencyLevel -t 120 
  fi

  cd ../..

done

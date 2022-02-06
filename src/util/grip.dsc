mortal_grip:
  type: task
  definitions: target
  script:
  - define target_player <[target].flag[mortal.copy]>
  - if !<[target_player].is_online>:
    - narrate "<red>This player is offline."
    - stop
  # Put player in "gripping" state to check for movement
  - flag <player> mortal.gripping
  # Create countdown bossbar
  - define id revive_<[target_player].name>
  - define title "<red>Gripping <yellow><[target_player].name><green>..."
  - bossbar create <[id]> players:<player>|<[target_player]> color:red style:segmented_10 title:<[title]> progress:0.0
  # Countdown with 10s
  - repeat 10 as:n:
    - wait 1s
    # Stop if: player moves (no longer has gripping flag)
    - if !<player.has_flag[mortal.gripping]>:
      - define err "Grip stopped."
    # or one of them goes offline
    - else if !<player.is_online> || !<[target_player].is_online>:
      - flag <player> mortal.gripping:!
      - define err "Player went offline."
    # If error, update bossbar and stop
    - if <[err].exists>:
      - bossbar update <[id]> color:red title:<red><[err]>
      - wait 3s
      - bossbar remove <[id]>
      - stop
    # Progress bossbar
    - bossbar update <[id]> progress:<[n].div[10]>
  # Revive player
  - flag <[target_player]> mortal.dying:!
  - flag <player> mortal.gripping:!
  - run mortal_true_death
  # Remove copy NPC
  - remove <[target]>
  # Removes bossbar
  - bossbar remove <[id]>

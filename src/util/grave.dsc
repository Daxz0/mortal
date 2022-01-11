mortal_create_grave:
  type: task
  definitions: location
  script:
  - if !<player.inventory.is_empty>:
    # Place skull with random rotation
    - modifyblock <[location]> <player.skull_item.with[direction=<player.skull_item.material.valid_directions.random>]>
    # Generate and set grave inventory
    - define inv "<inventory[generic[size=54;title=<player.name>'s Grave]]>"
    - inventory copy d:<[inv]> o:<player.inventory>
    - flag <[location]> mortal.grave:<[inv]>
    # Clear player's inventory
    - inventory clear
extends PlayerState

func enter():
    # set the current animation root state to Crouching
    player.anim_tree.set("parameters/RootState/transition_request", "crouching")

func process(delta):
    # if the player is not trying to crouch, transition back to the OnGround state
    if !player.controls.is_crouching():
        state_machine.transition_to("OnGround")
    elif player.has_movement():
        # if the player has some horizontal movement, transition to the Crouching/Moving state
        state_machine.transition_to("Crouching/Moving")
    else:
        # if the player is not moving at all, transition to the Crouching/Stopped state
        state_machine.transition_to("Crouching/Stopped")

func physics_process(delta):
    # set the crouching blend position to player's horizontal speed divided by 4, the crouched walking speed
    player.anim_tree.set("parameters/Crouching/blend_position", player.horizontal_velocity.length() / 4.0)

extends PlayerState

func enter():
    # set the current animation root state to Crouching
    player.anim_tree.set("parameters/RootState/transition_request", "on-ground")

func process(delta):
    # if the jump button is pressed, transition into the InAir/Jumping state immediately
    if player.controls.is_jumping():
        state_machine.transition_to("InAir/Jumping")
    elif player.controls.is_crouching():
        # if the player is crouching, transition to the Crouching state, which will determine actual
        # sub state (e.g. stopped or moving) checked its own
        state_machine.transition_to("Crouching")
    elif player.controls.is_dashing() && player.dash_timer.is_stopped():
        # if the player is trying to dash and if they CAN dash, transition to the OnGround/Dashing state
        state_machine.transition_to("OnGround/Dashing")
    elif player.has_movement():
        # if the player has any kind of horizontal movement, transition to the OnGround/Running state
        state_machine.transition_to("OnGround/Running")
    elif !player.has_movement():
        # if the player has no horizontal movement, transition to the OnGround/Running state
        state_machine.transition_to("OnGround/Stopped")

func physics_process(delta):
	# set the checked ground blend position to player's horizontal speed divided by 10, the running speed
	# lerp for smooth blending
	var new_blend_pos = lerp(player.anim_tree.get("parameters/OnGround/blend_position"), player.horizontal_velocity.length() / 10.0, 0.1)
	player.anim_tree.set("parameters/OnGround/blend_position", new_blend_pos)

extends PlayerState

@export var surge_power: float = 80

# the flag for whether or not the player will surge in the next frame
var _will_surge: bool = false

func enter():
    # upon entering the state, set the jumping status to true
    _will_surge = true

    # set the surge vfx particle system to emitting
    # this is a one-shot particle system so we don't have to worry about stopping it
    player.vfx_surge.emitting = true

    player.anim_tree.set("parameters/Surging/blend_position", 1)

func exit():
    player.anim_tree.set("parameters/Surging/blend_position", 0)

func physics_process(delta):
    # call physics_process method of the the super class (State) which in turn calls the physics_process
    # method of the parent state (the super class is not the same as the parent state)
    super.physics_process(delta)

    # if the player is not going to surge, transition back to the parent state
    if !_will_surge:
        state_machine.transition_to(parent.get_path())
        return

    # reset the flag back to false
    _will_surge = false

    # get the player's current move direction and combine it with vertical the look angle to determine
    # the effective movement direction in 3D space
    var direction = Vector3.FORWARD.rotated(Vector3.UP, player.skin.rotation.y)
    
    direction.y = sin(deg_to_rad(player.camera._rot_v))
    direction = direction.normalized()

    # and move the player in that direction with the surge power
    # note that we're not leaving this to the Player script because we don't want to be interrupted
    player.velocity = direction * surge_power
    player.move_and_slide()

    # once we're done, transition back to the underwater state, which in turn can determine if it
    # should transition to the OnSurface state
    state_machine.transition_to("Swimming/Underwater")

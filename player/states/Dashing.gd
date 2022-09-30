extends PlayerState

@export var dash_power: float = 250

# the flag for whether or not the player will dash in the next frame
var _will_dash: bool = false

func enter():
    # upon entering the state, set the jumping status to true
    _will_dash = true

    # set the dash vfx particle system to emitting
    # this is a one-shot particle system so we don't have to worry about stopping it
    player.vfx_dash.emitting = true

func process(delta):
    pass

func physics_process(delta):
    # call physics_process method of the the super class (State) which in turn calls the physics_process
    # method of the parent state (the super class is not the same as the parent state)
    super.physics_process(delta)

    # if the player is not going to dash, transition back to the parent state
    if !_will_dash:
        state_machine.transition_to(parent.get_path())
        return

    # reset the flag back to false
    _will_dash = false

    # get the player's current look direction
    var move_dir = player.controls.get_movement_vector()
    var direction = Vector3.FORWARD.rotated(Vector3.UP, player.skin.rotation.y)

    # and move the player in that direction with the dash power
    # note that we're not leaving this to the Player script because we don't want to be interrupted
    player.velocity = direction * dash_power
    player.move_and_slide()

    # once we're done, transition back to the parent state
    state_machine.transition_to(parent.get_path())

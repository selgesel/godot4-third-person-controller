extends PlayerState

@export var jump_force: float = 16

# the flag for whether or not the player will jump in the next frame
var _will_jump: bool = false

func enter():
    # upon entering the state, set the jumping status to true
    _will_jump = true

    # tell the root InAir state to increase jump count and reset jump cooldown
    parent.accept_jump()

func physics_process(delta):
    # call physics_process method of the the super class (State) which in turn calls the physics_process
    # method of the parent state (the super class is not the same as the parent state)
    super.physics_process(delta)

    # if the player is not going to jump again, transition to the InAir/Falling state
    if !_will_jump:
        state_machine.transition_to("InAir/Falling")
        return

    # reset the jump flag to false
    _will_jump = false

    # set the player's vertical velocity to the jump force and transition to the InAir/Falling state
    player.y_velocity = jump_force
    state_machine.transition_to("InAir/Falling")

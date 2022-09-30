extends PlayerState

@export var move_speed: float = 10
@export var sprint_speed: float = 14
@export var turn_speed: float = 10
@export var acceleration: float = 50
@export var cam_follow_speed: float = 8

func physics_process(delta):
    # call physics_process method of the the super class (State) which in turn calls the physics_process
    # method of the parent state (the super class is not the same as the parent state)
    super.physics_process(delta)

    # set the player's horizontal velocity based checked the move or sprint speed
    var speed = sprint_speed if player.controls.is_sprinting() else move_speed
    set_horizontal_movement(speed, turn_speed, cam_follow_speed, acceleration, delta)

    # if the player is checked the floor, set their vertical velocity to a miniscule negative value to "snap"
    # them to the ground
    if player.is_on_floor():
        player.y_velocity = -0.01
    else:
        # if not, they're most likely falling of a ledge, so transition into the InAir/Falling state
        state_machine.transition_to("InAir/Falling")

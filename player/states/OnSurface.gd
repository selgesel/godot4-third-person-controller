extends PlayerState

@export var swim_speed: float = 4
@export var turn_speed: float = 2
@export var acceleration: float = 10
@export var cam_follow_speed: float = 4
@export var jump_power: float = 30
@export var dive_back_speed: float = -15

func physics_process(delta):
    # update the parent state
    super.physics_process(delta)

    # set the player's horizontal velocity based checked the swim speed
    set_horizontal_movement(swim_speed, turn_speed, cam_follow_speed, acceleration, delta)

    if player.controls.is_jumping():
        # if the player is trying to jump, set their y velocity to the jump power
        player.y_velocity = jump_power
    elif player.controls.is_swimming_down():
        # othwerise if the player is trying to swim down, set their y velocity to the dive back speed
        # and transition to the diving state
        player.y_velocity = dive_back_speed
        state_machine.transition_to("Swimming/Diving")
    else:
        # otherwise lerp the player's y velocity towards 0 so they stop moving vertically
        player.y_velocity = lerpf(player.y_velocity, 0, acceleration * delta)

extends PlayerState

@export var stop_speed: float = 6
@export var velocity_threshold: float = 0.5

func physics_process(delta):
    # update the parent state
    super.physics_process(delta)

    # lerp the player's horizontal and vertical velocities towards zero so they stop to a halt while diving
    player.horizontal_velocity = lerp(player.horizontal_velocity, Vector3.ZERO, stop_speed * delta)
    player.y_velocity = lerpf(player.y_velocity, 0, stop_speed * delta)

    # if the player's y velocity is below a certain threshold, navigate to the Swimming/Underwater state
    if abs(player.y_velocity) <= velocity_threshold:
        state_machine.transition_to("Swimming/Underwater")

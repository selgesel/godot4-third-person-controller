extends PlayerState

@export var dash_power: float = 250
@export var stop_acceleration: float = 16
@export var exit_threshold: float = 10

func enter():
    # set the dash vfx particle system to emitting
    # this is a one-shot particle system so we don't have to worry about stopping it
    player.vfx_dash.emitting = true

    # start the player's dash timer to start the cooldown
    player.dash_timer.start()

    # get the player's current look direction
    var direction = Vector3.FORWARD.rotated(Vector3.UP, player.skin.rotation.y).normalized()

    # and set the player's horizontal velocity based on the angle and the dash speed
    player.horizontal_velocity = direction * dash_power

func process(delta):
    # we'll handle state transitions ourselves
    pass

func physics_process(delta):
    # slow the player down to a halt based on the stop acceleration (or rather "deceleration")
    player.horizontal_velocity = player.horizontal_velocity.lerp(Vector3.ZERO, stop_acceleration * delta)

    # if the player's horizontal speed is less than the exit threshold, transition to the parent state
    if player.horizontal_velocity.length() <= exit_threshold:
        state_machine.transition_to(parent.get_path())

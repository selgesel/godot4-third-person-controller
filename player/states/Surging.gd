extends PlayerState

@export var surge_power: float = 80
@export var stop_acceleration: float = 12
@export var exit_threshold: float = 8

# the flag for whether or not the player will surge in the next frame

func enter():
    # set the surge vfx particle system to emitting
    # this is a one-shot particle system so we don't have to worry about stopping it
    player.vfx_surge.emitting = true

    player.anim_tree.set("parameters/Surging/blend_position", 1)

    # start the player's surge timer to start the cooldown
    player.surge_timer.start()

    # get the player's current move direction and combine it with vertical the look angle to determine
    # the effective movement direction in 3D space
    var direction = Vector3.FORWARD.rotated(Vector3.UP, player.skin.rotation.y)

    # vertical component of the velocity vector is equal to the sine of the vertical angle
    direction.y = sin(deg_to_rad(player.camera._rot_v))
    direction = direction.normalized()

    # and assign this velocity to the player's horizontal and vertical velocities
    var target_velocity = direction * surge_power
    player.horizontal_velocity = Vector3(target_velocity.x, 0, target_velocity.z)
    player.y_velocity = target_velocity.y

func exit():
    player.anim_tree.set("parameters/Surging/blend_position", 0)

func process(delta):
    pass

func physics_process(delta):
    # slow the player down to a halt both vertically and horizontally based on the stop acceleration
    player.horizontal_velocity = player.horizontal_velocity.lerp(Vector3.ZERO, stop_acceleration * delta)
    player.y_velocity = lerpf(player.y_velocity, 0, stop_acceleration * delta)

    # if the player's overall speed is less than the exit threshold, transition to the swimming state
    var speed := Vector3(player.horizontal_velocity.x, player.y_velocity, player.horizontal_velocity.z).length()
    if speed <= exit_threshold:
        state_machine.transition_to("Swimming/Underwater")

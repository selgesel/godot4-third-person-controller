extends PlayerState

@export var swim_speed: float = 4
@export var turn_speed: float = 3
@export var acceleration: float = 10
@export var cam_follow_speed: float = 6
@export var surge_cooldown: float = 1
@export var surge_charge_duration: float = .5

var _surge_cooldown_remaining: float = 0
var _surge_charge_duration: float = 0

func process(delta):
    # count towards the surge cooldown timer
    _surge_cooldown_remaining = max(0, _surge_cooldown_remaining - delta)

    # if the player is trying to surge
    if player.controls.is_surging():
        # count towards the surge charge duration and navigate to the surging animation state
        _surge_charge_duration = min(surge_charge_duration, _surge_charge_duration + delta)
        player.anim_tree.set("parameters/RootState/transition_request", "surging")
    elif _surge_charge_duration >= surge_charge_duration && _surge_cooldown_remaining <= 0:
        # otherwise if the player has sufficiently charged the surge, reset the surge cooldown and
        # charge duration timers, and also transition to the Swimming Surging state
        _surge_cooldown_remaining = surge_cooldown
        _surge_charge_duration = 0
        state_machine.transition_to("Swimming/Surging")
    else:
        # otherwise reset the surge charge duration and navigate to the swimming animation state
        _surge_charge_duration = 0
        player.anim_tree.set("parameters/RootState/transition_request", "swimming")

func exit():
    # reset the player skin's rotation in the X axis when exiting water
    player.skin.rotation.x = 0

func physics_process(delta):
    # update the parent state
    super.physics_process(delta)

    # if the player's head is above water, navigate to the Swimming/OnSurface state
    if player.head_above_water:
        state_machine.transition_to("Swimming/OnSurface")
        return

    # determine the blend position of the swimming animation blend space based checked the player's current
    # horizontal velocity, and lerp towards that value
    var anim_pos: float = player.anim_tree.get("parameters/Swimming/blend_position")
    anim_pos = lerpf(anim_pos, player.horizontal_velocity.length() / 8.0, 4 * delta)
    player.anim_tree.set("parameters/Swimming/blend_position", anim_pos)

    # set the player's current horizontal movement based checked the swim speed
    # if the player is charging a surge set this speed back to 0 to stop the player
    var speed := swim_speed
    if _surge_charge_duration > 0:
        speed = 0
    set_horizontal_movement(speed, turn_speed, cam_follow_speed, acceleration, delta)

    # determine the vertical swim angle and the corresponding vertical swim speed factor based checked it
    var vertical_angle: float = 0
    var vertical_swim_factor: float = 0

    # if the player is trying to swim upwards set the swim factor to 1 so they can rise to the surface
    if player.controls.is_swimming_up():
        vertical_swim_factor = 1
    elif player.controls.is_swimming_down():
        # if not, set it to -1 so they can sink to the bottom
        vertical_swim_factor = -1
    else:
        # otherwise determine the vertical look angle of the player based checked the camera's rotation
        vertical_angle = deg_to_rad(player.camera._rot_v)

        # and set the vertical swim factor to the sine of that angle multiplied by the player's current
        # horizontal movement speed. this way the player will only swim vertically if they're holding
        # down the forward or backwards movement buttons
        var horizontal_move_speed = -player.controls.get_movement_vector().y
        vertical_swim_factor = sin(vertical_angle) * float(horizontal_move_speed)

    # lerp the player skin's rotation in the X axis towards the angle determined right before
    player.skin.rotation.x = lerp_angle(player.skin.rotation.x, vertical_angle, cam_follow_speed * delta)

    # and lerp the player's y velocity to the swim speed multiplied by the vertical swim factor
    player.y_velocity = lerpf(player.y_velocity, vertical_swim_factor * speed, acceleration * delta)

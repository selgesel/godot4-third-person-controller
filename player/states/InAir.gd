extends PlayerState

@export var jump_cooldown: float = .2
@export var gravity: float = .98
@export var max_terminal_velocity: float = 50
@export var max_jumps: int = 2

@export var air_speed: float = 8
@export var air_acceleration: float = 10
@export var cam_follow_speed: float = 8
@export var turn_speed: float = 10

var _dash_cooldown_remaining: float = 0

var _jump_count: int = 0
var _jump_cooldown_remaining: float = 0

func enter():
    # set the current animation root state to Crouching
    player.anim_tree.set("parameters/RootState/current", 1)

func process(delta):
    # count down the jump and dash cooldown timers
    _jump_cooldown_remaining = max(_jump_cooldown_remaining - delta, 0)

    # if the player is trying to jump and they CAN jump, transition to the InAir/Jumping state
    if player.controls.is_jumping() && can_jump():
        state_machine.transition_to("InAir/Jumping")
    elif player.controls.is_dashing() && player.dash_timer.is_stopped():
        # if the player is trying to dash and they CAN dash, transition to the InAir/Dashing state and
        # set the dash cooldown timer to the cooldown duration
        state_machine.transition_to("InAir/Dashing")

func physics_process(delta):
    # set the in air blend position to player's vertical velocity divided by 50, the max. terminal velocity
    player.anim_tree.set("parameters/InAir/blend_position", player.y_velocity / 50.0)

    # if the player is checked the floor, transition to the OnGround state
    if player.is_on_floor():
        # if currently in the Falling state, also reset jump counters
        var state_name: String = "%s" % [state_machine._state.get_path()]
        if state_name.ends_with("Falling"):
            _jump_count = 0
            _jump_cooldown_remaining = 0
        state_machine.transition_to("OnGround")
        return

    # set the player's horizontal velocity based checked the air speed
    set_horizontal_movement(air_speed, turn_speed, cam_follow_speed, air_acceleration, delta)

    # otherwise decrease the vertical velocity by gravity, clamp to the max terminal velocity we defined earlier
    player.y_velocity = clamp(player.y_velocity - gravity, -max_terminal_velocity, max_terminal_velocity)

func can_jump():
    # if the player is checked the floor, or if the current jump count is less than the max jump count and the jump
    # cooldown timer is 0 or less the player can jump
    return player.is_on_floor() || (_jump_count < max_jumps && _jump_cooldown_remaining <= 0)

func accept_jump():
    # increase the jump count and reset the jump cooldown timer
    _jump_count += 1
    _jump_cooldown_remaining = jump_cooldown
    player.anim_tree.set("parameters/Jump/active", 1)

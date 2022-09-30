extends Node

class_name Controls

@export var min_pitch: float = -90
@export var max_pitch: float = 75
@export var zoom_step: float = .05
@export var sensitivity: float = 0.1

@onready var _mobile_controls = $MobileControls

var _move_vec: Vector2 = Vector2.ZERO
var _cam_rot: Vector2 = Vector2.ZERO
var _zoom_scale: float = 0
var _is_jumping: bool = false
var _is_sprinting: bool = false
var _is_dashing: bool = false
var _is_crouching: bool = false
var _is_capturing: bool = false
var _is_touchscreen: bool = false
var _is_swimming_up: bool = false
var _is_swimming_down: bool = false
var _is_surging: bool = false

func _ready():
    # wait until the parent node is ready
    await get_parent().ready

    # OS.has_touchscreen_ui_hint() reports true for anything with touch support including HTML5
    # which isn't exactly what we want when it comes down to enabling touchscreen controls
    # so instead we check if the OS name is Android or iOS, and if so, we enable touch controls
    var os_name := OS.get_name()
    if os_name == "Android" || os_name == "iOS":
        _is_touchscreen = true

    # if touchscreen controls are disabled we capture the mouse in the game window
    if !_is_touchscreen:
        _is_capturing = true
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    else:
        # otherwise we just make the mobile controls node visible
        _mobile_controls.visible = true

func _process(delta):
    # if the mouse cursor is being captured in the game window
    if _is_capturing:
        # determine the movement direction based checked the input strengths of the four movement directions
        var dx := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
        var dy := Input.get_action_strength("move_forward") - Input.get_action_strength("move_backwards")

        # and set the movement direction vector to the normalized vector so the player can't unintentionally
        # move faster when moving diagonally
        _move_vec = Vector2(dx, -dy).normalized()
    elif _is_touchscreen:
        # othwerise if we're checked a touchscreen device, get the movement direction, camera rotation and
        # zoom scale values from the mobile controls node
        _move_vec = _mobile_controls.get_movement_vector()
        _cam_rot = _mobile_controls.get_camera_rotation()
        _zoom_scale = _mobile_controls.get_zoom_scale()

    # in both desktop and touch screen devices the jump flag can be determined via the jump action
    # same goes for other actions
    _is_jumping = Input.is_action_just_pressed("jump")
    _is_sprinting = Input.is_action_pressed("sprint")
    _is_dashing = Input.is_action_pressed("dash")
    _is_crouching = Input.is_action_pressed("crouch")
    _is_swimming_up = Input.is_action_pressed("swim_up")
    _is_swimming_down = Input.is_action_pressed("swim_down")
    _is_surging = Input.is_action_pressed("surge")

func _input(event):
    # checked non-touchscreen devices toggle the mouse cursor's capture mode when the ui_cancel action is
    # pressed (e.g. the Esc key)
    if Input.is_action_just_pressed("ui_cancel"):
        _is_capturing = !_is_capturing

        if _is_capturing:
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
        else:
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

    # if the mouse cursor is being captured, update the camera rotation using the relative movement
    # and the sensitivity we defined earlier. also clamp the vertical camera rotation to the pitch
    # range we defined earlier so we don't end up in weird look angles
    if _is_capturing && event is InputEventMouseMotion:
        _cam_rot.x -= event.relative.x * sensitivity
        _cam_rot.y -= event.relative.y * sensitivity
        _cam_rot.y = clamp(_cam_rot.y, min_pitch, max_pitch)

    # if the mouse cursor is being captured, increse or decrease the zoom when the corresponding
    # action has just been pressed
    if _is_capturing:
        if Input.is_action_just_pressed("zoom_in"):
            _zoom_scale = clamp(_zoom_scale - zoom_step, 0, 1)
        if Input.is_action_just_pressed("zoom_out"):
            _zoom_scale = clamp(_zoom_scale + zoom_step, 0, 1)

func get_movement_vector():
    return _move_vec

func is_jumping():
    return _is_jumping

func is_sprinting():
    return _is_sprinting

func is_dashing():
    return _is_dashing

func is_crouching():
    return _is_crouching

func is_swimming_up():
    return _is_swimming_up

func is_swimming_down():
    return _is_swimming_down

func is_surging():
    return _is_surging

func get_camera_rotation():
    return _cam_rot

func get_zoom_scale():
    return _zoom_scale

func set_zoom_scale(zoom_scale):
    _zoom_scale = zoom_scale
    _mobile_controls.set_zoom_scale(zoom_scale)

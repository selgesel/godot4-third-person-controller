extends Control

class_name VirtualThumbStick

@export var max_distance: float = 300
@export var animate_speed: float = 10

@onready var _ring: TextureRect = $Ring
@onready var _indicator: TextureRect = $Indicator

var _value: Vector2 = Vector2.ZERO
var _is_dragging: bool = false
var _touch_index: int = -1
var _drag_origin: Vector2 = Vector2.ZERO
var _target_ring_scale: Vector2 = Vector2.ONE
var _target_ring_rotation: float = 0

func _input(event):
    # if the node or one of its ancestors is not visible in the scene tree don't do anything
    if !is_visible_in_tree():
        return

    # if a finger has just been pressed checked the screen and if it's position is inside our global rect
    if event is InputEventScreenTouch && event.is_pressed() && get_global_rect().has_point(event.position):
        # start tracking the finger
        _begin_drag(event)

    # if a finger has just touched the screen and if it's the same as the one that we're tracking
    if event is InputEventScreenTouch && !event.is_pressed() && event.index == _touch_index:
        # stop tracking the finger
        _end_drag(event)

    # if the finger that we're tracking has moved while being pressed
    if event is InputEventScreenDrag && event.index == _touch_index:
        # update the drag position
        _update_drag(event)

func _begin_drag(event: InputEventScreenTouch):
    # if we're already tracking a finger don't do anything
    if _is_dragging:
        return

    # set the tracked touch index to that of the finger that has been pressed
    _touch_index = event.index
    _is_dragging = true

    # and set the drag origin to the center of this node. note that we're not interested in the finger's
    # original position since the player would expect the movement to be relative to the center of the
    # joypad, and not where they pressed checked the joypad
    var global_rect := get_global_rect()
    _drag_origin = global_rect.position + global_rect.size / 2

func _update_drag(event: InputEventScreenDrag):
    # if we're not tracking a finger or if the event does not correspond to the finger that we're tracking
    # don't do anything
    if !_is_dragging && event.index != _touch_index:
        return

    # calculate the raw drag vector and its raw length clamp to a max. drag distance, and divide
    # this by the max. drag distance to find out the drag strength. this way for a max. drag distance
    # of 400px, a drag distance of 200px would mean half strength, whereas 400px, 600px, or 800px
    # would mean full strength
    var raw_drag_vec: Vector2 = event.position - _drag_origin
    var raw_length: float = clamp(raw_drag_vec.length(), 0, max_distance)
    var length := raw_length / max_distance

    # assign the current value to the normalized version of the drag_vec multiplied by the strength
    # by doing this we can make sure that for a max. drag distance of 400px, a drag of (200px, 0px)
    # would result in (0.5, 0) and (0px, 800px) would result in (0, 1.0)
    _value = raw_drag_vec.normalized() * length

    # update the inner ring's current rotation and scale based checked the value
    _target_ring_rotation = atan2(_value.y, _value.x)
    _target_ring_scale = Vector2.ONE * length

func _end_drag(event: InputEventScreenTouch):
    # if the finger has been lifted unchecked, stop tracking the finger and reset the value back to (0, 0)
    _touch_index = -1
    _is_dragging = false
    _value = Vector2.ZERO

func _process(delta):
    # if the node or one of its ancestors is not visible in the scene tree don't do anything
    if !is_visible_in_tree():
        return

    # lerp the ring's opacity towards 1 if a finger is being pressed, or 0 if not
    _ring.modulate.a = lerpf(_ring.modulate.a, 1 if _is_dragging else 0, animate_speed * delta)

    # lerp the ring's scale towards the current value so it grows and shrinks based checked the drag strength
    _ring.scale = lerp(_ring.scale, _target_ring_scale, animate_speed * delta)

    # lerp the indicator's current rotation towards the drag angle. note that we're using lerp_angle
    # because we actually want the indicator to rotate in whichever direction is closest to the target angle
    var rotation: float = lerp_angle(_indicator.get_rotation(), _target_ring_rotation, animate_speed * delta)
    _indicator.set_rotation(rotation)

    # lerp the indicator's opacity towards 1 if a finger is being pressed, or 0 if not
    _indicator.modulate.a = lerpf(_indicator.modulate.a, 1 if _is_dragging else 0, animate_speed * delta)

    # lerp the indicator's scale towards the current value so it grows and shrinks based checked the drag strength
    _indicator.scale = lerp(_indicator.scale, _target_ring_scale, animate_speed * delta)

func get_value():
    return _value

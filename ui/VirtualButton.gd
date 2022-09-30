@tool

class_name VirtualButton

extends Control

@export var default_color: Color = Color("999999") :
    get:
        return default_color
    set(mod_value):
        default_color = mod_value

@export var active_color: Color = Color("00c3ff") :
    get:
        return active_color
    set(mod_value):
        active_color = mod_value

@export var button_texture: Texture2D:
    get:
        return button_texture
    set(mod_value):
        button_texture = mod_value

@export var action: String

@onready var _texture_rect: TextureRect = $TextureRect

var _touch_index: int = -1

func _ready():
    self.connect("visibility_changed", self._on_visibility_changed)
    # trigger updates when the node is ready allows changes to appear in editor
    set_button_texture(button_texture)
    set_default_color(default_color)
    set_active_color(active_color)

func _input(event):
    # if the node or one of its ancestors is not visible in the scene tree don't do anything
    if !is_visible_in_tree():
        return

    # if a finger has just been pressed checked the screen and if it's position is inside our global rect
    if event is InputEventScreenTouch && event.is_pressed() && action && get_global_rect().has_point(event.position):
        # mark the current event as handled and raise an action pressed event for this action
        # also store the touch index so we know when to release the action
        _touch_index = event.index
        get_tree().set_input_as_handled()
        Input.action_press(action)
        _update_texture_color()

    # if a finger has been lifted unchecked the screen and if it's the same as the one we're tracking
    if event is InputEventScreenTouch && !event.is_pressed() && _touch_index == event.index:
        _release()

func _on_visibility_changed():
    if !visible && _touch_index != -1:
        _release()

func _release():
    # release the action and stop tracking the finger
    Input.action_release(action)
    _touch_index = -1
    _update_texture_color()

func _update_texture_color():
    # this variable might be null when in the editor, so only update its modulate if it's not
    if _texture_rect:
        _texture_rect.modulate = default_color if _touch_index == -1 else active_color

func set_button_texture(texture):
    # this variable might be null when in the editor, so only update its texture if it's not
    if _texture_rect:
        _texture_rect.texture = texture
    button_texture = texture

func set_default_color(color):
    # refresh the texture's color when the default color is changed
    _update_texture_color()
    default_color = color

func set_active_color(color):
    # refresh the texture's color when the active color is changed
    _update_texture_color()
    active_color = color

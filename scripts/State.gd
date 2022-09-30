extends Node

class_name State

@onready var state_machine
@onready var parent = get_parent()

func _init():
    # make sure the node is always in the "state" group
    add_to_group("state")

func _ready():
    state_machine = _get_state_machine(self)

# Executed when entering the state
func enter():
    if parent.is_in_group("state"):
        parent.enter()

# Executed when exiting the state
func exit():
    if parent.is_in_group("state"):
        parent.exit()

# Wrapper method for the _input handler.
# Make sure to use this method instead of the original one to prevent the code from eing executed
# unintentionally (e.g. when in another state)
func input(event):
    if parent.is_in_group("state"):
        parent.input(event)

# Wrapper method for the _unhandled_input handler
# Make sure to use this method instead of the original one to prevent the code from eing executed
# unintentionally (e.g. when in another state)
func unhandled_input(event):
    if parent.is_in_group("state"):
        parent.unhandled_input(event)

# Wrapper method for the _process handler
# Make sure to use this method instead of the original one to prevent the code from eing executed
# unintentionally (e.g. when in another state)
func process(delta):
    if parent.is_in_group("state"):
        parent.process(delta)

# Wrapper method for the _physics_process handler
# Make sure to use this method instead of the original one to prevent the code from eing executed
# unintentionally (e.g. when in another state)
func physics_process(delta):
    if parent.is_in_group("state"):
        parent.physics_process(delta)

# Traverse the scene tree upwards to find the state machine that contains this state
func _get_state_machine(node):
    if !node:
        return null

    if node.is_in_group("state_machine"):
        return node

    return _get_state_machine(node.get_parent())

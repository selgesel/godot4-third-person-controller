extends Node

class_name StateMachine

signal transitioned(state_path)

@export var initial_state := NodePath()

@onready var _state: State = get_node(initial_state)

func _init():
    # make sure the node is always in the "state_machine" group
    add_to_group("state_machine")

func _ready():
    # wait until the owner is ready
    await owner.ready

    # transition to the initial state
    transition_to(initial_state)

func _input(event):
    # delegate the _input handling to the current state
    _state.input(event)

func _unhandled_input(event):
    # delegate the _unhandled_input handling to the current state
    _state.unhandled_input(event)

func _process(delta):
    # delegate the _process handling to the current state
    _state.process(delta)

func _physics_process(delta):
    # delegate the _physics_process handling to the current state
    _state.physics_process(delta)

func transition_to(state_path: NodePath):
    # if there's no node at the specified path, don't do anything
    if !has_node(state_path):
        return

    # get node at the given path
    var new_state := get_node(state_path)

    # if we're already in the same state or if the node is not a State node, don't do anything
    if new_state == _state || !(new_state is State):
        return

    # exit the current state, set the current to the new state and enter it, and emit transitioned signal
    _state.exit()
    _state = new_state
    new_state.enter()
    emit_signal("transitioned", state_path)

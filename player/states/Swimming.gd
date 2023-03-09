extends PlayerState

func enter():
    # set the current animation root state to Swimming
    player.anim_tree.set("parameters/RootState/transition_request", "swimming")

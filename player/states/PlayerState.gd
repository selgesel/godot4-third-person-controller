extends State

class_name PlayerState

@onready var player: Player = get_tree().get_nodes_in_group("player")[0]

func set_horizontal_movement(speed, turn_speed, cam_follow_speed, acceleration, delta):
    # get the movement direction directly from the controls node and turn it into a Vector3
    var move_dir = player.controls.get_movement_vector()
    var direction = Vector3(move_dir.x, 0, move_dir.y)

    # make the player move towards where the camera is facing by lerping the current movement rotation
    # towards the camera's horizontal rotation and rotating the raw movement direction with that angle
    player.move_rot = lerpf(player.move_rot, deg_to_rad(player.camera._rot_h), cam_follow_speed * delta)
    direction = direction.rotated(Vector3.UP, player.move_rot)

    # lerp the player's current horizontal velocity towards the horizontal velocity as determined by
    # the input direction and the given horizontal speed
    player.horizontal_velocity = lerp(player.horizontal_velocity, direction * speed, acceleration * delta)

    # if the player has any amount of movement, lerp the player model's rotation towards the current
    # movement direction based checked its angle towards the X+ axis checked the XZ plane
    if move_dir != Vector2.ZERO:
        player.skin.rotation.y = lerp_angle(player.skin.rotation.y, atan2(-direction.x, -direction.z), turn_speed * delta)

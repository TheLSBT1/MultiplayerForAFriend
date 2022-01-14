extends KinematicBody2D

# Constant's
const speed_ : float = 390.0

# Variable's
var is_master : bool = false

# Initialization for the player.
func initialize(id):
	name = str(id)
	if id == Network.network_id:
		is_master = true
	else:
		modulate = Color.red
		
func _physics_process(delta: float) -> void:
	if is_master:
		var velocity = Vector2.ZERO
		var input = Vector2.ZERO
		
		input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		
		velocity = input * speed_
		
		move_and_slide(velocity)
		rpc_unreliable("update_pos", global_position)
		

# NOTE the remote keyword
remote func update_pos(pos : Vector2) -> void:
	global_position = pos

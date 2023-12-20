extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var pickup_score_yellow = 0
var pickup_score_green = 0
var pickup_score_blue = 0


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Change Transform.basis to have the camera location in front to make the input match the camers
	var direction = ($CameraPivot/Camera3D.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		# Rotate the player body in the direction of movement
		$Body.look_at(global_position - velocity, Vector3.UP)
		
		# Ensure that the player body does not rotate around the x axis.
		$Body.rotation_degrees.x = 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()


# Respawn the player on death
func respawn():
	global_position = Vector3(0,5,0)


func pickup_item(item_type):
	var value = 0
	if item_type == "YELLOW":
		pickup_score_yellow += 1
		value = pickup_score_yellow
	elif item_type == "GREEN":
		pickup_score_green += 1
		value = pickup_score_green
	elif item_type == "BLUE":
		pickup_score_blue += 1
		value = pickup_score_blue
	
	if $PlayerHud.has_method("update_score"):
		$PlayerHud.update_score(item_type, value)

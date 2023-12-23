extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

const RAY_LENGTH = 3

@export_file("*.tscn") var bomb

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var pickup_score_yellow = 0
var pickup_score_green = 0
var pickup_score_blue = 0
var score = 0
var player_name = "Player Tahi"

func _ready():
	if $PlayerHud.has_method("setup"):
		$PlayerHud.setup(player_name)

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

func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()

func shoot():
	print("Shots fired")
	var space = get_world_3d().direct_space_state
	#var query = PhysicsRayQueryParameters3D.create($CameraPivot/Camera3D.global_position,
	#		$CameraPivot/Camera3D.global_position - $CameraPivot/Camera3D.global_transform.basis.z * 100)
	var query = PhysicsRayQueryParameters3D.create($Body/ShotSpawnPosition.global_position, $Body/ShotSpawnPosition.global_position - $Body/ShotSpawnPosition.global_transform.basis.z * RAY_LENGTH)
	
	
	
	#var query = PhysicsRayQueryParameters3D.create($Body/ShotSpawnPosition.position, Vector3.ZERO)
	query.collide_with_areas = true
	
	
	
	var collision = space.intersect_ray(query)
	if collision:
		#$CanvasLayer/Label.text = collision.collider.name
		print(collision.collider.name)
		if collision.collider.is_in_group("Target"):
			collision.collider.queue_free()
			if $PlayerHud.has_method("update_score"):
				$PlayerHud.update_score("SHOTS", 1)
	else:
		print("Missed")


func spawn_bomb():
	var cur_bomb = load(bomb)
	var bomb_instance = cur_bomb.instantiate()
	
	bomb_instance.global_position = $Body/ShotSpawnPosition.global_position
	get_tree().get_root().add_child(bomb_instance)

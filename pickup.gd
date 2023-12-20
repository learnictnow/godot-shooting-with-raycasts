extends Node3D

var SPEED = 5

@export var pickup_colour_type = "YELLOW"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var material = $Area3D/MeshInstance3D.get_surface_override_material(0)
	
	#body.get_surface
	
	if pickup_colour_type == "YELLOW":
		material.albedo_color = Color.YELLOW
		
	elif pickup_colour_type == "GREEN":
		print("GREEN")
		material.albedo_color = Color.GREEN
	elif pickup_colour_type == "BLUE":
		material.albedo_color =  Color.BLUE
		
	$Area3D/MeshInstance3D.set_surface_override_material(0, material)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_item(delta)
	pass

func rotate_item(delta):
	$Area3D.rotate(Vector3(0,0,1), SPEED * delta)
	$Area3D.rotate(Vector3(1,0,0), SPEED * delta)
	$Area3D.rotate(Vector3(0,1,0), SPEED * delta)


func _on_area_3d_body_entered(body):
	# Add item to player score / inventory
	if body.is_in_group("Player"):
		if body.has_method("pickup_item"):
			body.pickup_item(pickup_colour_type)
			# Destroy item
			queue_free()
	pass # Replace with function body.

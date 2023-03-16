extends CharacterBody3D


var SPEED = 4.0
const JUMP_VELOCITY = 13
@export var sensitivity = 0.01

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var flashlight := $Neck/Camera3D/torch/SpotLight3D
@onready var interaction := $Neck/Camera3D/Interaction

func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * sensitivity)
			camera.rotate_x(-event.relative.y * sensitivity)
			camera.rotation.x = clamp(camera.rotation.x , deg_to_rad(-30) , deg_to_rad(60))
			#rotate_y(-event.relative.x * sensitivity * 0.2)

func pick_obj():
	var collider = interaction.get_collider()
	if collider != null and collider is RigidBody3D:
		print("Object Detected")
		if collider.has_method("picked") :
			collider.picked()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta *5

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	#look_at(get_tree().get_nodes_in_group("CameraController")[0].get_node("LookAt").global_position)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left" , "right" , "backwards" , "forwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_action_pressed("forwards") and Input.is_action_pressed("Sprint"):
		SPEED = 7.0
	else :
		SPEED = 4.0
	
	if Input.is_action_just_pressed("toggle_flashlight"):
		flashlight.visible = not flashlight.visible
	
	if Input.is_action_just_pressed("click"):
		pick_obj()
	
#
#	if velocity != Vector3.ZERO:
#		var lookdir = atan2(-velocity.x , -velocity.x)
#		rotation.y = lerp(velocity.y , lookdir , 0.1)
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	if Input.is_action_pressed("forwards"):
		$"Warrior Idle/AnimationPlayer".play("walk" , 1)

	elif Input.is_action_pressed("jump"):
		$"Warrior Idle/AnimationPlayer".play("jump" , 1)
	
	else:
		$"Warrior Idle/AnimationPlayer".play("idle" , 2)
#	else:
#		$"Warrior Idle/AnimationPlayer".play("idle")

	move_and_slide()

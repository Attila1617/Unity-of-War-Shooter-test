extends KinematicBody

export var speed = 50
export var accel = 50
export var gravity = 50
export var jump = 25
export var sensitivity = 0.3
export var max_angle = 90
export var min_angle = -80

onready var head = $Head

var look_rot = Vector3.ZERO
var move_dir = Vector3.ZERO
var velocity = Vector3.ZERO

var snap = Vector3.DOWN

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	#set rotation
	$Head/Camera.rotation_degrees.x = look_rot.x
	rotation_degrees.y = look_rot.y
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif Input.is_action_pressed("SPACE"):
		velocity.y = jump
		snap = Vector3.ZERO
	else:
		snap = Vector3.DOWN
	
	move_dir = Vector3(
		Input.get_axis("A", "D"),
		0,
		Input.get_axis("W", "S")
	).normalized().rotated(Vector3.UP, rotation.y)
	
	velocity.x = lerp(velocity.x, move_dir.x * speed, accel * delta)
	velocity.z = lerp(velocity.z, move_dir.z * speed, accel * delta)
	
	velocity = move_and_slide_with_snap(velocity, snap, Vector3.UP, true)


func _input(event):
	if event is InputEventMouseMotion:
		look_rot.y -= (event.relative.x * sensitivity)
		look_rot.x -= (event.relative.y * sensitivity)
		look_rot.x = clamp(look_rot.x, min_angle, max_angle)

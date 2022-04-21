extends KinematicBody

export var gravity = Vector3.DOWN * 20

export var speed = 4
var og_speed = speed

export var max_slide_speed = 30
var init_slide_speed = max_slide_speed/10
var slide_speed = init_slide_speed

export var init_jump_speed = 11
var jump_speed = init_jump_speed

export var rot_speed = 0.85

var velocity = Vector3.ZERO

var sliding = false
var jumping = false


var mouse_sens = 0.3
var camera_anglev=0

func _init():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 


func _input(event):         
	if event is InputEventMouseMotion:
		self.rotate_y(deg2rad(-event.relative.x*mouse_sens))
		
			
func _physics_process(delta):
	velocity += gravity * delta
	get_input(delta) # for user input, WASD controls
	velocity = move_and_slide(velocity, Vector3.UP) # second parameter classifies what ground is
	
	# having the controls for sliding ouside of the input function stops affeting jump vector
	
""" Rotation controls for when sliding
if Input.is_action_pressed("right"):
		rotate_y(-rot_speed * delta)
	if Input.is_action_pressed("left"):
		rotate_y(rot_speed * delta)
"""
		
func get_input(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("leftMouseButton"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_pressed("forward"):
		velocity += -transform.basis.z * speed
	if Input.is_action_pressed("backward"):
		velocity += transform.basis.z * speed
	if Input.is_action_pressed("right"):
		velocity += transform.basis.x * speed
	if Input.is_action_pressed("left"):
		velocity += -transform.basis.x * speed
			
	
	# slide effect
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity += Vector3.UP * jump_speed
	
	# movement dampening
	if abs(velocity.x) > 0:
		velocity.x -= velocity.x/10
		if abs(velocity.x) < .001:
			velocity.x = 0
	if abs(velocity.z) > 0:
		velocity.z -= velocity.z/10
		if abs(velocity.z) < .01:
			velocity.z = 0

	
	
	print(velocity)


extends KinematicBody

export var gravity = Vector3.DOWN * 50

export var speed = 3
export var max_speed = 10


export var slide_speed = 10

export var init_jump_speed = 16
var jump_speed = init_jump_speed

export var rot_speed = 0.15

var velocity = Vector3.ZERO

var sliding = false
var jumping = false

var sliding_percent = 0.0

var mouse_sens = 0.3
var camera_anglev=0

onready var UI = get_parent().find_node('UI')

func _init():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 


func _input(event):         
	if event is InputEventMouseMotion:
		self.rotate_y(deg2rad(-event.relative.x*mouse_sens))
		
			
func _physics_process(delta):
	velocity += gravity * delta
	get_input(delta) # for user input, WASD controls
	velocity = move_and_slide(velocity, Vector3.UP) # second input labels ground 
	
	# UI
	UI.find_node('ProgressBar').set('value', sliding_percent)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "KillPlane":
			resetLevel() # restart level
		if collision.collider.name == "Checkpoint1":
			print('Checkpoint!')
			
func resetLevel():
	get_tree().reload_current_scene()
#	velocity = Vector3.ZERO # reset values before spawn
#	sliding_percent = 0.0
#	self.translation = get_parent().get_node("Respawn").translation
	# tell player OOF
		
func get_input(delta):
	# restart
	if Input.is_action_just_pressed("restart"):
		resetLevel()
	
	# ui controls
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("leftMouseButton"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# movment controls
	if Input.is_action_pressed("forward"):
		velocity += -transform.basis.z * speed
	if Input.is_action_pressed("backward"):
		velocity += transform.basis.z * speed
	if Input.is_action_pressed("right"):
		if sliding:
			rotate_y(-rot_speed * delta)
		else:
			velocity += transform.basis.x * speed
	if Input.is_action_pressed("left"):
		if sliding:
			rotate_y(rot_speed * delta)
		else:
			velocity += -transform.basis.x * speed
	
	# jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity += Vector3.UP * jump_speed

	# charge up slide
	if Input.is_action_pressed("jump") and not is_on_floor():
		if sliding_percent <= 1.0:
			sliding_percent += delta * 2
			# gives a little amount of wiggle room to charge full slide
			

		
	if Input.is_action_just_released("jump"):
		sliding_percent = 0;
		
	if Input.is_action_pressed("jump") and is_on_floor() and sliding_percent > 0.1:
		sliding = true

	if not is_on_floor():
		sliding = false
	
	if sliding:
		if sliding_percent == 0:
			sliding = false
		velocity += -transform.basis.z * sliding_percent * slide_speed
		sliding_percent -= delta 
		sliding_percent = max(0, sliding_percent)
	
	# movement dampening
	else:
		if abs(velocity.x) > 0:
			velocity.x -= velocity.x/10
			if abs(velocity.x) < .07:
				velocity.x = 0
		if abs(velocity.z) > 0:
			velocity.z -= velocity.z/10
			if abs(velocity.z) < .07:
				velocity.z = 0



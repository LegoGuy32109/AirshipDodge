extends KinematicBody

export var gravity = Vector3.DOWN * 20

export var speed = 8
var og_speed = speed

export var max_slide_speed = 30
var init_slide_speed = max_slide_speed/10
var slide_speed = init_slide_speed

export var init_jump_speed = 4
var jump_speed = init_jump_speed

export var rot_speed = 0.85

var velocity = Vector3.ZERO

var sliding = false
var jumping = false

func _physics_process(delta):
	velocity += gravity * delta
	get_input(delta) # for user input, WASD controls
	velocity = move_and_slide(velocity, Vector3.UP) # second parameter classifies what ground is
	
	# having the controls for sliding ouside of the input function stops affeting jump vector
	if Input.is_action_pressed("jump") and is_on_floor():
		if not sliding:
			speed+=slide_speed
			sliding = true
		speed -= 0.5
		speed = max(speed, og_speed)

		
func get_input(delta):
	var vy = velocity.y
	velocity = Vector3.ZERO

	if Input.is_action_pressed("forward"):
		velocity += -transform.basis.z * speed
	if Input.is_action_pressed("backward"):
		velocity += transform.basis.z * speed
	if Input.is_action_pressed("right"):
		rotate_y(-rot_speed * delta)
	if Input.is_action_pressed("left"):
		rotate_y(rot_speed * delta)
			
	# slide effect
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jumping = true
		init_slide_speed = max_slide_speed/10
		jump_speed = init_jump_speed
		
	if jumping:
		vy += jump_speed
		jump_speed -= 1
		jump_speed = max(jump_speed, 0)
		
	if Input.is_action_pressed("jump") and not is_on_floor():
		init_slide_speed += 1
		init_slide_speed = min(init_slide_speed, max_slide_speed)
		
	if Input.is_action_just_released("jump"):
		speed = og_speed
		slide_speed = init_slide_speed
		sliding = false
		jumping = false	

	velocity.y = vy
	print(velocity)


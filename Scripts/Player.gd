extends KinematicBody

export var gravity = Vector3.DOWN * 10
export var speed = 4
export var rot_speed = 0.85

var velocity = Vector3.ZERO

var onFloor = true

func _physics_process(delta):
	velocity += gravity * delta
	get_input(delta) # for user input, WASD controls
	velocity = move_and_slide(velocity) # they tell me to put the delta here in the docs
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		print ('I collided with: ', collision.collider.name)
		
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
	if Input.is_action_pressed("jump"):
		vy += speed/2 

	velocity.y = vy
	


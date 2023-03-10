extends CharacterBody3D

@export var gravity = Vector3.DOWN * 10

@export var anim_speed = 12

@export var speed = 1.5
@export var max_speed = 4
var og_speed = speed

@export var slide_speed = 4

@export var jump_speed = 16

var my_velocity = Vector3.ZERO

var sliding = false
var jumping = false

var sliding_percent = 0.0

var mouse_sens = 0.3

var totalTime = 0.0
var isRacing = false
var timeString = '00:00:00'

@onready var UI = get_parent().find_child('UI')
@onready var robo = get_node('roboPlayer2/Armature/Robo')

func _init():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 


func _input(event):         
	if event is InputEventMouseMotion:
		self.rotate_y(deg_to_rad(-event.relative.x*mouse_sens))
		
			
func timer(delta):
	if isRacing:
		totalTime += delta
		#https://gamedevbeginner.com/how-to-make-a-timer-in-godot-count-up-down-in-minutes-seconds/#stopwatch
		timeString = "%02d:%02d:%02d" % [totalTime / 60, fmod(totalTime, 60), fmod(totalTime, 1) * 100]

func _physics_process(delta):
	timer(delta)
	my_velocity += gravity * delta
	get_input(delta) # for user input, WASD controls
	set_velocity(my_velocity)
	set_up_direction(Vector3.UP)
	move_and_slide()
	my_velocity = my_velocity # second input labels ground 
	
	# UI
	UI.find_child('ProgressBar').set('value', sliding_percent)
	UI.find_child('TimerLabel').set('text', timeString)
	# Collisions
	for i in get_slide_collision_count():
		var collision_name = get_slide_collision(i).get_collider().name
		if collision_name == "KillPlane":
			resetLevel() # restart level

	# Animations (Shape3D Keys)
	roboAnim(delta)
			
			
func roboAnim(delta):
	var curAirValue = robo.get("blend_shapes/Air")
	var curSlidingValue = robo.get("blend_shapes/Slide")
	if is_on_floor():
		if curAirValue >= -0.5:
			robo.set("blend_shapes/Air", curAirValue - delta * anim_speed)
	else:
		if curAirValue <= 1.1:
			robo.set("blend_shapes/Air", curAirValue + delta * anim_speed)
			
	if sliding and curSlidingValue <= 1.0:
		robo.set("blend_shapes/Slide", curSlidingValue + delta * anim_speed)
	elif not sliding and curSlidingValue >= 0:
		robo.set("blend_shapes/Slide", curSlidingValue - delta * anim_speed)
	
	
func resetLevel():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()


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
		my_velocity += -transform.basis.z * speed
	if Input.is_action_pressed("backward"):
		my_velocity += transform.basis.z * speed
	if Input.is_action_pressed("right"):
		my_velocity += transform.basis.x * speed
	if Input.is_action_pressed("left"):
		my_velocity += -transform.basis.x * speed
	
	if (Input.is_action_pressed("backward") or Input.is_action_pressed("forward") or Input.is_action_pressed("right") or Input.is_action_pressed("left")) and is_on_floor():
		speed += delta
		speed = min(max_speed, speed)
	else:
		speed = og_speed
	
	# jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		my_velocity += Vector3.UP * jump_speed

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
		my_velocity += -transform.basis.z * sliding_percent * slide_speed
		sliding_percent -= delta 
		sliding_percent = max(0, sliding_percent)
	
	# movement dampening
	var dampFactor = 10
	if sliding:
		dampFactor = 30
	
	if abs(my_velocity.x) > 0:
		my_velocity.x -= my_velocity.x/dampFactor
		if abs(my_velocity.x) < .07:
			my_velocity.x = 0
	if abs(my_velocity.z) > 0:
		my_velocity.z -= my_velocity.z/dampFactor
		if abs(my_velocity.z) < .07:
			my_velocity.z = 0



extends MeshInstance3D

func _ready():
	print(self.get_blend_shape_count())
	

func _physics_process(delta):
	var curAirValue = self.get("blend_shapes/Air")
	if Input.is_action_pressed("jump"):
		self.set("blend_shapes/Air", curAirValue - delta * 1)
	else:
		self.set("blend_shapes/Air", 0)

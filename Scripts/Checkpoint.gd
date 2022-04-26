extends Area

var is_next = false

func _on_Checkpoint1_body_entered(body):
	if is_next:
		queue_free()

func _process(delta):
	if is_next:
		$MeshInstance.material_override = null
	elif(get_parent().get_children()[0] == self):
		is_next = true
		print(self.name, " is the top checkpoint")
	

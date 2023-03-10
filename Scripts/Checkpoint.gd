extends Area3D

var is_next = false

func _on_Checkpoint1_body_entered(body):
	if is_next:
		get_parent().get_parent().get_node("Player").isRacing = true
		if get_parent().get_child_count() == 1:
			get_parent().get_parent().get_node("Player").isRacing = false
		queue_free()
	
func _process(delta):
	if is_next:
		$MeshInstance3D.material_override = null
	elif(get_parent().get_children()[0] == self):
		is_next = true
		print(self.name, " is the top checkpoint")


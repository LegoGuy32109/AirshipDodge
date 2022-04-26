extends Control

func _ready():
	$WinText.visible = false

func _process(delta):
	if get_parent().get_node("Checkpoints").get_child_count() == 0:
		$WinText.visible = true

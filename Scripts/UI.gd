extends Control

var time_to_next_level = 2
@onready var currentLevel = get_parent().name
@onready var currentLevelNum: int = int(currentLevel.right(-1))
@onready var nextLevel = "res://Scenes/Levels/Level"+str(currentLevelNum+1)+".tscn"

func _ready():
	print(currentLevel, nextLevel) # I know what I'm teleporting too
	$WinText.visible = false

func _process(delta):
	if get_parent().get_node("Checkpoints").get_child_count() == 0:
		$WinText.visible = true
		time_to_next_level -= delta
		if time_to_next_level <= 0:
			if currentLevelNum != 3:
				get_tree().change_scene_to_file(nextLevel)
			else:
				get_tree().change_scene_to_file("res://Scenes/Levels/Level1.tscn")

extends Control

var rotation_speed : int = 75

func _ready() -> void:
	$MenuAnimationPlayer.play("MenuAnimation")
func _process(delta: float) -> void:
	if Input.is_action_just_released("click"):
		get_tree().change_scene_to_file("res://scenes/main.tscn")
	
	$Arrow.rotation_degrees += rotation_speed * delta

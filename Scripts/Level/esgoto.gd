extends Node2D

@onready var anim = $AnimationPlayer


func _ready() -> void:
	
	for i in $Node2D/Eyes.get_children():
		i.frame = randi_range(0, 7)
		i.rotation = randf_range(-20,20)

func _process(delta: float) -> void:
	
	
	

	$Mist.offset.x += 0.09
	
	if Input.is_action_just_pressed("Reset"):
		reload_scene()


func reload_scene():
	get_tree().reload_current_scene()


func _on_player_died() -> void:
	$AnimationPlayer.play("End")

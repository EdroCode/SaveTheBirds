extends Node2D


@onready var bird = preload("res://Scenes/Addons/bird.tscn")
@onready var positions = [$Birds/Marker2D, $Birds/Marker2D2, $Birds/Marker2D3, $Birds/Marker2D4, $Birds/Marker2D5, $Birds/Marker2D6, $Birds/Marker2D7, $Birds/Marker2D8, $Birds/Marker2D9, $Birds/Marker2D10]

	
	
func _ready() -> void:
	var value = GameManager.birds
	
	for i in value:
		spawn_bird(positions[i])
	

func spawn_bird(pos):
	
	var b = bird.instantiate()
	b.position = pos.global_position
	b.sleeping = true
	b.pickable = false
	call_deferred("add_child", b)

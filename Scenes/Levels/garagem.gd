extends Node2D

@onready var positions = [$Birds/Marker2D, $Birds/Marker2D2, $Birds/Marker2D3, $Birds/Marker2D4, $Birds/Marker2D5, $Birds/Marker2D6, $Birds/Marker2D7, $Birds/Marker2D8]
@onready var bird = preload("res://Scenes/Addons/bird.tscn")

func _ready() -> void:
	
	var value = GameManager.birds
	
	
	for i in value:
		spawn_bird(positions[i])
	


func _process(delta: float) -> void:
	
	pass

func spawn_bird(pos):
	
	var b = bird.instantiate()
	b.position = pos.global_position
	b.pickable = false
	call_deferred("add_child", b)

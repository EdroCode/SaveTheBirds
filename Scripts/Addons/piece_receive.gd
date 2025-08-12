extends Area2D


@export var ID := 0
@export var image : Texture2D
var connected = false


func _ready() -> void:
	
	if image: 
		$"Peça01".texture = image
	#$"Peça01".modulate = Color(1.0, 1.0, 1.0, 0.294)

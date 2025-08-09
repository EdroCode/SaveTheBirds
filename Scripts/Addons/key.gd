extends Node2D

@export var Sprite : Texture2D
@export var AreaToggle : bool = true
var playerOnArea = false


func _ready() -> void:
	
	if AreaToggle:
		visible = false
	
	
	$E.texture = Sprite


func _process(delta: float) -> void:
	
	pass





func _on_body_entered(body: Node2D) -> void:
	
	if AreaToggle:
		visible = true
	playerOnArea = true



func _on_body_exited(body: Node2D) -> void:
	if AreaToggle:
		visible = false
	playerOnArea = false

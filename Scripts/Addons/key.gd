extends Node2D

@export var Sprite : Texture2D
@export var AreaToggle : bool = true
@export var SetaBaixo := false
@export var TeclaE := true

var playerOnArea = false
@export var change_with_area := true

func _ready() -> void:
	
	if AreaToggle:
		visible = false
	
	
	$E.texture = Sprite


func _process(delta: float) -> void:
	
	if SetaBaixo:
		$AnimatedSprite2D.play("DownSeta")
	elif TeclaE:
		$AnimatedSprite2D.play("TeclaE")
	
	#print(playerOnArea)





func _on_body_entered(body: Node2D) -> void:
	
	if AreaToggle:
		visible = true
	if change_with_area:
	
		playerOnArea = true



func _on_body_exited(body: Node2D) -> void:
	if AreaToggle:
		visible = false
	if change_with_area:
		playerOnArea = false

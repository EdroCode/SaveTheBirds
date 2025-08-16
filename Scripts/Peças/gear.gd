extends Area2D

signal collected

@export var gear :Texture2D
@export var eyes :Texture2D
@export var cabos :Texture2D
@export var item : String

func _ready() -> void:
	
	if item == "gear":
		$"Peça01".texture = gear
	elif item == "eyes":
		$"Peça01".texture = eyes
	elif item == "cabos":
		$"Peça01".texture = cabos
		
		# COMPLETAR AQUI
		
		
	pass



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.initialize_show(item)
		$AnimationPlayer.play("Collect")
		GameManager.PECAS_COLETADAS += 1
		emit_signal("collected")

func _on_body_exited(body: Node2D) -> void:
	#$"../AnimationPlayer".play("win")
	pass

extends Node2D

@onready var anim = $AnimatedSprite2D
@export var pickable = true
@export var bird_id := 0

var animations = ["Blue", "Green", "Yellow", "LightBlue"]


func _ready() -> void:
	
	var a = randi_range(0, 3)
	anim.animation = animations[a]
	anim.play(animations[a])
	
	var dir = [-1, 1].pick_random()
	scale.x = dir


func _on_area_2d_body_entered(body: Node2D) -> void:
	if pickable:
		if not GameManager.birds_collected.has(bird_id):
			GameManager.birds_collected.append(bird_id)
		visible = false
		$AudioStreamPlayer2D.play()
		await $AudioStreamPlayer2D.finished
		GameManager.birds += 1
		queue_free()

extends Node2D

@onready var anim = $AnimatedSprite2D
@export var pickable = true
@export var bird_id := 0
@export var sleeping := false


var animations = ["Blue", "Green", "Yellow", "LightBlue", "Red"]


func _ready() -> void:
	
	if sleeping:
		var a = randi_range(0, 4)
		var animation = animations[a] + "Sleeping"
		anim.play(animation)
	else:
		var a = randi_range(0, 4)
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

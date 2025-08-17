extends Area2D
 
@export var phrases : PackedStringArray
var text_showing = false
var player_in_area = false
var last_phrase = ""

func _ready() -> void:
	
	$Sprite.scale = Vector2(0,0)


func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ActionE"):
		var bodies = get_overlapping_bodies()
		
		for body in bodies:
			if body.is_in_group("Player"):
				
				var i = randi_range(0, len(phrases) - 1)
				var frase = phrases[i]
				
				text_showing = true
				last_phrase = frase
				$Text.text = frase
				$TextAnim.play("Open")


func _on_body_entered(body: Node2D) -> void:
	$AnimationPlayer.play("Open")
	player_in_area = true


func _on_body_exited(body: Node2D) -> void:
	$AnimationPlayer.play("Close")
	if text_showing:
		$TextAnim.play("Close")
	
	player_in_area = false

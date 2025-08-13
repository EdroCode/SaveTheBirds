extends Node2D

@onready var positions = [$Birds/Marker2D, $Birds/Marker2D2, $Birds/Marker2D3, $Birds/Marker2D4, $Birds/Marker2D5, $Birds/Marker2D6, $Birds/Marker2D7, $Birds/Marker2D8]
@onready var bird = preload("res://Scenes/Addons/bird.tscn")


func _ready() -> void:
	
	if GameManager.in_painel:
		$Player.position  = Vector2(163, 39)
		GameManager.in_painel = false
	else:
		$Player.position = Vector2(34, 158)
		GameManager.in_painel = false
		
	
	
	var value = GameManager.birds
	
	
	for i in value:
		spawn_bird(positions[i])
	


func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ActionE"):
		if $Elementos2/Key.playerOnArea:
			get_tree().change_scene_to_file("res://Scenes/Addons/control_panel.tscn")
			
	
	

func spawn_bird(pos):
	
	var b = bird.instantiate()
	b.position = pos.global_position
	b.pickable = false
	call_deferred("add_child", b)


func change_scene(scene):
	if scene == "mesa":
		get_tree().change_scene_to_file("res://Scenes/mesa.tscn")



func _on_garagem_body_entered(body: Node2D) -> void:
	$DoorSound.play()
	$AnimationPlayer.play("EndGaragem")

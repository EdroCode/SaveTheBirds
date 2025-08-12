extends Node2D


@onready var caverna_botao = $CavernaButton
@onready var esgoto_botao = $EsgotoButton
@onready var cidade_botao = $CidadeButton


func _ready() -> void:
	
	
	
	esgoto_botao.disabled = false
	if GameManager.esgoto_finished:
		caverna_botao.disabled = false
		caverna_botao.modulate = Color(1, 1, 1)
		 
	else:
		caverna_botao.disabled = true
		caverna_botao.modulate = Color(0.37, 0.37, 0.37)
		cidade_botao.modulate = Color(0.37, 0.37, 0.37)
		
	
	if GameManager.caverna_finished:
		cidade_botao.disabled = false
		cidade_botao.modulate = Color(1, 1, 1)
	else:
		cidade_botao.disabled = true
		cidade_botao.modulate = Color(0.37, 0.37, 0.37)
		






func increase(goal):
	$AudioStreamPlayer2D.play()
	goal.scale += Vector2(0.2,0.2)


func decrease(goal):
	
	goal.scale -= Vector2(0.2,0.2)


func _on_sair_botao_button_down() -> void:
	
	change_scene("garagem")
	$AudioStreamPlayer2D.play()



func change_scene(scene):
	$AnimationPlayer.play("EndGaragem")
	
	var tim = Timer.new()
	tim.wait_time = 1
	add_child(tim)
	tim.start()
	await tim.timeout
	tim.stop()
	
	if scene == "garagem":
		get_tree().change_scene_to_file("res://Scenes/Levels/garagem.tscn")
	elif scene == "caverna":
		get_tree().change_scene_to_file("res://Scenes/Levels/caverna.tscn")
	elif scene == "esgoto":
		get_tree().change_scene_to_file("res://Scenes/Levels/Esgoto.tscn")
	elif scene == "cidade":
		get_tree().change_scene_to_file("res://Scenes/Levels/cidade.tscn")

func _on_caverna_button_button_down() -> void:
	change_scene("caverna")

func _on_esgoto_button_button_down() -> void:
	change_scene("esgoto")



func _on_cidade_button_button_down() -> void:
	change_scene("cidade")


func _on_caverna_button_mouse_entered() -> void:
	increase($CavernaButton)


func _on_esgoto_button_mouse_entered() -> void:
	increase($EsgotoButton)


func _on_cidade_button_mouse_entered() -> void:
	increase($CidadeButton)


func _on_caverna_button_mouse_exited() -> void:
	decrease($CavernaButton)


func _on_esgoto_button_mouse_exited() -> void:
	decrease($EsgotoButton)


func _on_cidade_button_mouse_exited() -> void:
	decrease($CidadeButton)

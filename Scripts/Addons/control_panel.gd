extends Node2D


func _on_icon_button_down() -> void:
	if check_cables() and check_pieces():
		get_tree().change_scene_to_file("res://Scenes/nave_gato.tscn")
	else:
		print("Erro")
	


func open():
	$AnimationPlayer.play("Open")


func close():
	$AnimationPlayer.play("Close")

func check_pieces():
	var a = 0
	
	for i in $PiecesConnect.get_children():
		if i.connected:
			a += 1
	
	if a == 3:
		return true
	else:
		print("Pieces Not Connected")
		print(a)
		return false

func check_cables():
	var a = 0
	
	for i in $Cables.get_children():
		if i.connected:
			a += 1
	
	if a == 4:
		return true
	else:
		print("Cables Not Connected")
		print(a)
		return false

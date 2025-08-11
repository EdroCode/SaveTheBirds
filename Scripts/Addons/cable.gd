extends Node2D


var can_select = true
var mouse_in_area = false
var selected = false
@export var ID := 0

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("Shot"):
		if can_select:
			if mouse_in_area:
				if !selected:
					selected = true
				else:
					selected = false
	
	if selected:
		position = get_global_mouse_position()
	
	pass




func _on_area_2d_mouse_entered() -> void:
	print("asss")
	mouse_in_area = true


func _on_area_2d_mouse_exited() -> void:
	mouse_in_area = false


func _on_connect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Connect"):
		if area.ID == ID:
			can_select = false
			selected = false
			print("connected")

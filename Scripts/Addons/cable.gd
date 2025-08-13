extends Node2D


var can_select = true
var mouse_in_area = false
var selected = false
@export var ID := 0

var connected = false


func _ready() -> void:
	
	pass

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("Shot"):
		if can_select:
			if mouse_in_area:
				if !selected:
					ClickSound.play()
					selected = true
				else:
					selected = false
	
	if selected:
		position = get_global_mouse_position()
	pass




func _on_area_2d_mouse_entered() -> void:
	mouse_in_area = true


func _on_area_2d_mouse_exited() -> void:
	mouse_in_area = false


func _on_connect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Connect"):
		if area.ID == ID:
			can_select = false
			selected = false
			connected = true
			$AudioStreamPlayer2D.play()
			if ID == 0:
				position = Vector2(109.0, 5)
			elif ID == 1:
				position = Vector2(106, 119)
			elif ID == 2:
				position = Vector2(107.0, 173.0)
			
			print("connected")

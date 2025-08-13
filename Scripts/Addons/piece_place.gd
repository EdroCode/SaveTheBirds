extends Area2D

@export var ID := 0
@export var image : Texture2D

@onready var gear = preload("res://Artwork/Sprites/Other/PEÇA01.png")
@onready var light = preload("res://Artwork/Sprites/Other/PEÇA02.png")
@onready var cabos = preload("res://Artwork/Sprites/Other/PEÇA03.png")

var can_select = true
var mouse_in_area = false
var selected = false

var connected = false

func _ready() -> void:
	
	if image:
		$Sprite.texture = image
	else:
		if ID == 0:
			$Sprite.texture = gear
		elif ID == 1:
			$Sprite.texture = light
		elif ID == 2:
			$Sprite.texture = cabos
			


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


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("ConnectPiece"):
		print("asdassd")
		if area.ID == ID:
			can_select = false
			selected = false
			print("l")
			$AudioStreamPlayer2D.play()
			position = area.global_position
			area.connected = true


func _on_mouse_entered() -> void:
	mouse_in_area = true


func _on_mouse_exited() -> void:
	mouse_in_area = false

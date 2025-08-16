extends Node2D

@export var sprite : Texture2D
@export var click_sprite : Texture2D


func _ready() -> void:
	
	if sprite:
		$Sprite2D.texture = sprite

func _process(delta: float) -> void:
	
	
	position = get_global_mouse_position()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		$Sprite2D.texture = click_sprite
	if Input.is_action_just_released("Shot"):
		$Sprite2D.texture = sprite
		

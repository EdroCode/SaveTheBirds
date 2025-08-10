extends Sprite2D


@onready var nave_1 = preload("res://Artwork/Sprites/Esgoto/Arma01.png")
@onready var nave_2 = preload("res://Artwork/Sprites/Esgoto/Arma02.png")
@onready var nave_3 = preload("res://Artwork/Sprites/Esgoto/Arma03.png")
@onready var nave_4 = preload("res://Artwork/Sprites/Esgoto/ArmaCompleta.png")

@onready var drill_sound = preload("res://Resources/SFX/machineDrill.wav")
@onready var complete_sound = preload("res://Resources/SFX/completed.wav")

func _ready() -> void:
	
	var pecas = GameManager.PECAS_COLETADAS
	
	if pecas == 0:
		turn_effect_off()
		texture = nave_1
		$AudioStreamPlayer2D.stream = drill_sound
		$PointLight2D.energy = 0
		$PointLight2D2.energy = 0
		$PointLight2D3.energy = 0
		$PointLight2D4.energy = 0
	if pecas == 1:
		$AudioStreamPlayer2D.stream = drill_sound
		$AnimationPlayer.play("new_animation")
		$AudioStreamPlayer2D.play()
		texture = nave_2
		$PointLight2D.energy = 0.0
		$PointLight2D2.energy = 0.0
		$PointLight2D3.energy = 0.0
		$PointLight2D4.energy = 0.0
	if pecas == 2:
		$AudioStreamPlayer2D.stream = drill_sound
		$AnimationPlayer.play("new_animation")
		texture = nave_3
		$AudioStreamPlayer2D.play()
		$PointLight2D.energy = 0.8
		$PointLight2D2.energy = 0.8
		$PointLight2D3.energy = 0.8
		$PointLight2D4.energy = 0.8
	if pecas == 3:
		$AudioStreamPlayer2D.stream = complete_sound
		$AnimationPlayer.play("new_animation")
		texture = nave_4
		$AudioStreamPlayer2D.play()
		$PointLight2D.energy = 0.8
		$PointLight2D2.energy = 0.8
		$PointLight2D3.energy = 0.8
		$PointLight2D4.energy = 0.8


func turn_effect_on():
	
	material.set_shader_parameter("effect_enabled", true)  


func turn_effect_off():
	material.set_shader_parameter("effect_enabled", false)

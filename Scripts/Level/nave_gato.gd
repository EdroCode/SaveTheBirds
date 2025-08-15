extends Node2D


@onready var bird = preload("res://Scenes/Addons/bird.tscn")
@onready var positions = [$Birds/Marker2D, $Birds/Marker2D2, $Birds/Marker2D3, $Birds/Marker2D4, $Birds/Marker2D5, $Birds/Marker2D6, $Birds/Marker2D7, $Birds/Marker2D8, $Birds/Marker2D9, $Birds/Marker2D10]

	
	
func _ready() -> void:
	var value = GameManager.birds
	
	for i in value:
		spawn_bird(positions[i])
	   # Configure noise
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.8   # lower = slower shake movement

func spawn_bird(pos):
	
	var b = bird.instantiate()
	b.position = pos.global_position
	b.sleeping = true
	b.pickable = false
	call_deferred("add_child", b)



@onready var cam: Camera2D = $Camera2D

var noise := FastNoiseLite.new()
var noise_time := 0.0

var shake_intensity := 0.0
var shake_duration := 0.0
var shake_decay := 1.0


func _process(delta: float) -> void:
	if shake_duration > 0:
		shake_duration -= delta
		noise_time += delta * 60.0  # how quickly we move through noise space

		var offset_x = noise.get_noise_2d(noise_time, 0.0) * shake_intensity
		var offset_y = noise.get_noise_2d(0.0, noise_time + 100.0) * shake_intensity

		cam.offset = Vector2(offset_x, offset_y)

		# fade out shake
		shake_intensity = max(shake_intensity - shake_decay * delta, 0)
	else:
		cam.offset = Vector2.ZERO
	
	if Input.is_action_just_pressed("ActionE"):
		
		if $Key:
			if $Key.playerOnArea:
			
				$AnimationPlayer2.play("EndCutscene")

# Call from AnimationPlayer or code
func start_shake(intensity: float, duration: float) -> void:
	shake_intensity = intensity
	shake_duration = duration
	shake_decay = intensity / duration


func change_scene():
	
	get_tree().change_scene_to_file("res://Scenes/Levels/end_cutscene.tscn")

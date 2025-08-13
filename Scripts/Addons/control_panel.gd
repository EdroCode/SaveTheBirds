extends Node2D

@onready var Item = preload("res://Scenes/Addons/piece_place.tscn")
@onready var bola_off = preload("res://Artwork/Sprites/PainelControlo/boladesligado.png")
@onready var bola_on = preload("res://Artwork/Sprites/PainelControlo/bolaverde.png")
@onready var bola_error = preload("res://Artwork/Sprites/PainelControlo/bolavermelha.png")





func _on_icon_button_down() -> void:
	
	$Icon.disabled = true
	if check_cables() and check_pieces():
		#get_tree().paused = false
		$ToggleSound.play()
		$BleepSound.play()
		var tim = Timer.new()
		tim.wait_time = 0.2
		add_child(tim)
		tim.start()
		await tim.timeout
		tim.stop()
		$Boladesligado.texture = bola_on
		tim.start()
		await tim.timeout
		tim.stop()
		$Boladesligado2.texture = bola_on
		tim.start()
		await tim.timeout
		tim.stop()
		$Boladesligado3.texture = bola_on
		tim.wait_time = 1
		tim.start()
		await tim.timeout
		tim.stop()
		tim.queue_free()
		
		get_tree().change_scene_to_file("res://Scenes/nave_gato.tscn")
	else:
		$ErroSound.play()
		$Boladesligado.texture = bola_error
		$Boladesligado2.texture = bola_error
		$Boladesligado3.texture = bola_error
		var tim = Timer.new()
		tim.wait_time = 1
		add_child(tim)
		tim.start()
		await tim.timeout
		tim.stop()
		tim.queue_free()
		get_tree().change_scene_to_file("res://Scenes/Levels/garagem.tscn")
	

func _ready() -> void:
	open()
	GameManager.in_painel = true
	add_pieces()

func open():
	pass
	#$AnimationPlayer.play("Open")
	#get_tree().paused = true


func close():
	pass
	#$AnimationPlayer.play("Close")

func add_pieces():
	var positions = [$Marker2D, $Marker2D2, $Marker2D3]
	var total = GameManager.PECAS_COLETADAS
	
	print("add started")
	for i in range(min(total, positions.size())):
		var random_index = randi_range(0, positions.size() - 1)
		var pos = positions[random_index]
		add_gear(pos, i)
		positions.remove_at(random_index)


func add_gear(pos, id):
	print("a")
	var g = Item.instantiate()
	g.position = pos.global_position
	g.ID = id
	$Pieces.add_child(g)

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
	
	if a == 3:
		return true
	else:
		print("Cables Not Connected")
		print(a)
		return false


func _on_sair_botao_button_down() -> void:
	ClickSound.play()
	#get_tree().paused = false
	close()
	get_tree().change_scene_to_file("res://Scenes/Levels/garagem.tscn")

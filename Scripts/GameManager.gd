extends Node

var birds := 0
var PECAS_COLETADAS := 0

var esgoto_finished := false
var caverna_finished := false
var cidade_finished := false

var birds_collected = []

var music_volume : float
var sfx_volume : float


func _ready() -> void:
	
	music_volume = 1.5
	sfx_volume = 1.5

func _process(delta: float) -> void:
	
	if PECAS_COLETADAS > 3:
		PECAS_COLETADAS = 3

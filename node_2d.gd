extends Node2D

var speed = 600.0 # Rychlost chůze (můžeš upravit)
var direction = Vector2(1, 0) # 1,0 je doprava, -1,0 je doleva

func _physics_process(delta: float) -> void:
	# Zjistíme aktuální pozici okna na obrazovce
	var window_position = Vector2(DisplayServer.window_get_position())
	
	# Zjistíme rozlišení tvého monitoru
	var screen_size = DisplayServer.screen_get_size()
	var window_size = Vector2(DisplayServer.window_get_size())
	
	# Posuneme okno podle směru
	window_position += direction * speed * delta
	
	# --- LOGIKA ODRÁŽENÍ OD OKRAJŮ ---
	
	# Pokud okno dojede k PRAVÉMU okraji, otočíme ho doleva (-1, 0)
	if window_position.x >= (screen_size.x - window_size.x):
		direction = Vector2(-1, 0)
		# Zde můžeme později přidat animaci otočení doleva
		
	# Pokud okno dojede k LEVÉMU okraji, otočíme ho doprava (1, 0)
	elif window_position.x <= 0:
		direction = Vector2(1, 0)
		# Zde můžeme později přidat animaci otočení doprava

	# Aplikujeme novou pozici na okno
	DisplayServer.window_set_position(Vector2i(window_position))

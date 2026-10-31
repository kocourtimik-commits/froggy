extends Node2D

var speed = 400.0
var direction = Vector2(1, 0) # 1 = doprava, -1 = doleva

enum State { JUMPING, PAUSED }
var current_state = State.JUMPING

@onready var anim = $AnimatedSprite2D
@onready var pause_timer = Timer.new()
@onready var move_timer = Timer.new()

func _ready():
	print(">>> Hra spuštěna, _ready běží!")
	
	# Časovač pro délku pauzy (zkráceno na 3 sekundy pro rychlý test)
	add_child(pause_timer)
	pause_timer.one_shot = true
	pause_timer.timeout.connect(_on_pause_timeout)
	
	# Časovač pro délku chůze (zkráceno na 3 sekundy pro rychlý test)
	add_child(move_timer)
	move_timer.one_shot = true
	move_timer.timeout.connect(_on_move_timeout)
	
	place_at_bottom()
	start_moving_phase()

func place_at_bottom():
	var screen_size = DisplayServer.screen_get_size()
	var window_size = Vector2(DisplayServer.window_get_size())
	var window_position = Vector2(DisplayServer.window_get_position())
	window_position.y = screen_size.y - window_size.y - 80
	DisplayServer.window_set_position(Vector2i(window_position))
	print(">>> Startovní pozice okna nastavena na Y: ", window_position.y)

func _physics_process(delta: float) -> void:
	# Vypíše do konzole, zda se proces provádí
	print(">>> _physics_process běží | Stav: ", current_state, " | Pozice X: ", DisplayServer.window_get_position().x)

	if current_state == State.PAUSED:
		return # Pokud žába stojí, nic neděláme

	var window_position = Vector2(DisplayServer.window_get_position())
	var screen_size = DisplayServer.screen_get_size()
	var window_size = Vector2(DisplayServer.window_get_size())

	# Posun okna
	window_position += direction * speed * delta

	# Odrážení od bočních okrajů
	if window_position.x >= (screen_size.x - window_size.x):
		direction = Vector2(-1, 0)
		update_animation()
	elif window_position.x <= 0:
		direction = Vector2(1, 0)
		update_animation()

	DisplayServer.window_set_position(Vector2i(window_position))

func update_animation():
	var jump_anim = "skok_r" if direction.x > 0 else "skok_l"
	if anim.sprite_frames.has_animation(jump_anim):
		anim.play(jump_anim)

func start_moving_phase():
	current_state = State.JUMPING
	update_animation()
	move_timer.start(3.0) # Pohyb 3 sekundy
	print(">>> Začíná pohyb")

func _on_move_timeout():
	current_state = State.PAUSED
	var idle_anim = "idle_r" if direction.x > 0 else "idle_l"
	if anim.sprite_frames.has_animation(idle_anim):
		anim.play(idle_anim)
	pause_timer.start(3.0) # Pauza 3 sekundy
	print(">>> Žába zastavila (pauza)")

func _on_pause_timeout():
	start_moving_phase()

func play_jump():
	var jump_anim = "skok_r" if direction.x > 0 else "skok_l"
	if anim.sprite_frames.has_animation(jump_anim):
		anim.play(jump_anim)

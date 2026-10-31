extends Area2D

# Odkaz na hlavní uzel (Node2D), kde je umístěna logika pohybu a animací
@onready var main_node = $".."

func _ready():
	# Propojení signálu pro kliknutí myší
	input_event.connect(_on_input_event)

func _on_input_event(_viewport, event, _shape_idx):
	# Kontrola, zda jde o kliknutí levým tlačítkem myši
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Zavolá funkci pro skok v hlavním skriptu
		main_node.play_jump()
		

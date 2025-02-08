extends Node



@export var pipe_scene : PackedScene

@export var score_scene : PackedScene

var hight_score = 0
var game_running:bool
var game_over : bool
var game_end : bool
var scroll
var score 
var actual_score
const SCROLL_SPEED : int = 5 
var screen_size : Vector2i
var ground_height : int 
var pipes : Array
var bottlesArray : Array 


const PIPE_DELAY : int = 100
const PIPE_RANGE : int = 200	
const PIPE_GAP_RANGE = 150  # Rango de separación aleatoria entre los tubos
const BOTTLE_OFFSET_Y = 100  # Desplazamiento vertical adicional para las botellas
const BOTTLE_OFFSET_X = 50   # Desplazamiento horizontal adicional
var NUMBER_OF_PIPES = 2  # Cambia este valor para generar más o menos tubos



 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	screen_size = Vector2(864, 936)
	#screen_size = get_window().size
	ground_height = $Piso.get_node("Sprite2D").texture.get_height()
	hight_score = $SaveSistem.load()
	print(hight_score)
	new_game()
	
	
	
func new_game():
	$Mouse.show()
	$Player/salud_componentes.salud_actual =  110.0 
	$Player/salud_componentes.salud_maxima =  100.0 
	game_running = false 
	game_over = false
	score = 0 
	scroll = 0
	actual_score = 0 
	NUMBER_OF_PIPES = 2
	$GameOver.hide()
	get_tree().call_group("pipes", "queue_free")
	get_tree().call_group("bottlesArray", "queue_free")
	pipes.clear()
	bottlesArray.clear()
	$ScoreLabel.text = "SCORE:" + str(score)
	generate_pipes()
	$Player.reset()
	$PipeTimer.start()
	$SaludTimer.start()

func _input(event):
	if game_over == false:
			if event is InputEventMouseButton and event.pressed:
				if game_running == false:
					start_game(0)
				else:
					if $Player.flying:
						if event.button_index == MOUSE_BUTTON_LEFT:
							$Player.flap(-1)  # Impulso a la derecha
							check_top()
						elif event.button_index == MOUSE_BUTTON_RIGHT:
							$Player.flap(1) # Impulso a la izquierda
							check_top()
			if event is InputEventScreenTouch and event.pressed:
				var touch_x = event.position.x  # Coordenada X del toque
				var screen_width = get_viewport().size.x  # Ancho de la pantalla
				if game_running == false:
					start_game(0)
				else:
					if $Player.flying:
						if touch_x < screen_width / 2:
							$Player.flap(-1)  # Impulso a la derecha
							check_top()
						elif touch_x >= screen_width / 2:
							$Player.flap(1) # Impulso a la izquierda
							check_top()
		

		
func start_game(pressedButton):
	game_running = true
	$Player.flying = true
	$Player.flap(pressedButton)
	$PipeTimer.start()
	$SaludTimer.start()
	$Mouse.hide()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_running:
		scroll += SCROLL_SPEED
		if scroll >= screen_size.y:
			scroll = 0 
		$Piso.position.y = scroll
		for pipe in pipes:
			pipe.position.y += SCROLL_SPEED
		for bottle in bottlesArray:
			if is_instance_valid(bottle): 
				bottle.position.y += SCROLL_SPEED
			else:
				bottlesArray.erase(bottle)  
			
func scored():
	$take_obj.play()
	score +=1
	actual_score += 1
	if  $Player/salud_componentes.salud_actual >= 100.0: 
		pass
	else:
		if  $Player/salud_componentes.salud_actual <= 40.0:
			$Player/salud_componentes.salud_actual +=  40.0
		else:
			$Player/salud_componentes.salud_actual +=  10.0
	$ScoreLabel.text = "SCORE:" + str(score)

func _on_pipe_timer_timeout() -> void:
	generate_pipes()
	

func generate_pipes():
	if game_running:
		var previous_pipe = null  # Guarda el último tubo creado para calcular la separación
		var pipes_group = []  # Lista para almacenar los tubos generados
		if actual_score >= 15:
			NUMBER_OF_PIPES += 1
			actual_score = 0
		for i in range(NUMBER_OF_PIPES):
				var pipe = pipe_scene.instantiate()
				pipe.position.x = (screen_size.x / 2) + randi_range(-PIPE_RANGE, PIPE_RANGE)
				if previous_pipe:
					var gap = randi_range(PIPE_GAP_RANGE, PIPE_GAP_RANGE * 2)
					pipe.position.y = previous_pipe.position.y - gap  # Ajusta la posición con separación aleatoria
				else:
					pipe.position.y = -PIPE_DELAY  # Primer tubo empieza fuera de la pantalla

				pipe.hit.connect(player_hit)
				add_child(pipe)
				pipes.append(pipe)
				pipes_group.append(pipe)
				previous_pipe = pipe  # Guarda el tubo actual como referencia para el siguiente
		# Generar múltiples botellas según el número de tubos
		for i in range(NUMBER_OF_PIPES - 1):  # Se generan entre los tubos
			var bottle = score_scene.instantiate()
			
			# Ubicar la botella en el punto medio entre dos tubos consecutivos
			bottle.position.y = (pipes_group[i].position.y + pipes_group[i + 1].position.y) / 2 + BOTTLE_OFFSET_Y
			bottle.position.x = (screen_size.x / 2) + randi_range(-PIPE_RANGE, PIPE_RANGE) + BOTTLE_OFFSET_X

			bottle.scored.connect(scored)
			add_child(bottle)
			bottlesArray.append(bottle)
 
func check_top():
	if $Player.position.y < 0:
		$Player.falling = true
		stop_game()
		
func stop_game():
	if score >= hight_score:
		hight_score = score
		$SaveSistem.save(hight_score)
	var label = $GameOver.get_node("final_score")
	$muelto.play()
	$PipeTimer.stop()
	$SaludTimer.stop()
	label.text = "High score:" + str(hight_score)
	$GameOver.show()
	$Player.flying = false
	game_running = false
	game_over = true
	
func player_hit():
	$Player.falling = true
	if game_over == false:
		stop_game()


func _on_piso_hit() -> void:
	$Player.falling = true
	if game_over == false:
		stop_game()

func _on_abajo_hit() -> void:
	
	$Player.falling = true
	if game_over == false:
		stop_game()

func _on_game_over_restart() -> void:
	new_game()


func _on_salud_timer_timeout() -> void:
	if game_running == true:
		$Player/salud_componentes.recibir_damage(5)
		if $Player/salud_componentes.salud_actual <=  0.0:
			$Player.falling = true
			stop_game()

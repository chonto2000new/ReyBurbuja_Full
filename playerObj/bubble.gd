extends CharacterBody2D

const JUMP_VELOCITY = -400.0
const GRAVITY : int = 1000
const MAX_VEL : int = 700
const FLAP_SPEED: int = -300
const FLAP_X_SPEED: int = 200  # Impulso horizontal inicial
const FRICTION: float = 300.0 # Reducción progresiva del impulso en X

var flying : bool = false
var falling : bool = false 
const START_POS = Vector2(400, 500)
const MAX_UP_ROTATION = deg_to_rad(-30)  # Inclina hacia arriba
const MAX_DOWN_ROTATION = deg_to_rad(90) # Rotación máxima hacia abajo


func _ready():
	reset()

func reset():
	falling = false
	flying = false
	velocity = Vector2.ZERO
	position = START_POS
	set_rotation(0)
	
func _physics_process(delta):
	if flying or falling:
		# Aplicar gravedad
		velocity.y += GRAVITY * delta
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL

		# Reducir velocidad en X gradualmente
		if velocity.x > 0:
			velocity.x -= FRICTION * delta
			if velocity.x < 0:
				velocity.x = 0 # Evitar que vaya hacia atrás

		## Rotación del personaje según velocidad
		#if flying:
			## Inclinar ligeramente hacia arriba
			#var tilt = velocity.y * 0.05
			#tilt = clamp(tilt, MAX_UP_ROTATION, 0)  # Solo hacia arriba
			#set_rotation(tilt)
		#elif falling:
			## Cuando cae, rota hacia abajo completamente
			#set_rotation(MAX_DOWN_ROTATION)
		if falling:
			set_rotation(MAX_DOWN_ROTATION)

		move_and_collide(velocity * delta)

	else: 
		$AnimatedSprite2D.stop()
		
const FLAP_TILT = deg_to_rad(25) # cuánto se inclina al volar

func flap(direction: int):
	$AudioStreamPlayer.play()
	$AnimatedSprite2D.play("flying")
	velocity.y = FLAP_SPEED
	velocity.x = FLAP_X_SPEED * direction * 2
	flying = true

	# Rotación leve hacia la dirección del impulso
	set_rotation(FLAP_TILT * direction)

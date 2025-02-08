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

		# Rotación del personaje según velocidad
		if flying:
			set_rotation(deg_to_rad(velocity.y * 0.05))
			$AnimatedSprite2D.play("flying")
		elif falling : 
			set_rotation(PI/2)
			$AnimatedSprite2D.stop()

		move_and_collide(velocity * delta)
	else: 
		$AnimatedSprite2D.stop()
		
func flap(direction: int):
	$AudioStreamPlayer.play()
	velocity.y = FLAP_SPEED
	velocity.x = FLAP_X_SPEED * direction * 2 # Aumentamos el impulso un 20%
	flying = true

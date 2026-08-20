class_name Player
extends CharacterBody2D


@export var speed = 300.0
@export var jump_velocity = -400.0

@onready var sprite: AnimatedSprite2D = %Sprite


func _physics_process(delta: float) -> void:
	# Ajout de la gravité
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Gestion du saut
	if Input.is_action_just_pressed(&"player_mov_jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# Récupère la direction de déplacement puis modifie la vélocité horizontale
	var direction := Input.get_axis(&"player_mov_left", &"player_mov_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	# Fonction du CharacterBody2D pour calculer la physique de déplacement
	move_and_slide()
	
	# Gestion des animations
	_change_animation()


func _change_animation() -> void:
	# Si le joueur est dans les airs
	if not is_on_floor():
		sprite.play(&"jump")
	# Si le joueur se déplace horizontalement
	elif abs(velocity.x) > 0.0:
		sprite.play(&"walk")
	# Si le joueur est immobile, au sol
	else:
		sprite.play(&"idle")

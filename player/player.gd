class_name Player
extends CharacterBody2D


@export var speed = 150.0
@export var jump_velocity = -330.0

var dead: bool = false

@onready var sprite: AnimatedSprite2D = %Sprite


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


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
		velocity.x = move_toward(velocity.x, direction * speed, speed)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	# Fonction du CharacterBody2D pour calculer la physique de déplacement
	move_and_slide()
	
	# Gestion des animations
	_change_animation()


func _handle_jump(can_move: bool) -> void:
	if not can_move: return
	
	# Start jumping
	if Input.is_action_just_pressed(&"player_mov_jump") and is_on_floor():
		velocity.y = jump_velocity
	# Cancel Jump
	elif velocity.y < 0.0 and not Input.is_action_pressed(&"player_mov_jump") and not is_on_floor():
		velocity.y = move_toward(velocity.y, 0.0, 100.0)


func _change_animation() -> void:
	# Si le joueur est mort
	if dead:
		sprite.play(&"die")
		return
	
	# Si le joueur est dans les airs
	if not is_on_floor():
		sprite.play(&"jump")
	# Si le joueur se déplace horizontalement
	elif abs(velocity.x) > 0.0:
		sprite.play(&"walk")
	# Si le joueur est immobile, au sol
	else:
		sprite.play(&"idle")
	
	# Retourner le sprite selon la direction de déplacement
	if abs(velocity.x) > 0.0:
		sprite.flip_h = velocity.x < 0.0


func die() -> void:
	if dead: return
	velocity.y = -100.0
	dead = true
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()

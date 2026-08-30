class_name Player
extends CharacterBody2D


static var reference: Player
static var key_amount: int = 0:
	set(value):
		key_amount = value
		reference._update_keys()
static var coin_amount: int = 0:
	set(value):
		coin_amount = value
		reference._update_coins()


const EMERALD_SPRITE = preload("res://assets/textures/emerald.tres")
const COIN_SPRITE = preload("res://assets/textures/coin.tres")
const KEY = preload("res://assets/textures/key.tres")
const ITEMS: Dictionary[String, Dictionary] = {
	"emerald": {
		"texture": EMERALD_SPRITE,
		"coin_amount": 10,
	},
	"coin": {
		"texture": COIN_SPRITE,
		"coin_amount": 1,
	},
	"key": {
		"texture": KEY,
	}
}


@export var speed = 150.0
@export var jump_velocity = -330.0
@export var acceleration_speed_mult = 1
@export var deceleration_speed_mult = 1


var dead: bool = false
var in_animation: bool = false


@onready var sprite: AnimatedSprite2D = %Sprite
@onready var item_sprite: Sprite2D = %ItemSprite
@onready var coin_amount_label: Label = %CoinAmount
@onready var key_amount_label: Label = %KeyAmount
@onready var coin_texture: TextureRect = %CoinTexture
@onready var key_texture: TextureRect = %KeyTexture


func _enter_tree() -> void:
	reference = self


func _ready() -> void:
	_update_coins()
	_update_keys()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	# Ajout de la gravité
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var can_move: bool = not dead and not SceneManager.in_transition and not in_animation
	
	# Gestion du saut
	_handle_jump(can_move)
	
	# Récupère la direction de déplacement puis modifie la vélocité horizontale
	var direction := Input.get_axis(&"player_mov_left", &"player_mov_right")
	if direction and can_move:
		velocity.x = move_toward(velocity.x, direction * speed, speed * acceleration_speed_mult)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * deceleration_speed_mult)
	
	# Fonction du CharacterBody2D pour calculer la physique de déplacement
	move_and_slide()
	
	# Gestion des animations
	_change_animation()


func _handle_jump(can_move: bool) -> void:
	if not can_move: return
	
	# Jump through floor
	if ( Input.is_action_pressed(&"player_mov_down") and
	Input.is_action_just_pressed(&"player_mov_jump") and
	is_on_floor() ):
		position.y += 1.0
	# Start jumping
	elif Input.is_action_just_pressed(&"player_mov_jump") and is_on_floor():
		velocity.y = jump_velocity
	# Cancel Jump
	elif velocity.y < 0.0 and not Input.is_action_pressed(&"player_mov_jump") and not is_on_floor():
		velocity.y = move_toward(velocity.y, 0.0, 100.0)


func _change_animation() -> void:
	if in_animation: return
	
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


func _update_coins() -> void:
	var change_label_text = func(new_value: int) -> void:
		coin_amount_label.text = "%03d" % new_value
	
	var previous_coin_amount: int = int(coin_amount_label.text)
	if coin_amount_label:
		var tween: Tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_method(change_label_text, previous_coin_amount, coin_amount, 0.5)


func _update_keys() -> void:
	if key_amount_label:
		key_amount_label.text = "%d" % key_amount
		key_amount_label.visible = key_amount > 1
		key_texture.visible = key_amount > 0


func die() -> void:
	if dead: return
	velocity.y = -100.0
	dead = true
	await get_tree().create_timer(1.0).timeout
	SceneManager.reload_current_scene()


func gain_item(item_name: String) -> void:
	in_animation = true
	sprite.play(&"win")
	item_sprite.texture = ITEMS[item_name].texture
	if item_name in ["emerald", "coin"]:
		coin_amount += ITEMS[item_name].coin_amount
	elif item_name == "key":
		key_amount += 1
	await get_tree().create_timer(1.0).timeout
	item_sprite.texture = null
	in_animation = false


func pick_up_item(item_name: String) -> void:
	if item_name in ["emerald", "coin"]:
		coin_amount += ITEMS[item_name].coin_amount
	elif item_name == "key":
		key_amount += 1

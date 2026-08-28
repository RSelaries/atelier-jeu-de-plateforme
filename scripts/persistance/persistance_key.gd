class_name PersistanceKey
extends Node


enum KeyType { COLLECTIBLE }


@export var persistant_var_name: StringName
@export var key_type: KeyType


@onready var persistant_object: Node = get_parent()


func _ready() -> void:
	load_persistance_key()


func _exit_tree() -> void:
	save_persistance_key()


func load_persistance_key() -> void:
	match key_type:
		KeyType.COLLECTIBLE:
			if PersistanceManager.collectibles.has(get_path()) and persistant_var_name in persistant_object:
				var persistance_key: Variant = PersistanceManager.collectibles[get_path()]
				persistant_object.set(persistant_var_name, persistance_key)
		_:
			if PersistanceManager.others.has(get_path()) and persistant_var_name in persistant_object:
				var persistance_key: Variant = PersistanceManager.others[get_path()]
				persistant_object.set(persistant_var_name, persistance_key)


func save_persistance_key() -> void:
	match key_type:
		KeyType.COLLECTIBLE:
			PersistanceManager.collectibles[get_path()] = persistant_object.get(persistant_var_name)
		_:
			PersistanceManager.others[get_path()] = persistant_object.get(persistant_var_name)

extends Resource
class_name Encaixe

@export var peca_no_encaixe: int = 0
@export var peso_encaixe: int

func _init(new_pne: int, new_pe: int) -> void:
	peca_no_encaixe = new_pne
	peso_encaixe = new_pe

func _ready():
	pass

extends Button
class_name Botao
@export var button_id: int

signal botao_jogada_apertado(id: int)

func _ready() -> void:
	pressed.connect(botao_jogada_apertado.emit.bind(button_id))
	
func emit_pressed() -> void:
	botao_jogada_apertado.emit(button_id)

extends Resource
class_name Jogada

var coluna: int
var avaliacao: float

func _init(col: int, ava: float):
	self.coluna = col
	self.avaliacao = ava

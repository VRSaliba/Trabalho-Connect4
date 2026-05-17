extends Resource
class_name Tabuleiro

var encaixes = [
					[0, 0, 0, 0, 0, 0],
					[0, 0, 0, 0, 0, 0],
					[0, 0, 0, 0, 0, 0],
					[0, 0, 0, 0, 0, 0],
					[0, 0, 0, 0, 0, 0],
					[0, 0, 0, 0, 0, 0],
					[0, 0, 0, 0, 0, 0]
				]

var peso_encaixes = [
						[3, 4, 5, 5, 4, 3],
						[4, 6, 8, 8, 6, 4],
						[5, 8, 11, 11, 8, 5],
						[7, 10, 13, 13, 10, 7],
						[5, 8, 11, 11, 8, 5],
						[4, 6, 8, 8, 6, 4],
						[3, 4, 5, 5, 4, 3]
					]

var profundidade_maxima: int
var profundidade_atual: int = 0
var jogador: int

var qtd_jogadas: int = 0

func _init():
	jogador = 1

func troca_jogador() -> void:
	jogador = -jogador

func empate() -> bool:
	for coluna in range(7):
		if encaixes[coluna][5] == 0:
			return false
	return true

func verifica_empate() -> bool:
	var colunas_cheias: int = 0
	for coluna in range(7):
		if encaixes[coluna][5] != 0:
			colunas_cheias += 1
		else:
			return false
	if colunas_cheias == 7:
		return true
	else:
		return false

func coloca_peca(coluna: int) -> bool:
	for linha in encaixes[coluna].size():
		if encaixes[coluna][linha] == 0:
			encaixes[coluna][linha] = jogador
			return true
	print("Jogada inválida! Tente outra posição!")
	return false

func acha_linha_jogada(coluna: int):
	for linha in encaixes[coluna].size():
		if encaixes[coluna][5 - linha] != 0:
			return linha
	return 0

func acha_peso_encaixe(coluna: int, linha: int):
	return peso_encaixes[coluna][linha]

func avalia_fim_de_jogo_facil() -> float:
	# retornar +1 ou -1 dependendo do jogador que esta vencendo no tabuleiro
	var vitoria_max = 1000
	var vitoria_min = -1000
	
	# Vitoria vertical (|)
	for coluna in range(7):
		for linha in range(3):
			if encaixes[coluna][linha] == encaixes[coluna][linha + 1] and encaixes[coluna][linha + 1] == encaixes[coluna][linha + 2] and encaixes[coluna][linha + 2] == encaixes[coluna][linha + 3] and encaixes[coluna][linha] != 0:
				if encaixes[coluna][linha] == 1:
					return vitoria_max - qtd_jogadas
				else:
					return vitoria_min + qtd_jogadas
	# Vitoria Horizontal (-)
	for coluna in range(4):
		for linha in range(6):
			if encaixes[coluna][linha] == encaixes[coluna + 1][linha] and encaixes[coluna + 1][linha] == encaixes[coluna + 2][linha] and encaixes[coluna + 2][linha] == encaixes[coluna + 3][linha] and encaixes[coluna][linha] != 0:
				if encaixes[coluna][linha] == 1:
					return vitoria_max - qtd_jogadas
				else:
					return vitoria_min + qtd_jogadas
	# Vitoria diagonal (\)
	for coluna in range(4):
		for linha in range(3):
			if encaixes[coluna][5 - linha] == encaixes[coluna + 1][5 - linha - 1] and encaixes[coluna + 1][5 - linha - 1] == encaixes[coluna + 2][5 - linha - 2] and encaixes[coluna + 2][5 - linha - 2] == encaixes[coluna + 3][5 - linha - 3] and encaixes[coluna][5 - linha] != 0:
				if encaixes[coluna][5 - linha] == 1:
					return vitoria_max - qtd_jogadas
				else:
					return vitoria_min + qtd_jogadas
	# Vitoria diagonal (/)
	for coluna in range(4):
		for linha in range(3):
			if encaixes[6 - coluna][5 - linha] == encaixes[6 - coluna - 1][5 - linha - 1] and encaixes[6 - coluna - 1][5 - linha - 1] == encaixes[6 - coluna - 2][5 - linha - 2] and encaixes[6 - coluna - 2][5 - linha - 2] == encaixes[6 - coluna - 3][5 - linha - 3] and encaixes[6 - coluna][5 - linha] != 0:
				if encaixes[6 - coluna][5 - linha] == 1:
					return vitoria_max - qtd_jogadas
				else:
					return vitoria_min + qtd_jogadas
	return 0.5

func avalia_fim_de_jogo_medio(jogador_original: int) -> float:
	# retornar +1 ou -1 dependendo do jogador que esta vencendo no tabuleiro
	var vitoria = 10000
	var derrota = 1000
	
	if jogador_original == 1:
		# Vitoria vertical (|)
		for coluna in range(7):
			for linha in range(3):
				if encaixes[coluna][linha] == encaixes[coluna][linha + 1] and encaixes[coluna][linha + 1] == encaixes[coluna][linha + 2] and encaixes[coluna][linha + 2] == encaixes[coluna][linha + 3] and encaixes[coluna][linha] != 0:
					if encaixes[coluna][linha] == 1:
						return vitoria - qtd_jogadas
					else:
						return -(derrota - qtd_jogadas)
		# Vitoria Horizontal (-)
		for coluna in range(4):
			for linha in range(6):
				if encaixes[coluna][linha] == encaixes[coluna + 1][linha] and encaixes[coluna + 1][linha] == encaixes[coluna + 2][linha] and encaixes[coluna + 2][linha] == encaixes[coluna + 3][linha] and encaixes[coluna][linha] != 0:
					if encaixes[coluna][linha] == 1:
						return vitoria - qtd_jogadas
					else:
						return -(derrota - qtd_jogadas)
		# Vitoria diagonal (\)
		for coluna in range(4):
			for linha in range(3):
				if encaixes[coluna][5 - linha] == encaixes[coluna + 1][5 - linha - 1] and encaixes[coluna + 1][5 - linha - 1] == encaixes[coluna + 2][5 - linha - 2] and encaixes[coluna + 2][5 - linha - 2] == encaixes[coluna + 3][5 - linha - 3] and encaixes[coluna][5 - linha] != 0:
					if encaixes[coluna][5 - linha] == 1:
						return vitoria - qtd_jogadas
					else:
						return -(derrota - qtd_jogadas)
		# Vitoria diagonal (/)
		for coluna in range(4):
			for linha in range(3):
				if encaixes[6 - coluna][5 - linha] == encaixes[6 - coluna - 1][5 - linha - 1] and encaixes[6 - coluna - 1][5 - linha - 1] == encaixes[6 - coluna - 2][5 - linha - 2] and encaixes[6 - coluna - 2][5 - linha - 2] == encaixes[6 - coluna - 3][5 - linha - 3] and encaixes[6 - coluna][5 - linha] != 0:
					if encaixes[6 - coluna][5 - linha] == 1:
						return vitoria - qtd_jogadas
					else:
						return -(derrota - qtd_jogadas)
	else:
		# Vitoria vertical (|)
		for coluna in range(7):
			for linha in range(3):
				if encaixes[coluna][linha] == encaixes[coluna][linha + 1] and encaixes[coluna][linha + 1] == encaixes[coluna][linha + 2] and encaixes[coluna][linha + 2] == encaixes[coluna][linha + 3] and encaixes[coluna][linha] != 0:
					if encaixes[coluna][linha] == -1:
						return -(vitoria + qtd_jogadas)
					else:
						return derrota + qtd_jogadas
		# Vitoria Horizontal (-)
		for coluna in range(4):
			for linha in range(6):
				if encaixes[coluna][linha] == encaixes[coluna + 1][linha] and encaixes[coluna + 1][linha] == encaixes[coluna + 2][linha] and encaixes[coluna + 2][linha] == encaixes[coluna + 3][linha] and encaixes[coluna][linha] != 0:
					if encaixes[coluna][linha] == -1:
						return -(vitoria + qtd_jogadas)
					else:
						return derrota + qtd_jogadas
		# Vitoria diagonal (\)
		for coluna in range(4):
			for linha in range(3):
				if encaixes[coluna][5 - linha] == encaixes[coluna + 1][5 - linha - 1] and encaixes[coluna + 1][5 - linha - 1] == encaixes[coluna + 2][5 - linha - 2] and encaixes[coluna + 2][5 - linha - 2] == encaixes[coluna + 3][5 - linha - 3] and encaixes[coluna][5 - linha] != 0:
					if encaixes[coluna][5 - linha] == -1:
						return -(vitoria + qtd_jogadas)
					else:
						return derrota + qtd_jogadas
		# Vitoria diagonal (/)
		for coluna in range(4):
			for linha in range(3):
				if encaixes[6 - coluna][5 - linha] == encaixes[6 - coluna - 1][5 - linha - 1] and encaixes[6 - coluna - 1][5 - linha - 1] == encaixes[6 - coluna - 2][5 - linha - 2] and encaixes[6 - coluna - 2][5 - linha - 2] == encaixes[6 - coluna - 3][5 - linha - 3] and encaixes[6 - coluna][5 - linha] != 0:
					if encaixes[6 - coluna][5 - linha] == -1:
						return -(vitoria + qtd_jogadas)
					else:
						return derrota + qtd_jogadas
	return 0.5

func todas_jogadas_possiveis() -> Array:
	var lista_todas_jogadas_possiveis: Array = []
	for coluna in range(7):
		#print("_______________________")
		#print(encaixes[coluna][5])
		#print("_______________________")
		if encaixes[coluna][5] == 0:
			lista_todas_jogadas_possiveis.append(coluna)
	#print(lista_todas_jogadas_possiveis)
	return lista_todas_jogadas_possiveis

func jogada_fantasma(jogada_solicitada: int) -> Tabuleiro:
	#var tabuleiro_fantasma: Tabuleiro = self.duplicate(true)
	var tabuleiro_fantasma: Tabuleiro = duplica_self()
	#tabuleiro_fantasma.encaixes = self.encaixes
	tabuleiro_fantasma.coloca_peca(jogada_solicitada)
	return tabuleiro_fantasma

func duplica_self() -> Tabuleiro:
	var tabuleiro_novo: Tabuleiro = Tabuleiro.new()
	#tabuleiro_novo.encaixes = self.encaixes
	for coluna in self.encaixes.size():
		for linha in self.encaixes[coluna].size():
			tabuleiro_novo.encaixes[coluna][linha] = self.encaixes[coluna][linha]
	tabuleiro_novo.jogador = self.jogador
	tabuleiro_novo.profundidade_maxima = self.profundidade_maxima
	return tabuleiro_novo

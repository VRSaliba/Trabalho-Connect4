extends Resource
class_name MiniMax_poda

const TABULEIRO = preload("uid://ct341wwhh33v0")
const JOGADA = preload("uid://cedbsggh8fibq")

#const INFINITO: int = 99999

var movimento: int

func encontra_melhor_jogada(tabuleiro: Tabuleiro, dificuldade: int, jogador_original: int) -> Jogada:
	if dificuldade == 1:
		var melhor_jogada_encontrada: Jogada = minimax_poda_connect4_facil(tabuleiro, tabuleiro.jogador, tabuleiro.profundidade_maxima, 0, -1)
		return melhor_jogada_encontrada
	elif dificuldade == 2:
		var melhor_jogada_encontrada: Jogada = minimax_poda_connect4_medio(tabuleiro, tabuleiro.jogador, tabuleiro.profundidade_maxima, 0, -1, jogador_original)
		return melhor_jogada_encontrada
	else:
		var melhor_jogada_encontrada: Jogada = Jogada.new(-1, -999999999999)
		return melhor_jogada_encontrada

func minimax_poda_connect4_facil(tabuleiro: Tabuleiro, jogador_da_vez: int, profundidade_maxima: int, profundidade_atual: int, jogada_anterior: int) -> Jogada:
	# Minimax usado na dificuldade fácil -> faz jogadas de forma aleatória até encontrar uma vitória ou derrota
	if profundidade_atual < profundidade_maxima and not tabuleiro.empate():
		
		# Se vence ou perde neste tabuleiro, retorna a jogada que resultou neste estado (serve para evitar gerar tabuleiros impossíveis e reduzir número de tabuleiros gerados)
		var avaliacao_tabuleiro_atual = tabuleiro.avalia_fim_de_jogo_facil()		
		if jogada_anterior != -1 and (avaliacao_tabuleiro_atual < -500 or avaliacao_tabuleiro_atual > 500):
			return Jogada.new(jogada_anterior, avaliacao_tabuleiro_atual)
		
		# Gera todos as jogadas possíveis a partir do tabuleiro recebido
		var jogadas_possiveis = tabuleiro.todas_jogadas_possiveis()
		var jogadas_possiveis_avaliadas: Array
		for jogada_possivel in jogadas_possiveis:
			var jogada_em_teste: Tabuleiro = tabuleiro.jogada_fantasma(jogada_possivel)
			jogada_em_teste.jogador = -jogador_da_vez
			jogada_em_teste.profundidade_maxima = profundidade_maxima
			jogada_em_teste.profundidade_atual = profundidade_atual + 1
			jogada_em_teste.qtd_jogadas = tabuleiro.qtd_jogadas + 1
			jogadas_possiveis_avaliadas.append(minimax_poda_connect4_facil(jogada_em_teste, jogada_em_teste.jogador, profundidade_maxima, profundidade_atual + 1, jogada_possivel))
		
		var lista_melhores_jogadas: Array
		if jogador_da_vez == 1:
			var maior_jogada = Jogada.new(-1, -999999999999)
			for jogada in jogadas_possiveis_avaliadas.size():
				if jogadas_possiveis_avaliadas[jogada].avaliacao > maior_jogada.avaliacao:
					maior_jogada.avaliacao = jogadas_possiveis_avaliadas[jogada].avaliacao
					maior_jogada.coluna = jogadas_possiveis_avaliadas[jogada].coluna
					lista_melhores_jogadas = []
					lista_melhores_jogadas.append(jogadas_possiveis_avaliadas[jogada])
				elif jogadas_possiveis_avaliadas[jogada].avaliacao == maior_jogada.avaliacao:
					lista_melhores_jogadas.append(jogadas_possiveis_avaliadas[jogada])
			lista_melhores_jogadas.shuffle()
			maior_jogada = lista_melhores_jogadas[0]
			if jogada_anterior != -1:
				maior_jogada.coluna = jogada_anterior
			return maior_jogada
		else:
			var menor_jogada = Jogada.new(-1, 999999999999)
			for jogada in jogadas_possiveis_avaliadas.size():
				if jogadas_possiveis_avaliadas[jogada].avaliacao < menor_jogada.avaliacao:
					menor_jogada.avaliacao = jogadas_possiveis_avaliadas[jogada].avaliacao
					menor_jogada.coluna = jogadas_possiveis_avaliadas[jogada].coluna
					lista_melhores_jogadas = []
					lista_melhores_jogadas.append(jogadas_possiveis_avaliadas[jogada])
				elif jogadas_possiveis_avaliadas[jogada].avaliacao == menor_jogada.avaliacao:
					lista_melhores_jogadas.append(jogadas_possiveis_avaliadas[jogada])
			lista_melhores_jogadas.shuffle()
			menor_jogada = lista_melhores_jogadas[0]
			if jogada_anterior != -1:
				menor_jogada.coluna = jogada_anterior
			return menor_jogada
	else:
		return Jogada.new(jogada_anterior, tabuleiro.avalia_fim_de_jogo_facil())


# mudar a verificacao dos pontos da proxima jogada quando for a profundidade 1
# verificar a logica do jogador -1, nao esta funcionando como o jogador 1
func minimax_poda_connect4_medio(tabuleiro: Tabuleiro, jogador_da_vez: int, profundidade_maxima: int, profundidade_atual: int, jogada_anterior: int, jogador_original: int) -> Jogada:
	# 
	if profundidade_atual < profundidade_maxima and not tabuleiro.empate():
		
		# Se vence neste tabuleiro, retorna a jogada que resultou neste estado (serve para evitar gerar tabuleiros impossíveis e reduzir número de tabuleiros gerados)
		var avaliacao_tabuleiro_atual = tabuleiro.avalia_fim_de_jogo_medio(jogador_original)
		if jogada_anterior != -1 and (avaliacao_tabuleiro_atual < -500 or avaliacao_tabuleiro_atual > 500):
			avaliacao_tabuleiro_atual = (avaliacao_tabuleiro_atual * tabuleiro.acha_peso_encaixe(jogada_anterior, tabuleiro.acha_linha_jogada(jogada_anterior)))
			return Jogada.new(jogada_anterior, avaliacao_tabuleiro_atual)
		# Gera todos as jogadas possíveis a partir do tabuleiro recebido
		var jogadas_possiveis = tabuleiro.todas_jogadas_possiveis()
		var melhores_jogadas_encontradas: Array = []
		
		if profundidade_atual == 1 and avaliacao_tabuleiro_atual == 0.5:
			avaliacao_tabuleiro_atual = (avaliacao_tabuleiro_atual * tabuleiro.acha_peso_encaixe(jogada_anterior, tabuleiro.acha_linha_jogada(jogada_anterior))) * jogador_original
		
		for jogada_possivel in jogadas_possiveis:
			var tabuleiro_em_teste: Tabuleiro = tabuleiro.jogada_fantasma(jogada_possivel)
			tabuleiro_em_teste.jogador = -jogador_da_vez
			tabuleiro_em_teste.profundidade_maxima = profundidade_maxima
			tabuleiro_em_teste.profundidade_atual = profundidade_atual + 1
			tabuleiro_em_teste.qtd_jogadas = tabuleiro.qtd_jogadas + 1
			var jogada_em_teste: Jogada = minimax_poda_connect4_medio(tabuleiro_em_teste, tabuleiro_em_teste.jogador, profundidade_maxima, profundidade_atual + 1, jogada_possivel, jogador_original)
			
			if profundidade_atual == 0:
				print("Jogada (c|a): " + str(jogada_em_teste.coluna) + " | " + str(jogada_em_teste.avaliacao))
			
			if jogador_da_vez == 1:
				if melhores_jogadas_encontradas == []:
					melhores_jogadas_encontradas.append(Jogada.new(-1, -INF))
				if jogada_em_teste.avaliacao > melhores_jogadas_encontradas.back().avaliacao or melhores_jogadas_encontradas == []:
					melhores_jogadas_encontradas = []
					melhores_jogadas_encontradas.append(jogada_em_teste)
				elif jogada_em_teste.avaliacao == melhores_jogadas_encontradas.back().avaliacao:
					melhores_jogadas_encontradas.append(jogada_em_teste)
			else:
				if melhores_jogadas_encontradas == []:
					melhores_jogadas_encontradas.append(Jogada.new(-1, INF))
				if jogada_em_teste.avaliacao < melhores_jogadas_encontradas.back().avaliacao or melhores_jogadas_encontradas == []:
					melhores_jogadas_encontradas = []
					melhores_jogadas_encontradas.append(jogada_em_teste)
				elif jogada_em_teste.avaliacao == melhores_jogadas_encontradas.back().avaliacao:
					melhores_jogadas_encontradas.append(jogada_em_teste)
		
		var melhor_jogada: Jogada
		melhores_jogadas_encontradas.shuffle()
		if jogada_anterior != -1:
			melhor_jogada = melhores_jogadas_encontradas[0]
			melhor_jogada.coluna = jogada_anterior
		else:
			melhor_jogada = melhores_jogadas_encontradas[0]
		
		if profundidade_atual == 1:
			if jogador_original == 1:
				if not (melhor_jogada.avaliacao < -900 or melhor_jogada.avaliacao > 900):
					melhor_jogada.avaliacao = avaliacao_tabuleiro_atual
			else:
				if not (melhor_jogada.avaliacao < -900 or melhor_jogada.avaliacao > 900):
					melhor_jogada.avaliacao = avaliacao_tabuleiro_atual
		return melhor_jogada
	else:
		var valor_tabuleiro = tabuleiro.avalia_fim_de_jogo_medio(jogador_original)
		if valor_tabuleiro == 0.5:
			valor_tabuleiro = (valor_tabuleiro * tabuleiro.acha_peso_encaixe(jogada_anterior, tabuleiro.acha_linha_jogada(jogada_anterior))) * jogador_original
		return Jogada.new(jogada_anterior, valor_tabuleiro)

extends Node2D

@onready var label_tabuleiro: Label = $"Label Tabuleiro"
@onready var botao_reiniciar: Button = $"Botao Reiniciar"
@onready var botao_novo_jogo: Button = $"Botao Novo Jogo"
@onready var botao_jogada_ia: Button = $"Botao Jogada IA"

@onready var botao_dificuldade_facil: Button = $"Botao Dificuldade Facil"
@onready var botao_dificuldade_medio: Button = $"Botao Dificuldade Medio"
@onready var botao_dificuldade_dificil: Button = $"Botao Dificuldade Dificil"


var ia = MiniMax_poda.new()
var tabuleiro = Tabuleiro.new()

var dificuldade: int

func _ready() -> void:
	for child in get_children():
		if child is Botao:
			# conecta todos os botoes na Main ao signal botao_jogada_apertado e chama a funcao botao_jogada_apertado_emitido quando o sinal do botao 
			# é emitido
			child.botao_jogada_apertado.connect(faz_jogada)

func _on_botao_novo_jogo_pressed() -> void:
	# Ajustar que nem os botoes de jogada
	botao_dificuldade_facil.show()
	botao_dificuldade_medio.show()
	botao_dificuldade_dificil.show()

	botao_novo_jogo.hide()

# Temporário
func _on_botao_dificuldade_facil_pressed() -> void:
	dificuldade = 1
	tabuleiro.profundidade_maxima = 3
	botao_dificuldade_facil.hide()
	botao_dificuldade_medio.hide()
	botao_dificuldade_dificil.hide()
	mostra_botoes_jogo()
	atualiza_label_tabuleiro()

# Temporário
func _on_botao_dificuldade_medio_pressed() -> void:
	dificuldade = 2
	tabuleiro.profundidade_maxima = 5
	botao_dificuldade_facil.hide()
	botao_dificuldade_medio.hide()
	botao_dificuldade_dificil.hide()
	mostra_botoes_jogo()
	atualiza_label_tabuleiro()

# Temporário
func _on_botao_dificuldade_dificil_pressed() -> void:
	dificuldade = 3
	tabuleiro.profundidade_maxima = 7
	botao_dificuldade_facil.hide()
	botao_dificuldade_medio.hide()
	botao_dificuldade_dificil.hide()
	mostra_botoes_jogo()
	atualiza_label_tabuleiro()

func mostra_botoes_jogo() -> void:
	for botao in get_tree().get_nodes_in_group("botoes_tabuleiro"):
		botao.show()
	botao_jogada_ia.show()

func esconde_botoes_jogo() -> void:
	for botao in get_tree().get_nodes_in_group("botoes_tabuleiro"):
		botao.hide()
	botao_jogada_ia.hide()

func faz_jogada(coluna: int) -> void:
	if tabuleiro.coloca_peca(coluna):
		atualiza_label_tabuleiro()
		verifica_fim_de_jogo()

func verifica_fim_de_jogo():
	if tabuleiro.avalia_fim_de_jogo_facil() != 0.5:
			vitoria_jogo()
	elif tabuleiro.empate():
		empate_jogo()
	else:
		tabuleiro.troca_jogador()
		mostra_botoes_jogo()

func vitoria_jogo():
	print("Jogador " + str(tabuleiro.jogador) + " venceu!")
	botao_reiniciar.show()

func empate_jogo():
	print("Jogo empatou!")
	botao_reiniciar.show()

func atualiza_label_tabuleiro() -> void:
	# Atualmente está printando o tabuleiro de lado, Label está rotacionado 90º
	# Código provisório
	label_tabuleiro.text = ""
	for coluna in tabuleiro.encaixes.size():
		for linha in tabuleiro.encaixes[coluna].size():
			if tabuleiro.encaixes[coluna][linha] == 1:
				label_tabuleiro.text = label_tabuleiro.text + "🟢"
			elif tabuleiro.encaixes[coluna][linha] == -1:
				label_tabuleiro.text = label_tabuleiro.text + "🔴"
			else:
				label_tabuleiro.text = label_tabuleiro.text + "⚪"
		label_tabuleiro.text = label_tabuleiro.text + "\n"

func finaliza_jogo() -> void:
	if tabuleiro.empate():
		esconde_botoes_jogo()
		botao_reiniciar.show()
		print("Jogo empatou!")
	else:
		esconde_botoes_jogo()
		botao_reiniciar.show()
		print("Jogador ", tabuleiro.jogador, " venceu!")

func _on_restart_button_pressed() -> void:
	# Reinicia o jogo depois do Botão Reinicar ser pressionado
	tabuleiro.qtd_jogadas = 0
	for coluna in tabuleiro.encaixes.size():
		for linha in tabuleiro.encaixes[coluna].size():
			tabuleiro.encaixes[coluna][linha] = 0
	tabuleiro.jogador = 1
	mostra_botoes_jogo()
	botao_reiniciar.hide()
	atualiza_label_tabuleiro()
	print("Jogo começou!")

func _on_botao_jogada_ia_pressed() -> void:
	jogada_maquina()

# Código abaixo será utilizado para a lógica do computador, acima é o jogo "sem IA"
func jogada_maquina() -> void:
	esconde_botoes_jogo()
	print("******************************")
	var jogada_ia = ia.encontra_melhor_jogada(tabuleiro, dificuldade, tabuleiro.jogador)
	print("Jogada realizada(c|a): " + str(jogada_ia.coluna) + "|" + str(jogada_ia.avaliacao))
	print("******************************")
	faz_jogada(jogada_ia.coluna)
	tabuleiro.qtd_jogadas += 1
	atualiza_label_tabuleiro()

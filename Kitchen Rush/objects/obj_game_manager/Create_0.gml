
pontuacao = 0;

randomise();

pedido_atual = choose(
    "tomate_cozido",
    "cebola_cozida"
);

show_debug_message("PEDIDO INICIAL: " + pedido_atual);

pedido_concluido = false;

tempo_pedido = 60;
tempo_pedido_total = 60;

pedido_expirado = false;

tempo_proximo_pedido = 0;

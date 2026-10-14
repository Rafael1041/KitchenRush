
/// ========================================
/// INTERFACE DO JOGO (HUD)
/// ========================================

// Cor do texto
draw_set_color(c_white);

// Título
draw_text(24, 24, "PEDIDOS DA COZINHA");

// Pedido atual
if (pedido_atual == "tomate_cozido")
{
    draw_text(24, 55, "Pedido: Tomate cozido");
}
else if (pedido_atual == "cebola_cozida")
{
    draw_text(24, 55, "Pedido: Cebola cozida");
}


// Pontuação
draw_text(
    24,
    85,
    "Pontuacao: " + string(pontuacao)
);


// Mostrar o tempo restante
draw_set_color(c_white);

draw_text(
    24,
    145,
    "Tempo: " + string(ceil(tempo_pedido)) + " s"
);


// Estado do pedido
if (pedido_concluido)
{
    draw_set_color(c_lime);
    draw_text(24, 115, "PEDIDO CONCLUIDO!");
}
else
{
    draw_set_color(c_yellow);
    draw_text(24, 115, "Pedido pendente");
}


if (pedido_expirado)
{
    draw_set_color(c_red);
    draw_text(24, 175, "TEMPO ESGOTADO!");
}

// Restaurar cor
draw_set_color(c_white);

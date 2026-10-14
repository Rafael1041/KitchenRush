
/// ========================================
/// CRONOMETRO E CONTROLE DOS PEDIDOS
/// ========================================

// 1. Contar o tempo enquanto o pedido estiver ativo
if (!pedido_concluido && !pedido_expirado)
{
    tempo_pedido -= delta_time / 1000000;

    if (tempo_pedido <= 0)
    {
        tempo_pedido = 0;
        pedido_expirado = true;

        show_debug_message("PEDIDO EXPIRADO!");
    }
}

// 2. Preparar o próximo pedido após a entrega correta
if (pedido_concluido)
{
    tempo_proximo_pedido -= delta_time / 1000000;

    if (tempo_proximo_pedido <= 0)
    {
        pedido_atual = choose(
            "tomate_cozido",
            "cebola_cozida"
        );

        pedido_concluido = false;
        pedido_expirado = false;

        tempo_pedido = tempo_pedido_total;
        tempo_proximo_pedido = 0;

        show_debug_message("NOVO PEDIDO!");
    }
}

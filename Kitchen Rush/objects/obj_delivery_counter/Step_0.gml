
var gerente = instance_find(obj_game_manager, 0);

if (gerente != noone)
{
    if (!gerente.pedido_concluido
    && !gerente.pedido_expirado
    && item_entregue != noone
    && instance_exists(item_entregue))
    {
        var entrega_correta = false;

        if (gerente.pedido_atual == "tomate_cozido")
        {
            if (item_entregue.object_index == obj_tomato_cooked)
            {
                entrega_correta = true;
            }
        }
        else if (gerente.pedido_atual == "cebola_cozida")
        {
            if (item_entregue.object_index == obj_onion_cooked)
            {
                entrega_correta = true;
            }
        }

        if (entrega_correta)
        {
            with (item_entregue)
            {
                instance_destroy();
            }

            item_entregue = noone;
            ocupado = false;

            gerente.pontuacao += 100;
            gerente.pedido_concluido = true;
            gerente.tempo_proximo_pedido = 2;

            show_debug_message("PEDIDO CONCLUIDO! +100 PONTOS");
            show_debug_message(
                "PONTUACAO: " + string(gerente.pontuacao)
            );
        }
    }
}

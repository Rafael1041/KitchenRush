
/// ========================================
/// 1. MOVIMENTO
/// ========================================

var direita = keyboard_check(ord("D"));
var esquerda = keyboard_check(ord("A"));
var baixo = keyboard_check(ord("S"));
var cima = keyboard_check(ord("W"));

var movimento_x = (direita - esquerda) * velocidade;
var movimento_y = (baixo - cima) * velocidade;

if (!place_meeting(x + movimento_x, y, obj_solid))
{
    x += movimento_x;
}

if (!place_meeting(x, y + movimento_y, obj_solid))
{
    y += movimento_y;
}


/// ========================================
/// 2. CORTE EM ANDAMENTO
/// ========================================

if (cortando)
{
    tempo_corte -= delta_time / 1000000;
    progresso_corte = 1 - (tempo_corte / tempo_corte_total);

    if (tempo_corte <= 0)
    {
        tempo_corte = 0;
        progresso_corte = 1;

        if (estacao_alvo != noone && instance_exists(estacao_alvo))
        {
            var item_para_cortar = estacao_alvo.item_na_bancada;

            if (item_para_cortar != noone
                && instance_exists(item_para_cortar))
            {
                var pos_x = estacao_alvo.x;
                var pos_y = estacao_alvo.y;

                var resultado = item_para_cortar.resultado_corte;
                var estado_resultado = item_para_cortar.estado_resultado_corte;

                with (item_para_cortar)
                {
                    instance_destroy();
                }

                var novo_item = instance_create_layer(
                    pos_x, pos_y, "Instances", resultado
                );

                novo_item.estado = estado_resultado;
                estacao_alvo.item_na_bancada = novo_item;
            }
        }

        cortando = false;
        estacao_alvo = noone;

        show_debug_message("CORTE TERMINADO!");
    }
}


/// ========================================
/// 3. INTERAÇÕES COM E
/// ========================================

if (!cortando && keyboard_check_pressed(ord("E")))
{
    var interagiu_e = false;

    var fogao_e = instance_nearest(x, y, obj_stove);
    var perto_fogao_e = false;

    // Verificar se existe fogão e se o jogador está perto
    if (fogao_e != noone)
    {
        var distancia_fogao_e = point_distance(
            x, y, fogao_e.x, fogao_e.y
        );

        if (distancia_fogao_e <= distancia_interacao)
        {
            perto_fogao_e = true;
        }
    }


	
	/// ----------------------------------------
	/// 3.1. JOGADOR SEGURANDO UMA PANELA
	/// ----------------------------------------

	if (panela_na_mao != noone)
	{
	    var entregou_alimento_e = false;

	    // 1. Tentar entregar o alimento no balcão
	    var balcao_e = instance_nearest(
	        x, y, obj_delivery_counter
	    );

	    if (balcao_e != noone)
	    {
	        var distancia_balcao_e = point_distance(
	            x, y, balcao_e.x, balcao_e.y
	        );

	        if (distancia_balcao_e <= distancia_interacao)
	        {
	            // Só entregar alimentos cozidos ou queimados
	            if (panela_na_mao.item_na_panela != noone
	                && (panela_na_mao.estado == "cozido"
	                    || panela_na_mao.estado == "queimado"))
	            {
	                if (!balcao_e.ocupado
	                    && balcao_e.item_entregue == noone)
	                {
	                    // Guardar o alimento no balcão
	                    balcao_e.item_entregue =
	                        panela_na_mao.item_na_panela;

	                    balcao_e.ocupado = true;

	                    balcao_e.item_entregue.x = balcao_e.x;
	                    balcao_e.item_entregue.y = balcao_e.y;

	                    // Deixar a panela vazia na mão
	                    panela_na_mao.item_na_panela = noone;
	                    panela_na_mao.ocupada = false;
	                    panela_na_mao.estado = "vazia";

	                    panela_na_mao.tempo_cozimento = 0;
	                    panela_na_mao.progresso_cozimento = 0;
	                    panela_na_mao.tempo_queimando = 0;

	                    entregou_alimento_e = true;

	                    show_debug_message(
	                        "ALIMENTO COLOCADO NO BALCAO!"
	                    );
	                }
	                else
	                {
	                    show_debug_message(
	                        "O BALCAO JA ESTA OCUPADO!"
	                    );

	                    entregou_alimento_e = true;
	                }
	            }
	        }
	    }

	    // 2. Se não entregou, tentar colocar a panela no fogão
	    if (!entregou_alimento_e)
	    {
	        if (perto_fogao_e)
	        {
	            if (fogao_e.panela_no_fogao == noone)
	            {
	                fogao_e.panela_no_fogao = panela_na_mao;

	                panela_na_mao.x = fogao_e.x;
	                panela_na_mao.y = fogao_e.y;

	                panela_na_mao = noone;

	                show_debug_message(
	                    "PANELA COLOCADA NO FOGAO!"
	                );
	            }
	            else
	            {
	                show_debug_message(
	                    "O FOGAO JA TEM UMA PANELA!"
	                );
	            }
	        }
	        else
	        {
	            // Longe do fogão e do balcão:
	            // soltar a panela no chão
	            panela_na_mao.x = x;
	            panela_na_mao.y = y;

	            panela_na_mao = noone;

	            show_debug_message(
	                "PANELA SOLTA NO CHAO!"
	            );
	        }
	    }

	    interagiu_e = true;
	}



    /// ----------------------------------------
    /// 3.2. JOGADOR SEGURANDO UM INGREDIENTE
    /// ----------------------------------------

    else if (item_na_mao != noone)
    {
        var item_para_colocar_e = item_na_mao;
        var colocou_item_e = false;

        // Tentar colocar o ingrediente na panela
        var panela_e = instance_nearest(x, y, obj_pan);

        if (panela_e != noone)
        {
            var distancia_panela_e = point_distance(
                x, y, panela_e.x, panela_e.y
            );

            if (distancia_panela_e <= distancia_interacao)
            {
                if (!panela_e.ocupada
                    && panela_e.item_na_panela == noone)
                {
                    panela_e.item_na_panela = item_para_colocar_e;
                    panela_e.ocupada = true;
                    panela_e.estado = "aguardando";

                    item_para_colocar_e.x = panela_e.x;
                    item_para_colocar_e.y = panela_e.y;

                    item_na_mao = noone;
                    colocou_item_e = true;

                    show_debug_message("INGREDIENTE COLOCADO NA PANELA!");
                }
            }
        }

        // Se não colocou na panela, tentar a bancada
        if (!colocou_item_e)
        {
            var bancada_e = instance_nearest(
                x, y, obj_cutting_board
            );

            if (bancada_e != noone)
            {
                var distancia_bancada_e = point_distance(
                    x, y, bancada_e.x, bancada_e.y
                );

                if (distancia_bancada_e <= distancia_interacao)
                {
                    if (!bancada_e.ocupada
                        && bancada_e.item_na_bancada == noone)
                    {
                        bancada_e.item_na_bancada = item_para_colocar_e;
                        bancada_e.ocupada = true;

                        item_para_colocar_e.x = bancada_e.x;
                        item_para_colocar_e.y = bancada_e.y;

                        item_na_mao = noone;
                        colocou_item_e = true;

                        show_debug_message("INGREDIENTE COLOCADO NA BANCADA!");
                    }
                }
            }
        }

        // Se nenhuma estação recebeu o ingrediente, soltar no chão
        if (!colocou_item_e)
        {
            item_para_colocar_e.x = x;
            item_para_colocar_e.y = y;

            item_na_mao = noone;

            show_debug_message("INGREDIENTE SOLTO NO CHAO!");
        }

        interagiu_e = true;
    }


    /// ----------------------------------------
    /// 3.3. JOGADOR COM AS MÃOS VAZIAS
    /// ----------------------------------------

    else
    {
		/// 3.3A. RETIRAR PANELA DO FOGAO

		if (perto_fogao_e
		    && fogao_e.panela_no_fogao != noone)
		{
		    var panela_fogao_e = fogao_e.panela_no_fogao;

		    if (instance_exists(panela_fogao_e))
		    {
		        // Só retirar a panela se estiver vazia
		        // ou se o alimento já terminou de cozinhar.
		        if (panela_fogao_e.estado == "vazia"
		            || panela_fogao_e.estado == "cozido"
		            || panela_fogao_e.estado == "queimado")
		        {
		            panela_na_mao = panela_fogao_e;
		            fogao_e.panela_no_fogao = noone;

		            interagiu_e = true;

		            show_debug_message("PANELA RETIRADA DO FOGAO!");
		        }
		        else
		        {
		            interagiu_e = true;

		            show_debug_message("AGUARDE O FIM DO COZIMENTO!");
		        }
		    }
		    else
		    {
		        fogao_e.panela_no_fogao = noone;
		    }
		}


        /// 3.3B. PEGAR PANELA VAZIA DO CHÃO

        if (!interagiu_e)
        {
            var panela_chao_e = instance_nearest(
                x, y, obj_pan
            );

            if (panela_chao_e != noone)
            {
                var distancia_panela_chao_e = point_distance(
                    x, y, panela_chao_e.x, panela_chao_e.y
                );

                if (distancia_panela_chao_e <= distancia_interacao)
                {
                    // Verificar se a panela está em algum fogão
                    var esta_no_fogao_e = false;

                    for (var i = 0; i < instance_number(obj_stove); i++)
                    {
                        var fogao_verificar_e = instance_find(obj_stove, i);

                        if (fogao_verificar_e.panela_no_fogao == panela_chao_e)
                        {
                            esta_no_fogao_e = true;
                        }
                    }

                    if (!esta_no_fogao_e)
                    {
                        panela_na_mao = panela_chao_e;
                        interagiu_e = true;

                        show_debug_message("PANELA PEGADA!");
                    }
                }
            }
        }


        /// 3.3C. RETIRAR INGREDIENTE DA PANELA

        if (!interagiu_e)
        {
            var panela_retirar_e = instance_nearest(
                x, y, obj_pan
            );

            if (panela_retirar_e != noone)
            {
                var distancia_retirar_panela_e = point_distance(
                    x, y, panela_retirar_e.x, panela_retirar_e.y
                );

                if (distancia_retirar_panela_e <= distancia_interacao)
                {
                    if (panela_retirar_e.item_na_panela != noone)
                    {
                        if (panela_retirar_e.estado != "cozinhando")
                        {
                            item_na_mao = panela_retirar_e.item_na_panela;

                            panela_retirar_e.item_na_panela = noone;
                            panela_retirar_e.ocupada = false;
                            panela_retirar_e.estado = "vazia";
                            panela_retirar_e.tempo_cozimento = 0;
                            panela_retirar_e.progresso_cozimento = 0;
                            panela_retirar_e.tempo_queimando = 0;

                            interagiu_e = true;

                            show_debug_message("INGREDIENTE RETIRADO DA PANELA!");
                        }
                        else
                        {
                            interagiu_e = true;

                            show_debug_message("O INGREDIENTE AINDA ESTA COZINHANDO!");
                        }
                    }
                }
            }
        }


        /// 3.3D. RETIRAR INGREDIENTE DA BANCADA

        if (!interagiu_e)
        {
            var bancada_retirar_e = instance_nearest(
                x, y, obj_cutting_board
            );

            if (bancada_retirar_e != noone)
            {
                var distancia_retirar_bancada_e = point_distance(
                    x, y, bancada_retirar_e.x, bancada_retirar_e.y
                );

                if (distancia_retirar_bancada_e <= distancia_interacao)
                {
                    if (bancada_retirar_e.item_na_bancada != noone)
                    {
                        item_na_mao = bancada_retirar_e.item_na_bancada;

                        bancada_retirar_e.item_na_bancada = noone;
                        bancada_retirar_e.ocupada = false;

                        interagiu_e = true;

                        show_debug_message("INGREDIENTE RETIRADO DA BANCADA!");
                    }
                }
            }
        }
		
		
		/// ----------------------------------------
		/// 3.3E. RETIRAR ALIMENTO DO BALCAO
		/// ----------------------------------------

		if (!interagiu_e)
		{
		    var balcao_retirar_e = instance_nearest(
		        x, y, obj_delivery_counter
		    );

		    if (balcao_retirar_e != noone)
		    {
		        var distancia_balcao_retirar_e = point_distance(
		            x, y,
		            balcao_retirar_e.x,
		            balcao_retirar_e.y
		        );

		        if (distancia_balcao_retirar_e <= distancia_interacao)
		        {
		            if (balcao_retirar_e.item_entregue != noone)
		            {
		                item_na_mao = balcao_retirar_e.item_entregue;

		                balcao_retirar_e.item_entregue = noone;
		                balcao_retirar_e.ocupado = false;

		                interagiu_e = true;

		                show_debug_message(
		                    "ALIMENTO RETIRADO DO BALCAO!"
		                );
		            }
		        }
		    }
		}



        /// 3.3F. PEGAR INGREDIENTE DO CHÃO

        if (!interagiu_e)
        {
            var item_proximo_e = instance_nearest(
                x, y, obj_ingredient
            );

            if (item_proximo_e != noone)
            {
                var distancia_item_e = point_distance(
                    x, y, item_proximo_e.x, item_proximo_e.y
                );

                if (distancia_item_e <= distancia_interacao)
                {
                    item_na_mao = item_proximo_e;
                    interagiu_e = true;

                    show_debug_message("INGREDIENTE PEGADO!");
                }
            }
        }
    }
}


/// ========================================
/// 4. CTRL PARA CORTAR
/// ========================================

if (!cortando && keyboard_check_pressed(vk_control))
{
    var bancada_corte = instance_nearest(
        x, y, obj_cutting_board
    );

    if (bancada_corte != noone)
    {
        var distancia_corte = point_distance(
            x, y, bancada_corte.x, bancada_corte.y
        );

        if (distancia_corte <= 80)
        {
            if (bancada_corte.item_na_bancada != noone)
            {
                var ingrediente_corte = bancada_corte.item_na_bancada;

                if (instance_exists(ingrediente_corte))
                {
                    if (ingrediente_corte.pode_ser_cortado
                        && ingrediente_corte.estado == "inteiro")
                    {
                        cortando = true;
                        estacao_alvo = bancada_corte;

                        tempo_corte_total = 2;
                        tempo_corte = tempo_corte_total;
                        progresso_corte = 0;

                        show_debug_message("INICIOU O CORTE NA BANCADA!");
                    }
                    else
                    {
                        show_debug_message("ESTE INGREDIENTE NAO PODE SER CORTADO!");
                    }
                }
            }
            else
            {
                show_debug_message("NAO EXISTE INGREDIENTE NA BANCADA!");
            }
        }
    }
}


/// ========================================
/// 5. F = LIGAR OU DESLIGAR O FOGÃO
/// ========================================

if (!cortando && keyboard_check_pressed(ord("F")))
{
    var fogao_f = instance_nearest(x, y, obj_stove);

    if (fogao_f != noone)
    {
        var distancia_fogao_f = point_distance(
            x, y, fogao_f.x, fogao_f.y
        );

        if (distancia_fogao_f <= distancia_interacao)
        {
            fogao_f.ligado = !fogao_f.ligado;

            if (fogao_f.ligado)
            {
                show_debug_message("FOGAO LIGADO!");
            }
            else
            {
                show_debug_message("FOGAO DESLIGADO!");
            }
        }
    }
}


/// ========================================
/// 6. ITEM SEGUE O JOGADOR
/// ========================================

// Ingrediente na mão
if (item_na_mao != noone)
{
    if (instance_exists(item_na_mao))
    {
        item_na_mao.x = x;
        item_na_mao.y = y - 32;
    }
    else
    {
        item_na_mao = noone;
    }
}

// Panela na mão
if (panela_na_mao != noone)
{
    if (instance_exists(panela_na_mao))
    {
        panela_na_mao.x = x;
        panela_na_mao.y = y - 32;
    }
    else
    {
        panela_na_mao = noone;
    }
}

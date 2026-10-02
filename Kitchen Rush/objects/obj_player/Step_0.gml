// ========================================
// MOVIMENTO
// ========================================

var direita = keyboard_check(ord("D"));
var esquerda = keyboard_check(ord("A"));

var baixo = keyboard_check(ord("S"));
var cima = keyboard_check(ord("W"));


// Calcula o movimento horizontal
var movimento_x = (direita - esquerda) * velocidade;


// Calcula o movimento vertical
var movimento_y = (baixo - cima) * velocidade;


// Movimento horizontal com colisão
if (!place_meeting(x + movimento_x, y, obj_solid))
{
    x += movimento_x;
}


// Movimento vertical com colisão
if (!place_meeting(x, y + movimento_y, obj_solid))
{
    y += movimento_y;
}


// ========================================
// CORTE EM ANDAMENTO
// ========================================

if (cortando)
{
    // Diminui o tempo restante do corte
    // delta_time está em microssegundos,
    // por isso dividimos por 1.000.000

    tempo_corte -= delta_time / 1000000;


    // Calcula o progresso entre 0 e 1
    progresso_corte =
        1 - (tempo_corte / tempo_corte_total);


    // ====================================
    // TERMINOU O CORTE?
    // ====================================

    if (tempo_corte <= 0)
    {
        tempo_corte = 0;

        progresso_corte = 1;


        // Verifica se ainda existe
        // algum item na mão
        if (item_na_mao != noone)
        {
            // Guarda a posição do item(obj)
            var pos_x = item_na_mao.x;
            var pos_y = item_na_mao.y;
			
			var resultado = item_na_mao.resultado_corte;
			var estado_resultado = item_na_mao.estado_resultado_corte;


            // Destrói o item(obj)
            with (item_na_mao)
            {
                instance_destroy();
            }


            // Cria o item(obj) cortado
            item_na_mao = instance_create_layer(
                pos_x,
                pos_y,
                "Instances",
                resultado
            );
			
			item_na_mao.estado = estado_resultado;
        }


        // Finaliza o corte
        cortando = false;

        estacao_alvo = noone;
    }
}


// ========================================
// INTERAÇÕES
// ========================================

// Só pode fazer novas ações
// quando NÃO estiver cortando

if (!cortando)
{
    
    // ====================================
// E = PEGAR / SOLTAR / COLOCAR
// ====================================

	if (keyboard_check_pressed(ord("E")))
	{
	    // --------------------------------
	    // JÁ ESTÁ SEGURANDO UM ITEM
	    // --------------------------------

	    if (item_na_mao != noone)
	    {
	        // Procura a panela mais próxima
	        var panela = instance_nearest(
	            x,
	            y,
	            obj_pan
	        );
			
			show_debug_message("Panela encontrada: " + string(panela));


	        // --------------------------------
	        // TENTA COLOCAR NA PANELA
	        // --------------------------------

	        if (panela != noone &&
	            point_distance(
	                x,
	                y,
	                panela.x,
	                panela.y
	            ) <= 64)
	        {
				show_debug_message("Estou perto da panela!");
	            // Verifica se a panela está vazia
	            if (!panela.ocupada)
	            {
	                // Coloca o item na panela
	                panela.item_na_panela = item_na_mao;

	                // Marca a panela como ocupada
	                panela.ocupada = true;

	                // Posiciona o item na panela
	                item_na_mao.x = panela.x;
	                item_na_mao.y = panela.y;

	                // Libera a mão do jogador
	                item_na_mao = noone;
	            }
	        }


	        // --------------------------------
	        // SE NÃO COLOCOU NA PANELA,
	        // SOLTA O ITEM
	        // --------------------------------

	        else
	        {
	            item_na_mao = noone;
	        }
	    }


	    // --------------------------------
	    // NÃO ESTÁ SEGURANDO NADA
	    // --------------------------------

	    else
	    {
	        // Procura somente ingredientes
	        var item_proximo = instance_nearest(
	            x,
	            y,
	            obj_ingredient
	        );


	        // Verifica se encontrou ingrediente
	        if (item_proximo != noone)
	        {
	            // Verifica distância
	            if (point_distance(
	                x,
	                y,
	                item_proximo.x,
	                item_proximo.y
	            ) <= distancia_interacao)
	            {
	                // Pega o ingrediente
	                item_na_mao = item_proximo;
	            }
	        }
	    }
	}


    // ====================================
    // CTRL = CORTAR
    // ====================================

    if (keyboard_check_pressed(vk_control))
    {
        
        // Só pode cortar se estiver
        // segurando alguma coisa

        if (item_na_mao != noone)
        {
            
            // Verifica se o item é
			// "inteiro" e se pode_ser_cortado

            if (item_na_mao.pode_ser_cortado &&
				item_na_mao.estado == "inteiro")
            {
                
                // Procura a bancada
                // de corte mais próxima

                var bancada = instance_nearest(
                    x,
                    y,
                    obj_cutting_board
                );


                // Verifica se encontrou
                // uma bancada

                if (bancada != noone)
                {
                    
                    // Verifica se está
                    // suficientemente perto

                    if (point_distance(
                        x,
                        y,
                        bancada.x,
                        bancada.y
                    ) <= 80)
                    {
                        
                        // =================================
                        // COMEÇA O CORTE
                        // =================================

                        cortando = true;

                        estacao_alvo = bancada;


                        // Tempo do corte
                        // em segundos

                        tempo_corte_total = 2;

                        tempo_corte = tempo_corte_total;


                        // Começa em 0%

                        progresso_corte = 0;
                    }
                }
            }
        }
    }
}


// ========================================
// ITEM SEGUE O JOGADOR
// ========================================

if (item_na_mao != noone)
{
    item_na_mao.x = x;

    item_na_mao.y = y - 32;
}

/// ========================================
/// 1. INGREDIENTE NA PANELA
/// ========================================

if (item_na_panela != noone)
{
    if (instance_exists(item_na_panela))
    {
        item_na_panela.x = x;
        item_na_panela.y = y;
    }
    else
    {
        item_na_panela = noone;
        ocupada = false;
        estado = "vazia";
    }
}


/// ========================================
/// 2. VERIFICAR SE A PANELA ESTÁ NO FOGÃO
/// ========================================

var fogao_atual = noone;

var fogao_proximo = instance_nearest(x, y, obj_stove);

if (fogao_proximo != noone)
{
    // O fogão precisa reconhecer esta panela
    if (fogao_proximo.panela_no_fogao == id)
    {
        fogao_atual = fogao_proximo;
    }
}


/// ========================================
/// 3. INICIAR O COZIMENTO
/// ========================================

if (estado == "aguardando")
{
    // Só cozinha se houver ingrediente, panela no fogão
    // e fogão ligado.
    if (item_na_panela != noone
        && fogao_atual != noone
        && fogao_atual.ligado)
    {
        // O ingrediente precisa estar cortado
        if (item_na_panela.estado == "cortado")
        {
            // Confirma que o ingrediente possui um resultado
            if (variable_instance_exists(
                item_na_panela,
                "resultado_cozimento"
            ))
            {
                estado = "cozinhando";

                tempo_cozimento = tempo_cozimento_total;
                progresso_cozimento = 0;
                tempo_queimando = 0;

                show_debug_message("COZIMENTO INICIADO!");
            }
            else
            {
                show_debug_message(
                    "ERRO: INGREDIENTE SEM RESULTADO DE COZIMENTO!"
                );
            }
        }
    }
}


/// ========================================
/// 4. COZIMENTO
/// ========================================

if (estado == "cozinhando")
{
    // O tempo só avança com o fogão ligado
    // e a panela posicionada nele.
    if (fogao_atual != noone && fogao_atual.ligado)
    {
        if (item_na_panela != noone)
        {
            tempo_cozimento -= delta_time / 1000000;

            progresso_cozimento =
                1 - (tempo_cozimento / tempo_cozimento_total);

            if (tempo_cozimento <= 0)
            {
                tempo_cozimento = 0;
                progresso_cozimento = 1;

                var pos_x = item_na_panela.x;
                var pos_y = item_na_panela.y;

                var resultado =
                    item_na_panela.resultado_cozimento;

                // Remove o ingrediente cortado
                with (item_na_panela)
                {
                    instance_destroy();
                }

                // Cria o alimento cozido
                item_na_panela = instance_create_layer(
                    pos_x,
                    pos_y,
                    "Instances",
                    resultado
                );

                estado = "cozido";
                tempo_queimando = 0;

                show_debug_message("COZIMENTO TERMINOU!");
            }
        }
    }
}


/// ========================================
/// 5. QUEIMAR O ALIMENTO
/// ========================================

if (estado == "cozido" && item_na_panela != noone)
{
    // O alimento só queima enquanto a panela
    // está no fogão e ele permanece ligado.
    if (fogao_atual != noone && fogao_atual.ligado)
    {
        tempo_queimando += delta_time / 1000000;

        if (tempo_queimando >= tempo_queimar_total)
        {
            // Confirma que o alimento tem um resultado queimado
            if (variable_instance_exists(
                item_na_panela,
                "resultado_queimado"
            ))
            {
                var pos_x = item_na_panela.x;
                var pos_y = item_na_panela.y;

                var resultado =
                    item_na_panela.resultado_queimado;

                // Remove o alimento cozido
                with (item_na_panela)
                {
                    instance_destroy();
                }

                // Cria o alimento queimado
                item_na_panela = instance_create_layer(
                    pos_x,
                    pos_y,
                    "Instances",
                    resultado
                );

                estado = "queimado";

                show_debug_message("ALIMENTO QUEIMADO!");
            }
            else
            {
                show_debug_message(
                    "ERRO: ALIMENTO SEM RESULTADO QUEIMADO!"
                );
            }
        }
    }
}

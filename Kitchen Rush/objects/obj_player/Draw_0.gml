// ========================================
// DESENHA O JOGADOR
// ========================================

draw_self();


// ========================================
// BARRA DE PROGRESSO DO CORTE
// ========================================

if (cortando)
{
    // Tamanho da barra
    var largura_barra = 50;
    var altura_barra = 6;


    // Posição da barra
    var barra_x = x - largura_barra / 2;
    var barra_y = y - 45;


    // ====================================
    // FUNDO DA BARRA
    // ====================================

    draw_rectangle(
        barra_x,
        barra_y,
        barra_x + largura_barra,
        barra_y + altura_barra,
        false
    );


    // ====================================
    // PARTE PREENCHIDA
    // ====================================

    draw_rectangle(
        barra_x,
        barra_y,
        barra_x + (largura_barra * progresso_corte),
        barra_y + altura_barra,
        true
    );
}
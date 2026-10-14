// ========================================
// DESENHA A PANELA
// ========================================

draw_self();


// ========================================
// BARRA DE COZIMENTO
// ========================================

if (estado == "cozinhando")
{
    var largura_barra = 50;
    var altura_barra = 6;

    var barra_x = x - largura_barra / 2;
    var barra_y = y - 45;

    // Fundo da barra
    draw_rectangle(
        barra_x,
        barra_y,
        barra_x + largura_barra,
        barra_y + altura_barra,
        false
    );

    // Progresso
    draw_rectangle(
        barra_x,
        barra_y,
        barra_x +
        (largura_barra * progresso_cozimento),
        barra_y + altura_barra,
        true
    );
}
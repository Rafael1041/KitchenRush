
/// MANTER A PANELA SOBRE O FOGAO

if (instance_exists(panela_no_fogao))
{
    panela_no_fogao.x = x;
    panela_no_fogao.y = y;
}
else
{
    panela_no_fogao = noone;
}

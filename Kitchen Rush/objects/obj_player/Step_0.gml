var dir_x = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var dir_y = keyboard_check(ord("S")) - keyboard_check(ord("W"));

x += dir_x * move_speed;
y += dir_y * move_speed;
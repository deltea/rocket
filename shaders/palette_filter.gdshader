shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

uniform vec4 old_primary : source_color = vec4(1, 1, 1, 1);
uniform vec4 old_accent : source_color = vec4(1, 0, 0, 1);
uniform vec4 old_background : source_color = vec4(0, 0, 1, 1);
uniform vec4 old_midground : source_color = vec4(0, 1, 0, 1);
uniform vec4 old_foreground : source_color = vec4(0, 0, 0, 1);

uniform vec4 new_primary : source_color = vec4(1, 1, 1, 1);
uniform vec4 new_accent : source_color = vec4(1, 0, 0, 1);
uniform vec4 new_background : source_color = vec4(0, 0, 1, 1);
uniform vec4 new_midground : source_color = vec4(0, 1, 0, 1);
uniform vec4 new_foreground : source_color = vec4(0, 0, 0, 1);

void fragment() {
	vec4 color = texture(screen_texture, SCREEN_UV);

	if (color == old_primary) COLOR = new_primary;
	else if (color == old_accent) COLOR = new_accent;
	else if (color == old_background) COLOR = new_background;
	else if (color == old_midground) COLOR = new_midground;
	else if (color == old_foreground) COLOR = new_foreground;
	else COLOR = color;
}

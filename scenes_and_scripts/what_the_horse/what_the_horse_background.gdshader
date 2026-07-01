shader_type canvas_item;

// Controls how fast the texture scrolls
uniform float scroll_speed : hint_range(-5.0, 5.0) = 0;

void fragment() {
	// Shift the Y coordinates over time to create the loop
	vec2 scrolled_uv = UV + vec2(-TIME * scroll_speed, TIME * scroll_speed);
	
	// Sample the texture using our newly calculated coordinates
	COLOR = texture(TEXTURE, scrolled_uv);
}
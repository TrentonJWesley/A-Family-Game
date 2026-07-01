shader_type canvas_item;
render_mode unshaded;

// Controls the circle size: 0.0 is closed/black, 1.05 is fully open/transparent
uniform float circle_size : hint_range(0.0, 1.05) = 0.0;
uniform float screen_width;
uniform float screen_height;

void fragment() {
    float ratio = screen_width / screen_height;
    // Calculate distance from center of the TextureRect
    float dist = distance(vec2(0.5, 0.5), vec2(mix(0.5, UV.x, ratio), UV.y));
    // If dist is less than circle_size, alpha is 0 (shows texture), else alpha is 1 (hides behind "walls")
    COLOR.a = step(circle_size, dist);
}
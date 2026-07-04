shader_type canvas_item;

// Control variables exposed to the Godot Inspector
uniform float wave_speed : hint_range(0.0, 10.0) = 2.0;
uniform float wave_frequency : hint_range(0.0, 20.0) = 4.0;
uniform float wave_amplitude : hint_range(0.0, 0.5) = 0.03;
uniform float pixelation_strength : hint_range(64.0, 1024.0) = 320.0;
uniform bool enable_pixelation = true;

void fragment() {
    vec2 uv = UV;

    // Optional: Balatro retro low-res pixelation pass
    if (enable_pixelation) {
        uv = floor(uv * pixelation_strength) / pixelation_strength;
    }

    // Mathematical fluid distortion (Plasma math similar to Balatro)
    // We warp the X coordinate based on Y and TIME, and vice-versa
    float time_factor = TIME * wave_speed;
    
    float distortion_x = sin(uv.y * wave_frequency + time_factor) * 
                         cos(uv.x * wave_frequency * 0.5 + time_factor * 0.5);
                         
    float distortion_y = cos(uv.x * wave_frequency + time_factor * 0.7) * 
                         sin(uv.y * wave_frequency * 0.6 + time_factor * 1.2);

    // Apply the distortions back to the texture UV coordinates
    uv.x += distortion_x * wave_amplitude;
    uv.y += distortion_y * wave_amplitude;

    // Output the final shifted pixel color from your texture
    COLOR = texture(TEXTURE, uv);
}
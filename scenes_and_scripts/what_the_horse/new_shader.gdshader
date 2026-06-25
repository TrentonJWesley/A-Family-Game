shader_type canvas_item;

uniform int columns = 5;
uniform int rows = 3;

void fragment() {
    // Calculate size of a single frame
    vec2 frame_size = vec2(1.0 / float(columns), 1.0 / float(rows));
    
    // Get column and row indices for the current frame
    int col = frame % columns;
    int row = frame / columns;
    
    // Offset the UV coordinates to point to the correct frame
    vec2 uv_offset = vec2(float(col), float(row)) * frame_size;
    vec2 frame_uv = uv_offset + UV * frame_size;
    
    COLOR = texture(TEXTURE, frame_uv);
}
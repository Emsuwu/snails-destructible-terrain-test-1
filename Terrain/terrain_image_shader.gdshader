shader_type canvas_item;
uniform sampler2D overlay_texture: repeat_enable, filter_nearest;
uniform float scale = 0.006944444; // Example: 1.0 / TextureWidth
varying vec2 world_position;

void vertex(){
    // Calculate world position to keep texture consistent across tiles
    world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
    // Sample the overlay texture using the world position
    vec4 overlay_color = texture(overlay_texture, world_position * scale);
    
    // Get the base tilemap color
    vec4 base_color = texture(TEXTURE, UV);
    
    // Mix the base color with the overlay
    COLOR = mix(base_color, overlay_color, overlay_color.a);
}
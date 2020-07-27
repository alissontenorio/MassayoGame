shader_type canvas_item;

uniform float active = 0.0;

// If active is 1.0 then image gets white

void fragment() {
	COLOR = texture(TEXTURE, UV) + vec4(active, active, active, 0.0);
}
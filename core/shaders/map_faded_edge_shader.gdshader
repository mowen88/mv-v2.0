shader_type canvas_item;

uniform float fade_width : hint_range(0.0, 0.5) = 0.15;

void fragment() {
	// Calculate distance from all 4 edges (UV coordinates range from 0.0 to 1.0)
	vec2 edge = min(UV, 1.0 - UV);
	
	// Smoothstep fade for horizontal and vertical edges simultaneously
	float alpha_x = smoothstep(0.0, fade_width, edge.x);
	float alpha_y = smoothstep(0.0, fade_width, edge.y);
	
	// Multiply them together to create a smooth fade frame around all 4 sides
	COLOR = vec4(1.0, 1.0, 1.0, alpha_x * alpha_y);
}
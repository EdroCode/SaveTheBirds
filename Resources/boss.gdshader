shader_type canvas_item;

uniform bool flash_enabled = false; // Controlled by code
uniform float flash_strength: hint_range(0.0, 1.0) = 1.0; // How white it gets
uniform float flash_duration: hint_range(0.01, 1.0) = 0.1; // Seconds for flash

// Internal time tracker (updated from code)
uniform float flash_time = 0.0;

void fragment() {
    vec4 base_color = texture(TEXTURE, UV) * COLOR;

    if (!flash_enabled) {
        COLOR = base_color; // No flash
    } else {
        // Progress from 0 → 1 during flash
        float t = clamp(flash_time / flash_duration, 0.0, 1.0);

        // Fade from white back to base_color over time
        vec3 flash_color = mix(vec3(1.0), base_color.rgb, t);
        COLOR = vec4(mix(base_color.rgb, flash_color, flash_strength * (1.0 - t)), base_color.a);
    }
}

shader_type canvas_item;

uniform float scale : hint_range(1.0, 128,0.5) = 64.0;
uniform vec3 target_color : source_color = vec3(0.0,0.0,0.0);
uniform vec3 dark_color : source_color = vec3(0.1, 0.2, 0.2);
uniform vec3 light_color : source_color = vec3(0.6, 0.9, 0.8);
uniform vec3 shadow_color : source_color = vec3(0.0,0.0,0.0);
uniform float threshold : hint_range(0.0,1.0) = 0.5;
uniform float softness : hint_range(0.0,1.0) = 0.1;


uniform vec2 camera_pos = vec2(0.0);
uniform vec2 camera_zoom = vec2(4.0);
uniform vec2 viewport_size = vec2(640.0, 360.0);

vec2 random(vec2 uv) {
    float n = sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453;
    return vec2(
        0.5 + 0.5 * sin(n + TIME * 0.7),
        0.5 + 0.5 * cos(n + TIME * 0.7)
    );
}

float worley(vec2 uv, float columns, float rows) {
    vec2 index_uv = floor(vec2(uv.x * columns, uv.y * rows));
    vec2 fract_uv = fract(vec2(uv.x * columns, uv.y * rows));

    float minimum_dist = 1.0;

    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            vec2 neighbor = vec2(float(x), float(y));
            vec2 point = random(index_uv + neighbor);

            vec2 diff = neighbor + point - fract_uv;
            float dist = length(diff);
            minimum_dist = min(minimum_dist, dist);
        }
    }
    return minimum_dist;
}

void fragment() {
    vec2 screen_pixel = SCREEN_UV * viewport_size;

    vec2 world_pos = (screen_pixel - viewport_size * 0.5) / camera_zoom + camera_pos;

    vec2 global_uv = world_pos / scale;

    if (distance(COLOR.rgb, target_color) < 0.1) {
        float w = worley(global_uv, 5.0, 5.0);
        float t = smoothstep(threshold - softness, threshold + softness, w);

        vec3 base_color = mix(dark_color, light_color, t);

        float w_shadow = worley(global_uv + vec2(0.1, 0.1), scale/25.0, scale/100.0);
        float s = smoothstep(threshold - softness, threshold + softness, w_shadow);

        float shadow_mask = clamp(s - t, 0.0, 1.0);

        vec3 final_color = mix(base_color, shadow_color, shadow_mask);

        COLOR = vec4(final_color, 1.0);
    }
}

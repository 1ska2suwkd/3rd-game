shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // 흰색 (기본)
uniform float threshold = 0.01; // 알파 판정 임계값 (대개 0.01이면 충분)

void fragment() {
    vec2 px = TEXTURE_PIXEL_SIZE; // 텍스쳐의 1픽셀 UV 오프셋

    vec4 me = texture(TEXTURE, UV);
    float a = me.a;

    // 현재 픽셀이 투명하면(윤곽선 후보)
    if (a <= threshold) {
        // 8방향 샘플링 (한 칸)
        float n = 0.0;
        n += texture(TEXTURE, UV + vec2(px.x, 0.0)).a;
        n += texture(TEXTURE, UV + vec2(-px.x, 0.0)).a;
        n += texture(TEXTURE, UV + vec2(0.0, px.y)).a;
        n += texture(TEXTURE, UV + vec2(0.0, -px.y)).a;
        n += texture(TEXTURE, UV + vec2(px.x, px.y)).a;
        n += texture(TEXTURE, UV + vec2(-px.x, px.y)).a;
        n += texture(TEXTURE, UV + vec2(px.x, -px.y)).a;
        n += texture(TEXTURE, UV + vec2(-px.x, -px.y)).a;

        // 주변에 하나라도 알파가 있으면 윤곽선 출력
        if (n > threshold) {
            COLOR = outline_color;
        } else {
            // 완전히 투명 영역이면 discard (투명 유지)
            discard;
        }
    } else {
        // 원래 픽셀은 그대로 출력
        COLOR = me;
    }
}

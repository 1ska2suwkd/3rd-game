shader_type canvas_item;

// 인스펙터에서 수정 가능한 변수들
uniform vec4 color_first : source_color = vec4(1.0, 0.0, 0.0, 1.0); // 첫 번째 색 빨강
uniform vec4 color_second : source_color = vec4(1.0, 0.794, 0.35, 1.0); // 두 번째 색 
uniform float line_thickness : hint_range(0.0, 10.0) = 2.0; // 외곽선 두께
uniform float shine_speed : hint_range(0.0, 5.0) = 5.0; // 색이 바뀌는 속도

void fragment() {
    vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
    
    // 현재 픽셀의 투명도 확인
    float current_a = texture(TEXTURE, UV).a;
    
    // 상하좌우 픽셀의 투명도 확인 (외곽선 감지용)
    float up_a = texture(TEXTURE, UV + vec2(0.0, -size.y)).a;
    float down_a = texture(TEXTURE, UV + vec2(0.0, size.y)).a;
    float left_a = texture(TEXTURE, UV + vec2(-size.x, 0.0)).a;
    float right_a = texture(TEXTURE, UV + vec2(size.x, 0.0)).a;
    
    // 주변 픽셀들의 투명도 합계 계산
    float outline = up_a + down_a + left_a + right_a;
    
    // 현재 픽셀은 투명한데 주변은 불투명하다면 -> 거기가 바로 외곽선!
    outline = step(0.1, outline) * (1.0 - current_a);
    
    // [수정된 부분] 
    // 시간(TIME)에 따라 0.0 ~ 1.0 사이를 왔다갔다하는 비율(ratio) 생성
    float ratio = (sin(TIME * shine_speed) + 1.0) / 2.0; 
    
    // 두 색상 사이를 ratio 비율만큼 섞음 (Mix)
    vec4 final_shine_color = mix(color_first, color_second, ratio);

    // 원래 이미지 색상 가져오기
    vec4 texture_color = texture(TEXTURE, UV);
    
    // 원래 이미지 위에 계산된 색상(final_shine_color)을 외곽선 부분에만 덮어씌움
    COLOR = mix(texture_color, final_shine_color, outline);
}
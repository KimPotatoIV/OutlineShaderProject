// shader_type은 셰이더의 종류를 지정
// canvas_item은 Godot에서 2D 노드에 적용되는 셰이더임을 의미함
// 즉, 이 셰이더는 2D 화면에 그려질 때 동작함
shader_type canvas_item;

// uniform 키워드는 셰이더 실행 전 또는 실행 중에 이 값을 외부에서 바꿀 수 있도록 함
// vec4는 4개의 부동소수점 숫자를 담는 자료형으로 여기서는 불투명한 빨간색을 의미
uniform vec4 outline_color = vec4(1.0, 0.0, 0.0, 1.0);
// 외곽선 두께를 의미하며, 여기서는 1.0px 두께를 의도함
uniform float outline_thickness = 1.0;

// 셰이더가 화면의 각 픽셀(fragment)에 대해 색상을 결정하는 함수
void fragment() {
	// TEXTURE_PIXEL_SIZE는 Godot이 자동으로 제공하는 변수로
	// 텍스처의 픽셀 하나 크기를 UV 좌표계(0.0 ~ 1.0) 단위로 나타냄
	// TEXTURE_PIXEL_SIZE가 vec2 형식이므로
	// outline_thickness를 vec2로 감싸서 곱함
	vec2 pixel = vec2(outline_thickness) * TEXTURE_PIXEL_SIZE;
	
	// texture(TEXTURE, UV)는 현재 픽셀 위치(UV)에서 텍스처(이미지)의 색상 정보를 가져옴
	float alpha = texture(TEXTURE, UV).a;
	
	// "위쪽 이웃 픽셀"의 투명도를 alpha_up에 저장
	float alpha_up = texture(TEXTURE, UV + vec2(0.0, -pixel.y)).a;
	// "아래쪽 이웃 픽셀"의 투명도를 alpha_down에 저장
	float alpha_down = texture(TEXTURE, UV + vec2(0.0,  pixel.y)).a;
	// "왼쪽 이웃 픽셀"의 투명도를 alpha_right에 저장
	float alpha_left = texture(TEXTURE, UV + vec2(-pixel.x, 0.0)).a;
	// "오른쪽 이웃 픽셀"의 투명도를 alpha_right에 저장
	float alpha_right = texture(TEXTURE, UV + vec2( pixel.x, 0.0)).a;
	
	// 현재 픽셀은 투명하지만 주변에 불투명한 픽셀(이미지 부분)이 있다면
	if (alpha == 0.0 && 
		(alpha_up > 0.0 || alpha_down > 0.0 || 
		alpha_left > 0.0 || alpha_right > 0.0))
	{
		// 해당 픽셀의 색상을 빨간색(외곽선 색)으로 설정
		// COLOR는 최종적으로 화면에 그려질 픽셀의 색상 변수
		COLOR = outline_color;
	}
	// 조건을 만족하지 않으면, 즉 외곽선 픽셀이 아니면
	else
	{
		// 원본 텍스처의 원래 색상을 그대로 가져와서 그림
		COLOR = texture(TEXTURE, UV);
	}
}

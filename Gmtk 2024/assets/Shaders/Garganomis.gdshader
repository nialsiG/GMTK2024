shader_type canvas_item;

uniform vec4 Color1;
uniform vec4 Color2;

const vec4 refColor = vec4(0.251, 0.243, 0.231, 1);

void fragment() {
	if (COLOR.r > 0.2 && COLOR.g > 0.2 && COLOR.b > 0.2)
	{
		if (COLOR.r <= refColor.r + 0.1
			&& COLOR.r >= refColor.r - 0.005
			&& COLOR.g <= refColor.g + 0.05
			&& COLOR.g >= refColor.g - 0.005
			&& COLOR.b <= refColor.b + 0.05
			&& COLOR.b >= refColor.b - 0.005)
		{
			vec4 offset = COLOR - refColor;
			COLOR = Color1 + offset;
		}
	}
}
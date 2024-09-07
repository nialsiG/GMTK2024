shader_type canvas_item;

uniform vec4 Color1;
uniform vec4 Color2;

const vec4 refColor = vec4(0.655, 0.31, 0.31, 1);

void fragment() {
	if (COLOR.r > 0.48 && COLOR.g > 0.25 && COLOR.b > 0.25)
	{
		if (COLOR.r <= refColor.r + 0.3
			&& COLOR.r >= refColor.r - 0.2
			&& COLOR.g <= refColor.g + 0.3
			&& COLOR.g >= refColor.g - 0.2
			&& COLOR.b <= refColor.b + 0.3
			&& COLOR.b >= refColor.b - 0.2)
		{
			vec4 offset = COLOR - refColor;
			COLOR = Color1 + offset;
		}
	}
}
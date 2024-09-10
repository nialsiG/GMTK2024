shader_type canvas_item;

uniform vec4 Color1;
uniform vec4 Color2;

const vec4 refColor = vec4(0.686, 0.702, 0.537, 1);

void fragment() {
	if (COLOR.a > 0.0)
	{
		if(COLOR.g > 0.4)
		{
			if(COLOR.r > 0.65 && COLOR.g > 0.65 && COLOR.b > 0.65)
			{
				//vec4 offset = COLOR - vec4(0.65,0.65,0.65, 1.0);
				//COLOR = Color2 + offset;
			}
			if (COLOR.r > 0.2 //&& COLOR.r < 0.99
				&& COLOR.g >= 0.4 //&& COLOR.g <=0.9
				&& COLOR.b >= 0.3) //&& COLOR.b <= 0.5)
			{
				vec4 offset = COLOR - refColor;
				COLOR = Color1 + offset;
			}
		}
	}
}
#pragma header
		
uniform float strength;
uniform float size;

uniform float red;
uniform float green;
uniform float blue;

void main()
{
	vec2 uv = openfl_TextureCoordv;
	vec4 col = flixel_texture2D(bitmap, uv);

	//modified from this
	//https://www.shadertoy.com/view/lsKSWR

	uv = uv * (1.0 - uv.yx);
	float vig = uv.x * uv.y * strength;
	vig = pow(vig, size);

	vig = 0.0 - vig + 1.0;

	vec3 vigCol = vec3((red / 255.0),(green / 255.0),(blue / 255.0));
	col.rgb += vigCol * vig;
	col.a += vig;

	gl_FragColor = col;
}
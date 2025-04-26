#pragma header

uniform float effect;
uniform float strength;

void main()
{
	vec2 uv = openfl_TextureCoordv;
	vec2 iResolution = vec2(1280.0, 720.0);
	vec2 res = 1.0 / iResolution;
	//vec4 color = ;

	if (effect <= 0.0)
	{
		gl_FragColor = flixel_texture2D(bitmap,uv);
		return;
	}

	vec4 color = vec4(0.0);
	vec2 off1 = vec2(0.0, 1.3333333333333333) * effect;
	vec2 off2 = vec2(1.3333333333333333);

	color += flixel_texture2D(bitmap, uv);

	color += flixel_texture2D(bitmap, (uv + (off1 * res)) + (off2 * res)) * 0.35294117647058826 * strength * 0.5;
	color += flixel_texture2D(bitmap, (uv - (off1 * res)) + (off2 * res)) * 0.35294117647058826 * strength * 0.5;
	color += flixel_texture2D(bitmap, (uv + (off1 * res)) - (off2 * res)) * 0.35294117647058826 * strength * 0.5;
	color += flixel_texture2D(bitmap, (uv - (off1 * res)) - (off2 * res)) * 0.35294117647058826 * strength * 0.5;

	gl_FragColor = color;
}
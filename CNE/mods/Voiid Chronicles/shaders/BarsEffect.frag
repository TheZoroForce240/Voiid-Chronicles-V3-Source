#pragma header

uniform float effect;

void main()
{
	vec2 uv = openfl_TextureCoordv.xy;
	vec4 Color = flixel_texture2D(bitmap, uv);
	
	if (uv.y < effect || uv.y > 1.0-effect)
	{
		Color = vec4(0.0, 0.0, 0.0, 1.0); //make sure alpha is 1 to stop other shaders being weird
	}
		
	
	gl_FragColor = Color;
}
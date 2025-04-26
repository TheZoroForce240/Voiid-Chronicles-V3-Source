#pragma header

uniform sampler2D bg;
uniform sampler2D prevBG;
uniform float fade;

void main()
{
	vec2 uv = openfl_TextureCoordv;
	gl_FragColor = flixel_texture2D(bitmap, uv) * mix(flixel_texture2D(bg, uv), flixel_texture2D(prevBG, uv), fade);
}
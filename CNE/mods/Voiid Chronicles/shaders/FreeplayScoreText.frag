#pragma header

void main()
{
	vec2 uv = openfl_TextureCoordv;
	vec4 color = flixel_texture2D(bitmap, uv);

	color *= mix(vec4(1.0, 0.0, 0.0, 1.0), vec4(1.0, 1.0, 1.0, 1.0), uv.y);

	gl_FragColor = color;
}
#pragma header
uniform sampler2D screenBitmap;
uniform float zoom;
uniform float width;
uniform float height;
uniform float scale;

vec4 getScreenSample(vec2 uv)
{
	uv.x *= 1.3;
	uv *= scale;
	//uv -= vec2(0.5, 0.5);

	uv *= 1.75;

	uv.x += 0.28;
	uv.y += 0.45;

	

	uv *= zoom;

	uv.x *= (1280.0 / width);
	uv.y *= (720.0 / height);

	vec4 color = flixel_texture2D(screenBitmap, uv);

	vec2 fragCoordShit = vec2(1280.0, 720.0)*uv;
	float apply = abs(sin(fragCoordShit.y)*0.5);
	vec3 finalCol = mix(color.rgb, vec3(0.0, 0.0, 0.0), apply);
	vec4 scanline = vec4(finalCol.r, finalCol.g, finalCol.b, color.a);
	
	return scanline;
}

void main()
{
	vec4 col = flixel_texture2D(bitmap, openfl_TextureCoordv);
	gl_FragColor = mix(getScreenSample(openfl_TextureCoordv), col, col.a);
}
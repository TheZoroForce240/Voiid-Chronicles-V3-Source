#pragma header

//based on https://www.shadertoy.com/view/Xdl3WH

#define PI 3.14159265358979323846

uniform float iTime;
uniform float strength;

vec3 blendNormal(vec3 base, vec3 blend) {
	return blend;
}

vec3 blendNormal(vec3 base, vec3 blend, float opacity) {
	return (blendNormal(base, blend) * opacity + base * (1.0 - opacity));
}

vec4 render( vec2 uv )
{            
	//funny mirroring shit
	if ((uv.x > 1.0 || uv.x < 0.0) && abs(mod(uv.x, 2.0)) > 1.0)
		uv.x = (0.0-uv.x)+1.0;
	if ((uv.y > 1.0 || uv.y < 0.0) && abs(mod(uv.y, 2.0)) > 1.0)
		uv.y = (0.0-uv.y)+1.0;

	return flixel_texture2D( bitmap, vec2(abs(mod(uv.x, 1.0)), abs(mod(uv.y, 1.0))) );
}

void main()
{
	vec2 fragCoord = openfl_TextureCoordv * openfl_TextureSize;
	vec2 iResolution = openfl_TextureSize;
	vec4 color = flixel_texture2D(bitmap, fragCoord.xy / iResolution.xy);

	vec2 p = (2.0 * fragCoord.xy / iResolution.xy - 1.0) * vec2(iResolution.x / iResolution.y, 1.0);
	vec2 uv = vec2(atan(p.y, p.x) * 1.0/PI, 1.0 / sqrt(dot(p, p))) * vec2(2.0, 1.0);
	
	//movement
	uv.y += iTime * 1.5;
	uv.x += sin(uv.y);
	uv.x += iTime * 0.25;
	
	color.rgb = blendNormal(render(uv).rgb, color.rgb, strength);
	
	gl_FragColor = color;
}
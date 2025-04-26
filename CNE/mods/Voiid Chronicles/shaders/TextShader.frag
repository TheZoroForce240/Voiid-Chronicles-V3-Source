#pragma header
		
uniform vec3 outerColorTop;
uniform vec3 outerColorBot;
uniform vec3 midColorTop;
uniform vec3 midColorBot;
uniform vec3 innerColorTop;
uniform vec3 innerColorBot;

uniform float strength;
uniform float intensity;

uniform float mixGap;

vec4 getSample(vec2 uv)
{
	vec4 col = flixel_texture2D(bitmap, uv);
	vec4 color = vec4(0.0,0.0,0.0,col.a);

	float m = ((uv.y-0.5)*mixGap)+0.5;

	color.rgb += col.r * mix(midColorTop, midColorBot, m);
	color.rgb += col.g * mix(innerColorTop, innerColorBot, m);
	color.rgb += col.b * mix(outerColorTop, outerColorBot, m);
	return color;
}


void main()
{
	vec2 uv = openfl_TextureCoordv;
	vec4 col = getSample(uv);

	if (strength <= 0.0)
	{
		gl_FragColor = col;
		return;
	}

	vec2 resFactor = (1.0/openfl_TextureSize.xy)*intensity;

	vec4 topLeft = getSample(vec2(uv.x-resFactor.x, uv.y-resFactor.y));
	vec4 topMiddle = getSample(vec2(uv.x, uv.y-resFactor.y));
	vec4 topRight = getSample(vec2(uv.x+resFactor.x, uv.y-resFactor.y));

	vec4 midLeft = getSample(vec2(uv.x-resFactor.x, uv.y));
	vec4 midRight = getSample(vec2(uv.x+resFactor.x, uv.y));

	vec4 bottomLeft = getSample(vec2(uv.x-resFactor.x, uv.y+resFactor.y));
	vec4 bottomMiddle = getSample(vec2(uv.x, uv.y+resFactor.y));
	vec4 bottomRight = getSample(vec2(uv.x+resFactor.x, uv.y+resFactor.y));

	vec4 Gx = (topLeft) + (2.0*midLeft) + (bottomLeft) - (topRight) - (2.0*midRight) - (bottomRight);
	vec4 Gy = (topLeft) + (2.0*topMiddle) + (topRight) - (bottomLeft) - (2.0*bottomMiddle) - (bottomRight);
	vec4 G = sqrt((Gx*Gx) + (Gy*Gy));

	G = col + G;
	G.a = col.a;


	gl_FragColor = mix(col, G, strength);
}
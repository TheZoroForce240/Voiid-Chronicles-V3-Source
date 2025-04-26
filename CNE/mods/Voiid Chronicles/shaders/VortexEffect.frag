#pragma header

//forked from https://www.shadertoy.com/view/Md3SWH

uniform float iTime;
uniform vec3 spiralColor;

uniform float hue;
uniform float sat;
uniform float brt;

float radius = 20.0;
float radiusInv = 0.05;

vec3 rgb2hsv(vec3 c)
{
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

//noise funcs: https://gist.github.com/patriciogonzalezvivo/670c22f3966e662d2f83
float mod289(float x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 mod289(vec4 x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 perm(vec4 x){return mod289(((x * 34.0) + 1.0) * x);}

float noise(vec3 p){
	vec3 a = floor(p);
	vec3 d = p - a;
	d = d * d * (3.0 - 2.0 * d);

	vec4 b = a.xxyy + vec4(0.0, 1.0, 0.0, 1.0);
	vec4 k1 = perm(b.xyxy);
	vec4 k2 = perm(k1.xyxy + b.zzww);

	vec4 c = k2 + a.zzzz;
	vec4 k3 = perm(c);
	vec4 k4 = perm(c + 1.0);

	vec4 o1 = fract(k3 * (1.0 / 41.0));
	vec4 o2 = fract(k4 * (1.0 / 41.0));

	vec4 o3 = o2 * d.z + o1 * (1.0 - d.z);
	vec2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

	return o4.y * d.y + o4.x * (1.0 - d.y);
}

float fbm(vec3 pos)
{
	vec3 q = pos;
	float f  = 0.5*noise( q ); q = q*2.01;
	f += 0.2500*noise( q ); q = q*2.02;
	f += 0.1250*noise( q ); q = q*2.03;
	f += 0.0625*noise( q ); q = q*2.01;
	return f;
}

float galaxyNoise(vec2 uv, float angle, float speed)
{
	float dist = length(uv);    
	float percent = max(0.0, (radius - dist) * radiusInv);
	float theta = iTime * speed + percent * percent * angle;
	vec2 cs = vec2(cos(theta), sin(theta));
	uv *= mat2(cs.x, -cs.y, cs.y, cs.x);
	
	float n = abs(fbm(vec3(uv, iTime) * 0.2) - 0.5) * 2.5;
	float nSmall = smoothstep(0.2, 0.0, n);
	
	float result = 0.0;
	result += nSmall * 0.6;
	result += n;
	result += smoothstep(0.75, 1.0, percent);
	result *= smoothstep(0.2, 0.7, percent);
	return pow(result, 2.0);
}

vec3 galaxy(vec2 uv)
{
	float f = 0.0;
	f += galaxyNoise(uv * 1.0, 9.0, 0.15) * 0.5;
	f += galaxyNoise(uv * 1.3, 11.0, -0.1) * 0.6;
	f += galaxyNoise(uv * 1.6, 8.0, 0.1) * 0.7;
	f = max(0.0, f);
	
	vec3 color = mix(spiralColor, vec3(0.0, 0.0, 0.0), length(uv) * radiusInv); 
	color *= f;
	
	return color;
}

void main()
{
	vec2 uv = openfl_TextureCoordv.xy-0.5;

	//vec2 uv = (fragCoord.xy / iResolution.xy - vec2(0.5)) * vec2(iResolution.x / iResolution.y, 1.);
	uv *= 5.0 + 0.0 * cos(iTime * 0.3);
	vec4 color = vec4(galaxy(uv * 3.0),1.0);

	vec4 swagColor = vec4(rgb2hsv(vec3(color[0], color[1], color[2])), color[3]);
	swagColor[0] = swagColor[0] + hue;
	swagColor[1] = swagColor[1] + sat;
	swagColor[2] = swagColor[2] * (1.0 + brt);
	if(swagColor[1] < 0.0)
	{
		swagColor[1] = 0.0;
	}
	else if(swagColor[1] > 1.0)
	{
		swagColor[1] = 1.0;
	}
	gl_FragColor = vec4(hsv2rgb(vec3(swagColor[0], swagColor[1], swagColor[2])), swagColor[3]);
}
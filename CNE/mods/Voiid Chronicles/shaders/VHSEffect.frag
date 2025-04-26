#pragma header

uniform float iTime;
uniform float chromaStrength;
uniform float effect;

float barC = 7.5;
float barSpeed = 3.5;
float barHeight = 0.06;


//noise funcs: https://gist.github.com/patriciogonzalezvivo/670c22f3966e662d2f83
float rand(vec2 n) { 
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 p){
	vec2 ip = floor(p);
	vec2 u = fract(p);
	u = u*u*(3.0-2.0*u);
	
	float res = mix(
		mix(rand(ip),rand(ip+vec2(1.0,0.0)),u.x),
		mix(rand(ip+vec2(0.0,1.0)),rand(ip+vec2(1.0,1.0)),u.x),u.y);
	return res*res;
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

float getNoise(vec2 p)
{
	return noise(p)-0.5; //set from 0-1 to -0.5 to 0.5;
}

float getBar(vec2 uv)
{
	return clamp((sin(uv.y * barC - (-iTime*barSpeed)) - (1.0-barHeight)) * noise(vec2(iTime)), 0.0, 0.05); //clamp at 0.05 to only get that part of the wave
}


void main(){
	vec2 uv = openfl_TextureCoordv;
	vec4 col = vec4(0.0, 0.0, 0.0, 0.0);
	
	//noise offsets
	uv.x += getNoise(vec2(uv.y, iTime))*0.005;
	uv.x += getNoise(vec2(uv.y*1000.0, iTime*10.0))*0.008;
	
	float bar = getBar(uv);
	float barNoise = getNoise(vec2(uv.y*500.0, iTime*15.0))*3.0;
	uv.x = uv.x - (bar*barNoise);
		
	col = render(uv);
	vec4 defaultCol = render(openfl_TextureCoordv);
	col.rgb *= 0.5; //the other 0.5 gets added after with chroma
	float offset = chromaStrength;
	
	col.r += render(uv + vec2( -1.0, 0.0 )*offset ).r * 0.25; //blurred chromatic aberration
	col.g += render(uv + vec2( -2.0, 0.0 )*offset ).g * 0.25;
	col.b += render(uv + vec2( -3.0, 0.0 )*offset ).b * 0.25;
	col.r += render(uv + vec2( 1.0, 0.0 )*offset ).r * 0.25;
	col.g += render(uv + vec2( 2.0, 0.0 )*offset ).g * 0.25;
	col.b += render(uv + vec2( 3.0, 0.0 )*offset ).b * 0.25;
	
	gl_FragColor = mix(defaultCol, col, effect);
}
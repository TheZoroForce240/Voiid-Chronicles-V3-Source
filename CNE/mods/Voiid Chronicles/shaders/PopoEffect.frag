#pragma header

float PI = 3.14159;
float rad = 3.14159/180.0;
float doublePI = 3.14159*2.0;
float BEAMWIDTH = 0.7;
float BEAMFALL = 0.7;
uniform float strength;
uniform float spinspeed;
uniform float iTime;


float beam(vec2 uv, vec2 pos, float angle)
{
	float a = atan(uv.y - pos.y, uv.x - pos.x) - PI*0.5;

	float fa = (a);
	float fl = (angle-BEAMWIDTH);
	float fr = (angle+BEAMWIDTH);
	
	if ((fa > fl && fa < fr))
	{
		//return 1.0;
		return abs(0.0-abs((angle)-a)+BEAMFALL)*strength;
	}
	else if ((fr >= PI && fa+doublePI < fr)) //fix for edge cutoff with the angle
	{
		return abs(0.0-abs((angle)-(a+doublePI))+BEAMFALL)*strength;
	}
	else if ((fl <= -PI && fa-doublePI > fl))
	{
		return abs(0.0-abs((angle)-(a-doublePI))+BEAMFALL)*strength;
	}
	return 0.0;
}

void main()
{
	vec2 uv = openfl_TextureCoordv.xy;
	vec3 col = flixel_texture2D(bitmap,uv).rgb;
	vec2 iResolution = vec2(1280.0,720.0);
	
	//col.r += beam(uv, vec2(1.0,0.0), sin(iTime));
	//col.b += beam(uv, vec2(1.0,0.0), cos(iTime));
	
	float t = iTime*-spinspeed;
	
	float angleTime = (mod(t*180.0, 360.0)-180.0) * rad;
	float angleTime2 = (mod((t*180.0)+180.0, 360.0)-180.0) * rad;
	float angleTime3 = (mod((t*180.0)+45.0, 360.0)-180.0) * rad;
	float angleTime4 = (mod((t*180.0)-135.0, 360.0)-180.0) * rad;
	
	vec2 fragCoord = uv*iResolution.xy;

	float y = (sin(iTime)*0.5)+0.5;
	float y2 = (sin(-iTime)*0.5)+0.5;

	col.r += beam(fragCoord, vec2(0.0,y)*iResolution.xy, angleTime);
	col.b += beam(fragCoord, vec2(0.0,y)*iResolution.xy, angleTime2);
	col.r += beam(fragCoord, vec2(1.0,y2)*iResolution.xy, -angleTime3);
	col.b += beam(fragCoord, vec2(1.0,y2)*iResolution.xy, -angleTime4);
	
	gl_FragColor = vec4(col,flixel_texture2D(bitmap,uv).a);
}
#pragma header
//uniform float tx, ty; // x,y waves phase
uniform float iTime;

const int EFFECT_TYPE_DREAMY = 0;
const int EFFECT_TYPE_WAVY = 1;
const int EFFECT_TYPE_HEAT_WAVE_HORIZONTAL = 2;
const int EFFECT_TYPE_HEAT_WAVE_VERTICAL = 3;
const int EFFECT_TYPE_FLAG = 4;

uniform int effectType;

/**
	* How fast the waves move over time
	*/
uniform float waveSpeed;

/**
	* Number of waves over time
	*/
uniform float waveFrequency;

/**
	* How much the pixels are going to stretch over the waves
	*/
uniform float waveAmplitude;

vec2 sineWave(vec2 pt)
{
	float x = 0.0;
	float y = 0.0;
	
	if (effectType == EFFECT_TYPE_DREAMY) 
	{
		float offsetX = sin(pt.y * waveFrequency + iTime * waveSpeed) * waveAmplitude;
		pt.x += offsetX; // * (pt.y - 1.0); // <- Uncomment to stop bottom part of the screen from moving
	}
	else if (effectType == EFFECT_TYPE_WAVY) 
	{
		float offsetY = sin(pt.x * waveFrequency + iTime * waveSpeed) * waveAmplitude;
		pt.y += offsetY; // * (pt.y - 1.0); // <- Uncomment to stop bottom part of the screen from moving
	}
	else if (effectType == EFFECT_TYPE_HEAT_WAVE_HORIZONTAL)
	{
		x = sin(pt.x * waveFrequency + iTime * waveSpeed) * waveAmplitude;
	}
	else if (effectType == EFFECT_TYPE_HEAT_WAVE_VERTICAL)
	{
		y = sin(pt.y * waveFrequency + iTime * waveSpeed) * waveAmplitude;
	}
	else if (effectType == EFFECT_TYPE_FLAG)
	{
		y = sin(pt.y * waveFrequency + 10.0 * pt.x + iTime * waveSpeed) * waveAmplitude;
		x = sin(pt.x * waveFrequency + 5.0 * pt.y + iTime * waveSpeed) * waveAmplitude;
	}
	
	return vec2(pt.x + x, pt.y + y);
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
	vec2 uv = sineWave(openfl_TextureCoordv);
	gl_FragColor = render(uv);
}
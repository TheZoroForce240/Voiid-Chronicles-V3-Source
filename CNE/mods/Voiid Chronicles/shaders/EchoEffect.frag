#pragma header

vec3 borderCol = vec3(0.353, 0.024, 0.439);
vec3 innerCol = vec3(0.671, 0.09, 0.722);

vec4 getCol(vec2 uv)
{
	vec4 spritecolor = flixel_texture2D(bitmap, uv);    

	spritecolor.rgb /= 3.0;

	if (spritecolor.r < 0.05 && spritecolor.g < 0.05 && spritecolor.b < 0.05)
	{
		spritecolor.rgb = borderCol*1.3*spritecolor.a;
	}   
	else if (spritecolor.r > 0.31 && spritecolor.g > 0.31 && spritecolor.b > 0.31)
	{
		spritecolor.rgb *= 3.0;
	}
	else 
	{
		spritecolor.rgb = innerCol*1.3*spritecolor.a;
	}
	return spritecolor;
}
		
void main()
{	
	vec2 uv = openfl_TextureCoordv.xy;
	

	vec4 color = vec4(0.0);
	vec2 offset = vec2(8.0) / openfl_TextureSize;
	float intensity = 2.0;

	if (getCol(uv).a < 0.5) //blur
	{
		float mult = 0.0;
		mult += getCol(uv).a;
		mult += getCol(uv + vec2(offset.x, 0.0)).a;
		mult += getCol(uv - vec2(offset.x, 0.0)).a;
		mult += getCol(uv + vec2(0.0, offset.y)).a;
		mult += getCol(uv - vec2(0.0, offset.y)).a;
		//mult += getCol(uv + vec2(offset.x, offset.y)).a;
		//mult += getCol(uv - vec2(offset.x, offset.y)).a;
		//mult += getCol(uv + vec2(-offset.x, offset.y)).a;
		//mult += getCol(uv - vec2(-offset.x, offset.y)).a;
		
		mult = mult/5.0;
		color.rgb = innerCol*mult;
		color.a = mult;
	}
	else 
	{
		color = getCol(uv);
	}



	//vec4 spritecolor = getCol(uv);

	gl_FragColor = color;
}
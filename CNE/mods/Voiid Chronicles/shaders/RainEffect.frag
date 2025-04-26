#pragma header
	
uniform float iTime;

vec2 rand(vec2 c){
	mat2 m = mat2(12.9898,0.16180,78.233,0.31415);
	return fract(sin(m * c) * vec2(43758.5453, 14142.1));
}

vec2 noise(vec2 p){
	vec2 co = floor(p);
	vec2 mu = fract(p);
	mu = 3.0*mu*mu-2.0*mu*mu*mu;
	vec2 a = rand((co+vec2(0.0,0.0)));
	vec2 b = rand((co+vec2(1.0,0.0)));
	vec2 c = rand((co+vec2(0.0,1.0)));
	vec2 d = rand((co+vec2(1.0,1.0)));
	return mix(mix(a, b, mu.x), mix(c, d, mu.x), mu.y);
}

vec2 round(vec2 num)
{
	num.x = floor(num.x + 0.5);
	num.y = floor(num.y + 0.5);
	return num;
}




void main()
{	
	vec2 iResolution = vec2(1280.0,720.0);
	vec2 c = openfl_TextureCoordv.xy;

	vec2 u = c,
			v = (c*0.1),
			n = noise(v*200.0); // Displacement
	
	vec4 f = flixel_texture2D(bitmap, openfl_TextureCoordv.xy);
	
	// Loop through the different inverse sizes of drops
	for (float r = 4.0 ; r > 0.0 ; r--) {
		vec2 x = iResolution.xy * r * 0.015,  // Number of potential drops (in a grid)
				p = 6.28 * u * x + (n - 0.5) * 2.0,
				s = sin(p);
		
		// Current drop properties. Coordinates are rounded to ensure a
		// consistent value among the fragment of a given drop.
		vec2 v = round(u * x - 0.25) / x;
		vec4 d = vec4(noise(v*200.0), noise(v));
		
		// Drop shape and fading
		float t = (s.x+s.y) * max(0.0, 1.0 - fract(iTime * (d.b + 0.1) + d.g) * 2.0);
		
		// d.r -> only x% of drops are kept on, with x depending on the size of drops
		if (d.r < (5.0-r)*0.08 && t > 0.5) {
			// Drop normal
			vec3 v = normalize(-vec3(cos(p), mix(0.2, 2.0, t-0.5)));
			// fragColor = vec4(v * 0.5 + 0.5, 1.0);  // show normals
			
			// Poor mans refraction (no visual need to do more)
			f = flixel_texture2D(bitmap, u - v.xy * 0.3);
		}
	}
	gl_FragColor = f;
}
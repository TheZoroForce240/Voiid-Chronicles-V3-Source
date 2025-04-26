#pragma header

//built off of a shadertoy tutorial: https://inspirnathan.com/posts/53-shadertoy-tutorial-part-7/

const int MAX_MARCHING_STEPS = 50;
const int MAX_MARCHING_STEPS_REFLECTION = 150;
const float MIN_DIST = 0.0;
const float MAX_DIST = 25.0;
const float PRECISION = 0.001;
const float EPSILON = 0.0005;
const float PI = 3.14159;
const float ASPECTRATIO = 1.77777;
const float ASPECTRATIOINV = 0.5625;

uniform float tilt;

//camera stuffs
uniform float x;
uniform float y;
uniform float z;
uniform float pitch;
uniform float yaw;


uniform float boxX0;
uniform float boxY0;
uniform float boxZ0;

uniform float boxAngleX0;
uniform float boxAngleY0;
uniform float boxAngleZ0;

uniform float boxDepth;


struct Surface {
	float sd; // signed distance value
	vec3 p;
	vec4 col; // color
};

// Rotation matrix around the X axis.
mat3 rotateX(float theta) 
{
	float c = cos(theta);
	float s = sin(theta);
	return mat3(
		vec3(1.0, 0.0, 0.0),
		vec3(0.0, c, -s),
		vec3(0.0, s, c)
	);
}

// Rotation matrix around the Y axis.
mat3 rotateY(float theta)
{
	float c = cos(theta);
	float s = sin(theta);
	return mat3(
		vec3(c, 0.0, s),
		vec3(0.0, 1.0, 0.0),
		vec3(-s, 0.0, c)
	);
}

// Rotation matrix around the Z axis.
mat3 rotateZ(float theta) 
{
	float c = cos(theta);
	float s = sin(theta);
	return mat3(
		vec3(c, -s, 0.0),
		vec3(s, c, 0.0),
		vec3(0.0, 0.0, 1.0)
	);
}

vec3 opCheapBend(vec3 p, float freq, float amp)
{
	float c = cos(freq*p.x)*amp;
	//float s = sin(k*p.x+2.0);
	//mat2  m = mat2(c,-s,s,c);
	vec3  q = vec3(p.x,c+p.y,p.z);
	return q;
}

///////////////////////shapes


vec2 repeatUV(vec2 uv)
{
	//funny mirroring shit
	if ((uv.x > 1.0 || uv.x < 0.0) && abs(mod(uv.x, 2.0)) > 1.0)
		uv.x = (0.0-uv.x)+1.0;
	if ((uv.y > 1.0 || uv.y < 0.0) && abs(mod(uv.y, 2.0)) > 1.0)
		uv.y = (0.0-uv.y)+1.0;

	return vec2(abs(mod(uv.x, 1.0)), abs(mod(uv.y, 1.0)));
}

vec2 getUV3D(vec3 p)
{
	vec2 uvThing = vec2(p.x,p.y) * 0.5; //need to add its offset to match shit
	vec2 center = vec2(-0.5, -0.5);
	uvThing.y *= ASPECTRATIO;
	uvThing += center;
	uvThing.y = -uvThing.y; //needs to flip to match the camera flip bullshit
	uvThing.x = -uvThing.x;  
	return uvThing;
}


const float upperBound = 10.0;
const float g = sin(atan(1.,upperBound));


Surface sdBox( vec3 p, vec3 scale, vec3 offset, vec4 col, mat3 transform)
{
	
	p = (p - offset) * transform;

	col = flixel_texture2D(bitmap, repeatUV(getUV3D(p)));

	//float depthOffset = floor(length(col.rgb));

	//p.z -= depthOffset*boxDepth;
	//p.z *= g;

	/*
	float depthOffset = floor(grayScale(col)*3.0)/3.0; //get depth

	if (depthOffset <= 0.0)
	{
		//col.rgb = vec3(1.0, 0.0, 0.0);
		//p.z -= depthOffset*0.2;
		//p.z *= g;

		p.z += boxDepth;
	}
	p.z *= g;

	*/

	//im going insane

	if (col.a > 0.2) //add depth to colors that are above that alpha
	{
		p.z -= boxDepth;

		if (p.z <= boxDepth) //if on the side
		{
			col.a = 1.0;
			//col.rgb = vec3(1.0, 0.0, 0.0);
		}
		
	}
	p.z *= g; //multiply by constant for making depth shit work idk

	vec3 q = abs(p) - scale;    
	
	float d = length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);

	return Surface(d, p, col);
}



////////////////////////////

//checks which object is in front
Surface opUnion(Surface obj1, Surface obj2) {
	if (obj2.sd < obj1.sd) return obj2;
	return obj1;
}



///the scene///////////////

Surface scene(vec3 p) {

	float rad = PI/180.0;

	Surface co = sdBox(p, vec3(1.0, ASPECTRATIOINV, (0.01)), vec3(boxX0, boxY0, boxZ0), vec4(0.0, 0.0, 0.0, 0.0), rotateZ(boxAngleZ0*rad) * rotateX(boxAngleX0*rad) * rotateY(boxAngleY0*rad));


	//if (useFNFBox)
	//co = opUnion(co, sdFloor(p, floorPosition, vec4(0.0, 0.0, 0.0, 0.0)) );
	//co = opUnion(co, sdBox(p, vec3(1.0, ASPECTRATIOINV, (0.01)), boxPosition2, vec4(0.0, 0.0, 0.0, 0.0), rotateZ(boxRotation2[2]) * rotateX(boxRotation2[0]) * rotateY(boxRotation2[1])));
	
	//co = opUnion(co, sdSphere(p, 1.0, spherePosition, vec4(0.0, 0.0, 0.0, 0.0), rotateZ(sphereRotation[2]) * rotateX(sphereRotation[0]) * rotateY(sphereRotation[1])));



	return co;
}



/////////////////////////////

Surface rayMarch(vec3 ro, vec3 rd) {
float depth = MIN_DIST;
Surface co; // closest object

for (int i = 0; i < MAX_MARCHING_STEPS; i++) {
	vec3 p = ro + depth * rd;
	co = scene(p);
	depth += co.sd;
	if (co.sd < PRECISION || depth > MAX_DIST) break;
}

co.sd = depth;

return co;
}

mat3 camera(vec3 cameraPos, vec3 lookAtPoint) {
	vec3 cd = normalize(lookAtPoint - cameraPos); // camera direction
	vec3 cr = normalize(cross(vec3(0.0, -1.0, 0.0), cd)); // camera right
	vec3 cu = normalize(cross(cd, cr)); // camera up
	
	return mat3(-cr, cu, -cd);
}

vec3 getLookAt(float y, float p)
{
vec3 pos = vec3(0.0,0.0,0.0);
float rad = (PI/180.0);
pos.x = cos(y * rad) * cos(p * rad);
pos.y = sin(p * rad);
pos.z = sin(y * rad) * cos(p * rad);
return pos;
}

void main()
{
vec2 center = vec2(0.5, 0.5);
vec2 uv = openfl_TextureCoordv.xy - center; //offset shit

uv.y *= ASPECTRATIOINV; //fix aspect ratio
	
vec4 backgroundColor = vec4(0.0,0.0,0.0,0.0);

mat2 rotation = mat2(
	cos(tilt), -sin(tilt),
	sin(tilt), cos(tilt) );

vec4 col = vec4(0.0,0.0,0.0,0.0);
vec3 ro = vec3(x, y, z); // ray origin that represents camera position
vec3 rd = vec3(0.0); // ray direction

vec3 lp = getLookAt(yaw, pitch); // lookat point (aka camera target)
rd = camera(ro, lp) * normalize(vec3(uv*rotation, -1.0)); // ray direction

	

Surface co = rayMarch(ro, rd); // closest object

if (co.sd > MAX_DIST) {
	col = backgroundColor; // ray didnt hit anything
} else {

	//col = flixel_texture2D(bitmap, repeatUV(getUV3D(co.p)));
	col = co.col;
}

	//col = mix(col, backgroundColor, 1.0 - exp(fogAmount * co.sd * co.sd * co.sd)); // fog
	//col = pow(col, vec3(1.0/1.1)); // Gamma correction
	gl_FragColor = col; // Output to screen
}
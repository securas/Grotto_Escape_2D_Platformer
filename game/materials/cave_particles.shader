shader_type particles;

uniform float vextent = 180.0;

float rand_from_seed(inout uint seed) {
	int k;
	int s = int(seed);
	if (s == 0)
	s = 305420679;
	k = s / 127773;
	s = 16807 * (s - k * 127773) - 2836 * k;
	if (s < 0)
		s += 2147483647;
	seed = uint(s);
	return float(seed % uint(65536)) / 65535.0;
}

uint hash(uint x) {
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = (x >> uint(16)) ^ x;
	return x;
}

vec2 rotate2d( in vec2 v, float a )
{
	vec2 y = vec2( v.x * cos( a ) - v.y * sin( a ), v.x * sin( a ) + v.y * cos( a ) );
	return y;
}

void vertex() {
	uint base_number = NUMBER;
	uint alt_seed = hash(base_number + uint(1) + RANDOM_SEED);
	//float angle_rand = rand_from_seed(alt_seed);
	
	if( RESTART )
	{
		TRANSFORM[3].y = ( rand_from_seed(alt_seed) - 0.5 ) * vextent * 2.0;
		VELOCITY.x = -5.0 - 15.0 * rand_from_seed(alt_seed);
		VELOCITY.y = 2.0 + 2.0 * rand_from_seed(alt_seed);
	}
	else
	{
		float a = 0.2 * DELTA;
		mat4 temp;
		temp[0].x = cos(a) * TRANSFORM[0].x - sin(a) * TRANSFORM[0].y;
		temp[0].y = sin(a) * TRANSFORM[0].x + cos(a) * TRANSFORM[0].y;
		temp[1].x = cos(a) * TRANSFORM[1].x - sin(a) * TRANSFORM[1].y;
		temp[1].y = sin(a) * TRANSFORM[1].x + cos(a) * TRANSFORM[1].y;
		TRANSFORM[0].xy = temp[0].xy;
		TRANSFORM[1].xy = temp[1].xy;
		
		//TRANSFORM = rotmatrix * TRANSFORM;
	}
}


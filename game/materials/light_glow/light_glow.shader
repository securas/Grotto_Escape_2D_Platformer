shader_type canvas_item;

void fragment()
{
	vec4 c = textureLod( TEXTURE, UV, 0.0 ); // the color of the current point
	vec3 normal = vec3( 0.0, 0.0, 1.0 ); // create a vector corresponding to the normal at this point
	if( c.a > 0.0 )
	{
		vec2 hnormal = NORMAL.xy;
		// normalize normal
		normal = NORMAL;
		
		// show the edge when at the light pass
		if( ( abs( hnormal.x ) > 0.0 || abs( hnormal.y ) > 0.0 ) && AT_LIGHT_PASS )
		{
			c.rgb = vec3( 1.0 );
		}
	}
	// set the normal for the light shader
	NORMAL = normal;
	COLOR = c;
}

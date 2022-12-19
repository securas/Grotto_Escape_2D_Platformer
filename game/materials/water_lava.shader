shader_type canvas_item;

void fragment()
{
	vec2 uv = UV;
	float x_offset = floor( fract( TIME ) * 3.0 );
	uv.x += x_offset * 32.0 * TEXTURE_PIXEL_SIZE.x;
	COLOR = texture( TEXTURE, uv );
}
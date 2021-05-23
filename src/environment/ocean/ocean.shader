shader_type canvas_item;

uniform vec4 modulate = vec4(0.0, 0.58, 1.0, 1.0);
uniform vec2 offset_coord = vec2(0.0, 0.0);

// Gonkee's noise textures, original video: https://youtu.be/ybbJz6C9YYA
// this file heavily references https://thebookofshaders.com/

float rand(vec2 coord){
	// prevents randomness decreasing from coordinates too large
	coord = mod(coord + offset_coord, 5000.0);
	// returns "random" float between 0 and 1
	return fract(sin(dot(coord, vec2(12.9898,78.233))) * 43758.5453);
}

vec2 rand2( vec2 coord ) {
	// prevents randomness decreasing from coordinates too large
	coord = mod(coord + offset_coord, 5000.0);
	// returns "random" vec2 with x and y between 0 and 1
    return fract(sin( vec2( dot(coord,vec2(127.1,311.7)), dot(coord,vec2(269.5,183.3)) ) ) * 43758.5453);
}

float cellular_noise(vec2 coord) {
	vec2 i = floor(coord);
	vec2 f = fract(coord);
	
	float min_dist = 99999.0;
	// going through the current tile and the tiles surrounding it
	for(float x = -1.0; x <= 1.0; x++) {
		for(float y = -1.0; y <= 1.0; y++) {
			
			// generate a random point in each tile,
			// but also account for whether it's a farther, neighbouring tile
			vec2 node = rand2(i + vec2(x, y)) + vec2(x, y);
			
			// check for distance to the point in that tile
			// decide whether it's the minimum
			float dist = sqrt((f - node).x * (f - node).x + (f - node).y * (f - node).y);
			min_dist = min(min_dist, dist);
		}
	}
	return min_dist;
}

void fragment() {
	vec2 coord = UV * 10.0;
	
	float noise;
//	noise = rand(coord);
	noise = cellular_noise(coord);
	
	COLOR = vec4(vec3(noise), 1.0) * modulate;
	float min_color = .2;
	COLOR = vec4(COLOR.r, COLOR.g, max(COLOR.b, min_color), COLOR.a);
}
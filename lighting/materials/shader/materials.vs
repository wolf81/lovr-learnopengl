out vec3 fragPos;
out vec3 normal;

vec4 lovrmain() {
	fragPos = vec3(Transform * VertexPosition);
	normal = mat3(transpose(inverse(Transform))) * VertexNormal;

	return Projection * View * Transform * VertexPosition;
}
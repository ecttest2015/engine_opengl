#version 330

layout (location = 0) in vec3 inPosition;
layout (location = 1) in vec2 inCoord;
layout (location = 2) in vec3 inNormal;
layout (location = 3) in vec3 inTangent;

uniform mat4 mvp;
uniform mat4 camView;
uniform mat4 transform;
uniform vec3 lightDir;
uniform vec3 cameraDir;
uniform mat4 depthBiasMVP_0;
uniform mat4 depthBiasMVP_1;

smooth out vec3 vPosition;
smooth out vec2 vTexCoord;
smooth out vec3 pNormal;
smooth out vec4 camViewCoord;
smooth out vec4 shadowMapCoord_0;
smooth out vec4 shadowMapCoord_1;

out vec3 vLightDirTanSpace;
out vec3 vEyeDirTanSpace;

void main()
{	
	vPosition = vec3(transform * vec4(inPosition, 1.0));
	
	gl_Position = mvp*vec4(inPosition, 1.0);
	vTexCoord = inCoord;
	pNormal = inNormal;
		
	camViewCoord = camView * vec4(inPosition, 1.0);
	shadowMapCoord_0 = depthBiasMVP_0 * vec4(inPosition, 1.0);
	shadowMapCoord_1 = depthBiasMVP_1 * vec4(inPosition, 1.0);
	
	vec3 t, b, n;
	t = inTangent;
	b = cross(t,inNormal);
	b = normalize(b);
	n = cross(b, t);
	n = normalize(n);
	
	vLightDirTanSpace.x = dot(lightDir, b);
	vLightDirTanSpace.y = dot(lightDir, t);
	vLightDirTanSpace.z = dot(lightDir, n);
	vLightDirTanSpace = normalize(vLightDirTanSpace);

	vEyeDirTanSpace.x = dot(cameraDir, b);
	vEyeDirTanSpace.y = dot(cameraDir, t);
	vEyeDirTanSpace.z = dot(cameraDir, n);
	vEyeDirTanSpace = normalize(vEyeDirTanSpace);
}
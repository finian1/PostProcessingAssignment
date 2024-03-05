#include "Common.hlsli"

//--------------------------------------------------------------------------------------
// Textures (texture maps)
//--------------------------------------------------------------------------------------

// The scene has been rendered to a texture, these variables allow access to that texture
Texture2D    SceneTexture : register(t0);
SamplerState PointSample  : register(s0);

Texture2D    DistortMap    : register(t1);
SamplerState TrilinearWrap : register(s1);

float4 main(PostProcessingInput input) : SV_Target
{
	const float lightStrength = 0.015f;
	const float3 waterColour = float3(0.7, 0.7, 1.0);

	float3 distortTexture = DistortMap.Sample(TrilinearWrap, input.areaUV + float2(gShiftTime, gShiftTime)).rgb;

	float2 distortVector = distortTexture.gb;
	distortVector -= float2(0.5f, 0.5f);

	// Simple fake diffuse lighting formula based on 2D vector, light coming from top-left
	float light = dot(normalize(distortVector), float2(0.707f, 0.707f)) * lightStrength;

	// Get final colour by adding fake light colour plus scene texture sampled with distort texture offset
	float3 outputColour = light + SceneTexture.Sample(PointSample, input.sceneUV + gDistortLevel * distortVector).rgb * waterColour;

	return float4(outputColour, 1.0f);
}
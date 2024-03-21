#include "Common.hlsli"

Texture2D SceneTexture : register(t0);
SamplerState PointSample : register(s0);

Texture2D LowResTexture : register(t1);

float4 main(PostProcessingInput input) : SV_Target
{
// To make:
// Create lower resolution texture of scene
// Pass low res texture to retro shader
// Pass pallete to shader
// Determine which colour in the pallete the current pixel is closet to.
	return float4(0,0,0,0);
}
#include "Common.hlsli"


// The scene has been rendered to a texture, these variables allow access to that texture
Texture2D SceneTexture : register(t0);
SamplerState PointSample : register(s0); // We don't usually want to filter (bilinear, trilinear etc.) the scene texture when
  
Texture2D BloomMask : register(t1);


// Post-processing shader that tints the scene texture to a given colour
float4 main(PostProcessingInput input) : SV_Target
{
	// Sample a pixel from the scene texture
    float3 colour = SceneTexture.Sample(PointSample, input.sceneUV).rgb;
	// Got the RGB from the scene texture, set alpha to 1 for final output
    colour += BloomMask.Sample(PointSample, input.sceneUV).rgb * gBloomStrength;
    return float4(colour, 1.0f);
}
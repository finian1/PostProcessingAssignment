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
    float3 lowResColour = LowResTexture.Sample(PointSample, input.sceneUV).rgb;
	
    float3 finalColour;
    float colourDist = 999.0f;
    for (int i = 0; i < 8; i++)
    {
        float currentColourDist = sqrt(pow(lowResColour.r - gRetroColourPalette[i].r, 2) +
                pow(lowResColour.g - gRetroColourPalette[i].g, 2) +
                pow(lowResColour.b - gRetroColourPalette[i].b, 2));
        if(currentColourDist < colourDist)
        {
            colourDist = currentColourDist;
            finalColour = gRetroColourPalette[i].rgb;
        }
    }
	
    return float4(finalColour, 1.0);
}
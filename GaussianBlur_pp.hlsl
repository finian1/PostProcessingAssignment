#include "Common.hlsli"

Texture2D SceneTexture : register(t0);
SamplerState PointSample : register(s0);

float4 main(PostProcessingInput input) : SV_Target
{
    float4 result = { 0,0,0,0 };
    float2 size;
    SceneTexture.GetDimensions(size.x, size.y);
    
    for (int i = 0; i < 21; i++)
    {
        float2 offset = gGaussianBlurDirection * gGaussianOffsets[i] / size;
        float weight = gGaussianWeights[i];
        result += SceneTexture.Sample(PointSample, input.sceneUV + offset) * weight;
    }
    float3 colour = result;
    float softEdge = 0.20f; // Softness of the edge of the circle - range 0.001 (hard edge) to 0.25 (very soft)
    float2 centreVector = input.areaUV - float2(0.5f, 0.5f);
    float centreLengthSq = dot(centreVector, centreVector);
    float alpha = 1.0f - saturate((centreLengthSq - 0.25f + softEdge) / softEdge); // Soft circle calculation based on fact that this circle has a radius of 0.5 (as area UVs go from 0->1)
												
	
	// Got the RGB from the scene texture, set alpha to 1 for final output
    return float4(colour, alpha);
}
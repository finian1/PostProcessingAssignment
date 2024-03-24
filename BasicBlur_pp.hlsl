#include "Common.hlsli"

Texture2D SceneTexture : register(t0);
SamplerState PointSample : register(s0);

Texture2D BlurMask : register(t1);
SamplerState BlurSample : register(s1);

float4 main(PostProcessingInput input) : SV_Target
{
	int maskWidth;
	int maskHeight;
	int sceneWidth;
	int sceneHeight;
	BlurMask.GetDimensions(maskWidth, maskHeight);
	SceneTexture.GetDimensions(sceneWidth, sceneHeight);
	float maskStrength = 0.0f;
	float maskStepX = 1.0 / maskWidth;
	float maskStepY = 1.0 / maskHeight;
	
	float sceneStepX = 1.0 / sceneWidth;
	float sceneStepY = 1.0 / sceneHeight;
	
	float3 colourSum = { 0, 0, 0 };
    int numOfPasses = 2;
	
    
    for (int x = 0; x < maskWidth; x++)
    {
        for (int y = 0; y < maskHeight; y++)
        {
            int2 scenePos = { x - maskWidth / 2, y - maskHeight / 2 };
            float3 maskValue = BlurMask.Sample(BlurSample, float2(x * maskStepX, y * maskStepX)).rgb;
            float4 sampleColour = SceneTexture.Sample(PointSample, input.sceneUV + float2(scenePos.x * sceneStepX, scenePos.y * sceneStepY));
            colourSum += sampleColour.rgb * maskValue * sampleColour.a;
			
            maskStrength += maskValue.r;
        }
    }
    
	
    
	float3 colour = colourSum / maskStrength;
	float softEdge = 0.20f; // Softness of the edge of the circle - range 0.001 (hard edge) to 0.25 (very soft)
	float2 centreVector = input.areaUV - float2(0.5f, 0.5f);
	float centreLengthSq = dot(centreVector, centreVector);
	float alpha = 1.0f - saturate((centreLengthSq - 0.25f + softEdge) / softEdge); // Soft circle calculation based on fact that this circle has a radius of 0.5 (as area UVs go from 0->1)
												
	
	// Got the RGB from the scene texture, set alpha to 1 for final output
	return float4(colour, alpha);
}
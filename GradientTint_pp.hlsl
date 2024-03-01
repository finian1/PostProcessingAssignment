//ASSIGNMENT SHADER

#include "Common.hlsli"

Texture2D SceneTexture : register(t0);
SamplerState PointSample : register(s0);

float4 main(PostProcessingInput input) : SV_Target
{
	//We want the colour to be a combination of the top tint and the bottom tint based on height on screen.
    //If we wanted a better looking gradient, we would use Hue or Luminosity interpolation.
    float lerpPercent = input.sceneUV.y;
    float3 basicLerpColour =
    {
        gGradientColourTop.r + (gGradientColourBottom.r - gGradientColourTop.r) * lerpPercent,
        gGradientColourTop.g + (gGradientColourBottom.g - gGradientColourTop.g) * lerpPercent,
        gGradientColourTop.b + (gGradientColourBottom.b - gGradientColourTop.b) * lerpPercent,
    };
    
    float3 colour = SceneTexture.Sample(PointSample, input.sceneUV).rgb * basicLerpColour;
    float softEdge = 0.20f; // Softness of the edge of the circle - range 0.001 (hard edge) to 0.25 (very soft)
    float2 centreVector = input.areaUV - float2(0.5f, 0.5f);
    float centreLengthSq = dot(centreVector, centreVector);
    float alpha = 1.0f - saturate((centreLengthSq - 0.25f + softEdge) / softEdge); // Soft circle calculation based on fact that this circle has a radius of 0.5 (as area UVs go from 0->1)
												
	
	// Got the RGB from the scene texture, set alpha to 1 for final output
    return float4(colour, alpha);
}
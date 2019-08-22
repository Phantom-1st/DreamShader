Shader "Custom/DreamShader"
{
	Properties
	{
		_Color("Color", Color) = (.8980, 0.682353, 1, 1)
		_GradientColor("GradientColor", Color) = (.8980, 0.682353, 1, 1)

		_MainTex ("Texture", 2D) = "white" {}
		_Steps("Steps", Range(1,10)) = 2
		_StepSmoothing("StepSmoothing", Range(0,.1)) = .01
		_BackLightStrength("BackLightStrength", Range(0,1)) = 1
		_BackLightWidth("BackLightWidth", Range(0,2)) = 0.716
		_BackLightSmoothing("BackLightSmoothing", Range(0,.1)) = .01
		_BackLightExtension("BackLightExtension", Range(0,1)) = 0.1

		_HighlightColor("HighlightColor", Color) = (1,1,1,1)
		_HighlightScale("HighlightScale", Range(0,.1)) = .01
		_Noise("NoiseTex", 2D) = "white" {}
		_RandomStrength("RandomStrength", Range(0,.01)) = 1
	}

	SubShader
	{
		Tags
		{
			"RenderType" = "Opaque"
		}

		//Base
		Pass
		{
			Tags
			{
				"LightMode" = "ForwardBase"
			}

			ZWrite On

			CGPROGRAM
				#pragma target 3.0

				#pragma multi_compile _ SHADOWS_SCREEN
				#pragma multi_compile_fog

				#include "DreamShaderInclude.cginc"
				#pragma vertex vert
				#pragma fragment frag
			ENDCG
		}

		//Additive
		Pass
		{
			Tags
			{
				"LightMode" = "ForwardAdd"
			}

			Blend One One

			ZWrite Off

			CGPROGRAM
				#pragma target 3.0

				#pragma multi_compile_fwdadd_fullshadows
				#pragma multi_compile_fog

				#include "DreamShaderInclude.cginc"
				#pragma vertex vert
				#pragma fragment frag
			ENDCG
		}

		//Highlight
		Pass
		{

			// draw only back faces
			Cull Front

			CGPROGRAM
				#include "UnityCG.cginc"

				#pragma vertex vert
				#pragma fragment frag

				// Properties (don't forget to add to Properties block!!!)
				uniform float4 _HighlightColor;
				uniform float _HighlightScale;
				uniform float _RandomStrength;
				sampler2D _Noise;
				sampler2D _MainTex;

				// we'll need all of this information later!
				struct vertexInput
				{
				  float4 vertex : POSITION;
				  float3 normal : NORMAL;
				  float3 texCoord : TEXCOORD0;
				  float4 color : TEXCOORD1;
				};

				// since we're just drawing a flat color,
				// we only need the vertex position in our vertex output.
				struct vertexOutput
				{
				  float4 pos : SV_POSITION;
				};

				vertexOutput vert(vertexInput input)
				{
					vertexOutput output;

					// normal data is provided in float3, but need float4 form to do math
					// with the input vertex, which is a float4
					float4 newPos = input.vertex;
					float4 normal4 = float4(input.normal, 0.0);
					float3 normal = normalize(mul(normal4, unity_WorldToObject).xyz);
					float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);

					float4 screenPos = ComputeScreenPos(input.vertex);

					float lightDot = 1 - dot(WorldSpaceViewDir(input.vertex), UnityObjectToWorldNormal(input.normal)); //saturate(dot(normal, lightDir));
					lightDot *= saturate(dot(normal, lightDir));
					// scale the vertex along the normal direction
					float noiseAmount = (1 - tex2Dlod(_Noise, screenPos / input.vertex.w)) * _RandomStrength;
					noiseAmount = saturate(noiseAmount / _HighlightScale);
					newPos += float4(input.normal, 0.0) * lightDot * _HighlightScale + noiseAmount;

					output.pos = UnityObjectToClipPos(newPos);
					return output;
				}

				float4 frag(vertexOutput input) : COLOR
				{
				  return _HighlightColor;
				}
			ENDCG
		}

		//Shadows
		Pass
		{
			Tags
			{
				"LightMode" = "ShadowCaster"
			}

			CGPROGRAM
				#pragma target 3.0

				#pragma multi_compile_shadowcaster

				#include "DreamShadows.cginc"
				#pragma vertex shadowVert
				#pragma fragment shadowFrag

			ENDCG
		}
	}
}	

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
    }
    SubShader
    {
		Tags
		{
			"RenderType" = "Opaque"
		}

        Pass
        {
			Tags 
			{
				"LightMode" = "ForwardBase"
			}

			ZWrite On

            CGPROGRAM
				#pragma target 3.0

				#include "DreamShaderInclude.cginc"
				#pragma vertex vert
				#pragma fragment frag
			ENDCG
        }

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

				#pragma multi_compile DIRECTIONAL POINT SPOT

				#include "DreamShaderInclude.cginc"
				#pragma vertex vert
				#pragma fragment frag
			ENDCG
		}
    }
}

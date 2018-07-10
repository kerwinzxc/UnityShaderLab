﻿Shader "ITS/test/testStencilByMaskPlane" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainColor ("Color", Color) = (1, 1, 1, 1)
	}

	SubShader {
		// Tags { "RenderType"="Transparent" }
		Tags {"Queue"="Transparent" "RenderType"="Transparent"}
		LOD 100
		Blend SrcAlpha OneMinusSrcAlpha 

		Pass {  
			Stencil
			{
				Ref 1
				Comp Always
				Pass Replace
				ZFail Replace
			}

			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_fog
				
				#include "UnityCG.cginc"

				struct appdata_t {
					float4 vertex : POSITION;
					float2 texcoord : TEXCOORD0;
				};

				struct v2f {
					float4 vertex : SV_POSITION;
					half2 texcoord : TEXCOORD0;
					UNITY_FOG_COORDS(1)
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;
				float4 _MainColor;

				v2f vert (appdata_t v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}
				
				fixed4 frag (v2f i) : SV_Target
				{
					fixed4 col = tex2D(_MainTex, i.texcoord);
					col *= _MainColor;
					UNITY_APPLY_FOG(i.fogCoord, col);
					// UNITY_OPAQUE_ALPHA(col.a);
					return col;
				}
			ENDCG
		}
	}
}

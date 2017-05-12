// Iman

Shader "new/Ripple"
{
	Properties {
		//_MainTex ("MainTexture", 2D) = "white" {}
		_Color ("Color", color) = (1,1,1,1)
		_WaveAmounts ("WaveAmounts", int) = 10
	}
	SubShader {
		Pass {
		CGPROGRAM
		#pragma fragment frag
		#pragma vertex vert
			struct appdata {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 texcoord : TEXCOORD0;
			};
			struct v2f {
				float4 pos : SV_POSITION;
				float3 normal : NORMAL;
				float2 texcoord : TEXCOORD0;
			};
			v2f vert (appdata IN) {
				v2f OUT;
				OUT.pos = mul(UNITY_MATRIX_MVP, IN.vertex);
				OUT.normal = mul( float4(IN.normal,0.0), _Object2World ).xyz;
				OUT.texcoord = IN.texcoord;
				return OUT;
			};

			fixed4 _LightColor0;
			//sampler2D _MainTex;
			fixed4 _Color;
			int _WaveAmounts;

			fixed4 frag (v2f IN) : COLOR {
				// if we have texture, this is the default color to use.
				//fixed4 defaultCol = tex2D(_MainTex,IN.texcoord);

				// if we calculate the diffuse lighting, we need these lines.
				//fixed3 normalizedNormal = normalize(IN.normal);
				//fixed3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				//fixed3 diffuseResult = _LightColor0.rgb * max(0.0, dot(normalizedNormal,lightDirection));

				// to make a ripple, we need these lines.
				fixed3 ripple = max(0.75,sin( distance(IN.texcoord,0.5) * 10 * _WaveAmounts ));
				fixed4 colorResult = _Color * fixed4(ripple,1);
				return colorResult;

				//return colorResult * fixed4(diffuseResult,1);
			}
		ENDCG
		}
	}
}
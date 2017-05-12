// Iman

Shader "new/SeaWave"
{
	Properties {
		_SeaTexture ("SeaTexture", 2D) = "white" {}
		_NoiseTexture ("NoiseTexture", 2D) = "white" {}
		_WaveSpeed ("WaveSpeed",float) = 5.0
	}
	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment main
			struct appdata {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 texcoord : TEXCOORD;
			};
			struct v2f {
				float4 pos : SV_POSITION;
				float3 normal : NORMAL;
				float2 texcoord : TEXCOORD;
			};
			v2f vert (appdata IN) {
				v2f OUT;
				OUT.pos = mul(UNITY_MATRIX_MVP,IN.vertex);
				OUT.normal = mul(float4(IN.normal,0.0),_Object2World).xyz;
				OUT.texcoord = IN.texcoord;
				return OUT;
			}

			sampler2D _SeaTexture;
			sampler2D _NoiseTexture;
			float _WaveSpeed;

			fixed4 main (v2f IN) : COLOR {
				fixed4 noiseValue = tex2D(_NoiseTexture,IN.texcoord);

				fixed2 offsetValue = sin(_Time*_WaveSpeed) * noiseValue.r;

				fixed4 defaultColor = tex2D(_SeaTexture,offsetValue);

				return defaultColor;
			}
			ENDCG
		}
	}
}
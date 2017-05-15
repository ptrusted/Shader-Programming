// Iman

Shader "new/SeaWave_Revisied"
{
	Properties {
		_SeaTexture ("SeaTexture", 2D) = "white" {}
		_SpeedX ("SpeedX",float) = 50
		_SpeedY ("SpeedY",float) = 50
		_WaveLength ("WaveLength",float) = 300
		_WaveAmount ("WaveAmount",float) = 300
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
			float _SpeedX;
			float _SpeedY;
			float _WaveLength;
			float _WaveAmount;

			fixed4 main (v2f IN) : COLOR {
				fixed offsetValueX = IN.texcoord.x + ( sin(_SpeedX*_Time) * (sin(_WaveAmount*IN.texcoord.y)) ) / _WaveLength;

				fixed offsetValueY= IN.texcoord.y + ( cos(_SpeedY*_Time) * (cos(_WaveAmount*IN.texcoord.x)) ) / _WaveLength;

				fixed4 defaultColor = tex2D(_SeaTexture,float2(offsetValueX,offsetValueY));

				return defaultColor;
			}
			ENDCG
		}
	}
}
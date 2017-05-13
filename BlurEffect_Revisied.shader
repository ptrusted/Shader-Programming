// Iman

Shader "new/BlurEffect_"
{
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
		_FocusPoint ("FocusPoint", Vector) = (0,0,0,0)
		_BlurStrength ("BlurStrength", float) = 0.007
		_Brightness ("Brightness", float) = 1.29
		_ColorStrength ("ColorStrength", vector) = (1,1,1,1)
	}
	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment main
			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};
			struct v2f {
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};
			v2f vert (appdata v) {
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;
			vector _FocusPoint;
			float _BlurStrength;
			float _Brightness;
			vector _ColorStrength;

			fixed4 main (v2f i) : COLOR {
				if(_BlurStrength > 0) {
					float distanceFromFocusPoint = distance(i.uv,_FocusPoint.xy);

					// Blur we approach here is giving the average color of its neighbours to this fragment.
					fixed4 BlurCol = (
						tex2D(_MainTex, i.uv-float2(0,_BlurStrength))+
						tex2D(_MainTex, i.uv-float2(_BlurStrength,_BlurStrength))+
						tex2D(_MainTex, i.uv+float2(_BlurStrength,-_BlurStrength))+
						tex2D(_MainTex, i.uv+float2(0,_BlurStrength))+
						tex2D(_MainTex, i.uv+float2(-_BlurStrength,_BlurStrength))+
						tex2D(_MainTex, i.uv+float2(_BlurStrength,_BlurStrength))+
						tex2D(_MainTex, i.uv-float2(_BlurStrength,0))+
						tex2D(_MainTex, i.uv+float2(_BlurStrength,0))) / 8 * _Brightness;

					// This is the default color.
					fixed4 DefaultCol = tex2D(_MainTex, i.uv);

					fixed4 MixedCol = (BlurCol * sin(distanceFromFocusPoint*1.2)) + (DefaultCol * (1-sin(distanceFromFocusPoint)));
					// And then the last part is saturate it.
					return MixedCol * _ColorStrength;
				} else
					return tex2D(_MainTex, i.uv);
			}
			ENDCG
		}
	}
}
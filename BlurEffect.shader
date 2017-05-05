// Iman

Shader "new/BlurEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MinRange ("MinRange", float) = 0.2
		_MaxRange ("MaxRange", float) = 0.7
		_FocusPoint ("FocusPoint", Vector) = (0,0,0,0)
		_BlurStrength ("BlurStrength", float) = 0.005
		_BlurBrightness ("BlurBrightness", float) = 1.15
		_FocusBrightness ("FocusBrightness", float) = 1.3
		_ColorStrength ("ColorStrength", vector) = (1,1,1,1)
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;
			float _MinRange;
			float _MaxRange;
			vector _FocusPoint;
			float _BlurStrength;
			float _BlurBrightness;
			float _FocusBrightness;
			vector _ColorStrength;

			fixed4 frag (v2f i) : SV_Target
			{
				if(_BlurStrength > 0) {
					float distanceFromFocusPoint = length(abs(i.uv - _FocusPoint));

					// Blur we approach here is giving the average color of its neighbours to this fragment.
					fixed4 BlurCol = (
						tex2D(_MainTex, i.uv-float2(0,_BlurStrength))+
						tex2D(_MainTex, i.uv-float2(_BlurStrength,_BlurStrength))+
						tex2D(_MainTex, i.uv+float2(_BlurStrength,-_BlurStrength))+
						tex2D(_MainTex, i.uv+float2(0,_BlurStrength))+
						tex2D(_MainTex, i.uv+float2(-_BlurStrength,_BlurStrength))+
						tex2D(_MainTex, i.uv+float2(_BlurStrength,_BlurStrength))+
						tex2D(_MainTex, i.uv-float2(_BlurStrength,0))+
						tex2D(_MainTex, i.uv+float2(_BlurStrength,0))) / 8;

					// This is the default color.
					fixed4 DefaultCol = tex2D(_MainTex, i.uv);

					// We fading the colors based on the min and max range from focus point.
					fixed4 FadedBlur = (BlurCol * (1-(_MinRange/distanceFromFocusPoint)) );
					fixed4 FadedDefaultCol = (DefaultCol * (1-(distanceFromFocusPoint/_MaxRange)) );

					// We mix the blurry and default image.
					fixed4 MixedCol = ((clamp(FadedBlur,0.15,1)*_BlurBrightness) + (clamp(FadedDefaultCol,0.15,1)*_FocusBrightness));
					// And then the last part is saturate it.
					return saturate(MixedCol * _ColorStrength);
				} else
					return tex2D(_MainTex, i.uv);
			}
			ENDCG
		}
	}
}

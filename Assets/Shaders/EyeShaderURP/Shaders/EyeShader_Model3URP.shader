// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RRF_HumanShaders/EyeShaders/EyeShader_Model3"
{
	Properties
	{
		[NoScaleOffset][Header(Main Textures)]_RGBMask("RGBMask", 2D) = "white" {}
		[NoScaleOffset]_IrisExtraDetail("IrisExtraDetail", 2D) = "white" {}
		[NoScaleOffset]_Sclera_Normal("Sclera_Normal", 2D) = "bump" {}
		[NoScaleOffset]_Lens_Base_Normal("Lens_Base_Normal", 2D) = "bump" {}
		[Header(Color Customization)][Space(6)]_EyeBallColorGlossA("EyeBallColor-Gloss(A)", Color) = (1,1,1,0.853)
		_IrisBaseColor("IrisBaseColor", Color) = (0.4999702,0.5441177,0.4641004,1)
		_IrisExtraColorAmountA("IrisExtraColor-Amount(A)", Color) = (0.08088237,0.07573904,0.04698314,0.591)
		_EyeVeinColorAmountA("EyeVeinColor-Amount(A)", Color) = (0.375,0,0,0)
		_RingColorAmount("RingColor-Amount", Color) = (0,0,0,0)
		_LimbalEdge_Adjustment("LimbalEdge_Adjustment", Range( 0 , 1)) = 0
		_LimbalRingGloss("LimbalRingGloss", Range( 0 , 1)) = 0
		_ScleraBumpScale("ScleraBumpScale", Range( 0 , 1)) = 0
		_EyeSize("EyeSize", Range( 0 , 2)) = 1
		_IrisSize("IrisSize", Range( 0 , 10)) = 1
		_IrisRotationAnimation("IrisRotationAnimation", Range( -10 , 10)) = 0
		_LensGloss("LensGloss", Range( 0 , 1)) = 0.98
		_LensPush("LensPush", Range( 0 , 1)) = 0.64
		[Header(Metalness)]_LimbalRingMetalness("LimbalRingMetalness", Range( 0 , 1)) = 0
		_IrisPupilMetalness("IrisPupilMetalness", Range( 0 , 1)) = 0
		_EyeBallMetalness("EyeBallMetalness", Range( 0 , 1)) = 0
		[NoScaleOffset][Header(Caustic FX)]_CausticMask("CausticMask", 2D) = "white" {}
		_CausticPower("CausticPower", Range( 0 , 10)) = 17
		_CausticFX_inDarkness("CausticFX_inDarkness", Range( 0 , 1)) = 17
		[Header(Pupil Control)][Space(6)]_PupilColorEmissivenessA("PupilColor-Emissiveness(A)", Color) = (0,0,0,0)
		_PupilSize("PupilSize", Range( 0.001 , 99)) = 70
		_PupilHeight1Width1("Pupil Height>1/Width<1", Range( 0.01 , 10)) = 1
		_PupilSharpness("PupilSharpness", Range( 0.1 , 5)) = 5
		_PupilAutoDilateFactor("PupilAutoDilateFactor", Range( 0 , 50)) = 0
		_PupilAffectedByLight_Amount("PupilAffectedByLight_Amount", Range( 0 , 1)) = 0
		[NoScaleOffset][Header(Parallax Control)]_ParallaxMask("ParallaxMask", 2D) = "black" {}
		_PushParallaxMask("PushParallaxMask", Range( 0 , 5)) = 1
		_PupilParallaxHeight("PupilParallaxHeight", Range( 0 , 3)) = 2.5
		_EyeShadingPower("EyeShadingPower", Range( 0.01 , 2)) = 0.5
		_MinimumGlow("MinimumGlow", Range( 0 , 1)) = 0.2
		_MicroScatterScale("MicroScatterScale", Range( 0 , 1)) = 0
		_SubSurfaceFromDirectionalLight("SubSurfaceFromDirectionalLight", Range( 0 , 1)) = 0.5
		_Eyeball_microScatter("Eyeball_microScatter", Range( 0 , 5)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		
		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry" }
		
		Cull Back
		HLSLINCLUDE
		#pragma target 3.0
		ENDHLSL

		
		Pass
		{
			Name "Forward"
			Tags { "LightMode"="UniversalForward" }
			
			Blend One Zero , One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define ASE_SRP_VERSION 70106
			#define _NORMALMAP 1

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile _ _SHADOWS_SOFT
			#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
			
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON

			#pragma vertex vert
			#pragma fragment frag


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			
			#pragma multi_compile_instancing


			sampler2D _RGBMask;
			sampler2D _ParallaxMask;
			sampler2D _IrisExtraDetail;
			sampler2D _Sclera_Normal;
			sampler2D _Lens_Base_Normal;
			sampler2D _CausticMask;
			UNITY_INSTANCING_BUFFER_START(RRF_HumanShadersEyeShadersEyeShader_Model3)
				UNITY_DEFINE_INSTANCED_PROP(float, _MinimumGlow)
			UNITY_INSTANCING_BUFFER_END(RRF_HumanShadersEyeShadersEyeShader_Model3)
			CBUFFER_START( UnityPerMaterial )
			float _EyeShadingPower;
			float4 _PupilColorEmissivenessA;
			half _PupilSize;
			float _EyeSize;
			float _LimbalEdge_Adjustment;
			float _PupilAutoDilateFactor;
			float _PupilAffectedByLight_Amount;
			float _PupilHeight1Width1;
			float _PushParallaxMask;
			float _PupilParallaxHeight;
			float _PupilSharpness;
			float4 _EyeBallColorGlossA;
			float4 _EyeVeinColorAmountA;
			float4 _RingColorAmount;
			float _IrisSize;
			float _IrisRotationAnimation;
			float4 _IrisExtraColorAmountA;
			float4 _IrisBaseColor;
			float _SubSurfaceFromDirectionalLight;
			float _MicroScatterScale;
			float _Eyeball_microScatter;
			float _ScleraBumpScale;
			float _LensPush;
			float _CausticPower;
			float _CausticFX_inDarkness;
			float _LimbalRingMetalness;
			float _EyeBallMetalness;
			float _IrisPupilMetalness;
			float _LimbalRingGloss;
			float _LensGloss;
			CBUFFER_END


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord1 : TEXCOORD1;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 lightmapUVOrVertexSH : TEXCOORD0;
				half4 fogFactorAndVertexLight : TEXCOORD1;
				float4 shadowCoord : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				float4 ase_texcoord7 : TEXCOORD7;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			inline float2 ParallaxOffset( half h, half height, half3 viewDir )
			{
				h = h * height - height/2.0;
				float3 v = normalize( viewDir );
				v.z += 0.42;
				return h* (v.xy / v.z);
			}
			
			float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }
			float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }
			float snoise( float3 v )
			{
				const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
				float3 i = floor( v + dot( v, C.yyy ) );
				float3 x0 = v - i + dot( i, C.xxx );
				float3 g = step( x0.yzx, x0.xyz );
				float3 l = 1.0 - g;
				float3 i1 = min( g.xyz, l.zxy );
				float3 i2 = max( g.xyz, l.zxy );
				float3 x1 = x0 - i1 + C.xxx;
				float3 x2 = x0 - i2 + C.yyy;
				float3 x3 = x0 - 0.5;
				i = mod3D289( i);
				float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
				float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
				float4 x_ = floor( j / 7.0 );
				float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
				float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 h = 1.0 - abs( x ) - abs( y );
				float4 b0 = float4( x.xy, y.xy );
				float4 b1 = float4( x.zw, y.zw );
				float4 s0 = floor( b0 ) * 2.0 + 1.0;
				float4 s1 = floor( b1 ) * 2.0 + 1.0;
				float4 sh = -step( h, 0.0 );
				float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
				float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
				float3 g0 = float3( a0.xy, h.x );
				float3 g1 = float3( a0.zw, h.y );
				float3 g2 = float3( a1.xy, h.z );
				float3 g3 = float3( a1.zw, h.w );
				float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
				g0 *= norm.x;
				g1 *= norm.y;
				g2 *= norm.z;
				g3 *= norm.w;
				float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
				m = m* m;
				m = m* m;
				float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
				return 42.0 * dot( m, px);
			}
			

			VertexOutput vert ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				o.ase_texcoord7.x = ase_vertexTangentSign;
				
				o.ase_texcoord7.yz = v.ase_texcoord.xy;
				o.ase_normal = v.ase_normal;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord7.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = v.ase_normal;

				float3 lwWNormal = TransformObjectToWorldNormal(v.ase_normal);
				float3 lwWorldPos = TransformObjectToWorld(v.vertex.xyz);
				float3 lwWTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				float3 lwWBinormal = normalize(cross(lwWNormal, lwWTangent) * v.ase_tangent.w);
				o.tSpace0 = float4(lwWTangent.x, lwWBinormal.x, lwWNormal.x, lwWorldPos.x);
				o.tSpace1 = float4(lwWTangent.y, lwWBinormal.y, lwWNormal.y, lwWorldPos.y);
				o.tSpace2 = float4(lwWTangent.z, lwWBinormal.z, lwWNormal.z, lwWorldPos.z);

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.vertex.xyz);
				
				OUTPUT_LIGHTMAP_UV( v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy );
				OUTPUT_SH(lwWNormal, o.lightmapUVOrVertexSH.xyz );

				half3 vertexLight = VertexLighting(vertexInput.positionWS, lwWNormal);
				#ifdef ASE_FOG
					half fogFactor = ComputeFogFactor( vertexInput.positionCS.z );
				#else
					half fogFactor = 0;
				#endif
				o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);
				o.clipPos = vertexInput.positionCS;

				#ifdef _MAIN_LIGHT_SHADOWS
					o.shadowCoord = GetShadowCoord(vertexInput);
				#endif
				return o;
			}

			half4 frag ( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				float3 WorldSpaceNormal = normalize(float3(IN.tSpace0.z,IN.tSpace1.z,IN.tSpace2.z));
				float3 WorldSpaceTangent = float3(IN.tSpace0.x,IN.tSpace1.x,IN.tSpace2.x);
				float3 WorldSpaceBiTangent = float3(IN.tSpace0.y,IN.tSpace1.y,IN.tSpace2.y);
				float3 WorldSpacePosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldSpaceViewDirection = _WorldSpaceCameraPos.xyz  - WorldSpacePosition;
	
				#if SHADER_HINT_NICE_QUALITY
					WorldSpaceViewDirection = SafeNormalize( WorldSpaceViewDirection );
				#endif

				float4 transform457 = mul(GetObjectToWorldMatrix(),float4( 0,-3,1,0.78 ));
				float dotResult458 = dot( float4( WorldSpaceNormal , 0.0 ) , transform457 );
				float clampResult464 = clamp( dotResult458 , 0.0 , 1.0 );
				float4 transform462 = mul(GetObjectToWorldMatrix(),float4( 0,1.2,1,0.78 ));
				float dotResult461 = dot( float4( WorldSpaceNormal , 0.0 ) , transform462 );
				float clampResult465 = clamp( dotResult461 , 0.0 , 1.0 );
				float3 temp_cast_2 = (pow( ( clampResult464 * clampResult465 ) , _EyeShadingPower )).xxx;
				float temp_output_2_0_g43 = ( _EyeShadingPower * 0.5 );
				float temp_output_3_0_g43 = ( 1.0 - temp_output_2_0_g43 );
				float3 appendResult7_g43 = (float3(temp_output_3_0_g43 , temp_output_3_0_g43 , temp_output_3_0_g43));
				float3 eyeShading672 = ( ( temp_cast_2 * temp_output_2_0_g43 ) + appendResult7_g43 );
				float3 break690 = _MainLightColor.rgb;
				float ase_vertexTangentSign = IN.ase_texcoord7.x;
				float3 temp_cast_4 = (ase_vertexTangentSign).xxx;
				float dotResult4_g24 = dot( SafeNormalize(_MainLightPosition.xyz) , temp_cast_4 );
				float2 temp_cast_5 = (_EyeSize).xx;
				float2 temp_cast_6 = (( ( 1.0 - _EyeSize ) / 2.0 )).xx;
				float2 uv0264 = IN.ase_texcoord7.yz * temp_cast_5 + temp_cast_6;
				float2 eyeSizeUVs604 = uv0264;
				float4 tex2DNode166 = tex2D( _RGBMask, eyeSizeUVs604 );
				float lerpResult706 = lerp( tex2DNode166.b , ( tex2DNode166.b - tex2DNode166.r ) , _LimbalEdge_Adjustment);
				float clampResult721 = clamp( lerpResult706 , 0.0 , 1.0 );
				float IrisPupil_MASK585 = clampResult721;
				float lerpResult536 = lerp( _PupilSize , ( _PupilSize + ( ( ( ( ( break690.x + break690.y + break690.z ) / 3.0 ) * ( dotResult4_g24 - (-1.0 + (_MainLightColor.a - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) ) ) * IrisPupil_MASK585 ) * _PupilAutoDilateFactor ) ) , _PupilAffectedByLight_Amount);
				float clampResult545 = clamp( lerpResult536 , 0.0 , 99.0 );
				float temp_output_151_0 = ( 100.0 - clampResult545 );
				float2 appendResult149 = (float2(( temp_output_151_0 / 2.0 ) , ( temp_output_151_0 / ( _PupilHeight1Width1 * 2.0 ) )));
				float4 appendResult152 = (float4(temp_output_151_0 , ( temp_output_151_0 / _PupilHeight1Width1 ) , 0.0 , 0.0));
				float2 uv_ParallaxMask416 = IN.ase_texcoord7.yz;
				float4 tex2DNode416 = tex2D( _ParallaxMask, uv_ParallaxMask416 );
				float4 lerpResult418 = lerp( float4( 0,0,0,0 ) , tex2DNode416 , _PushParallaxMask);
				float PupilParallaxHeight574 = _PupilParallaxHeight;
				float3 tanToWorld0 = float3( WorldSpaceTangent.x, WorldSpaceBiTangent.x, WorldSpaceNormal.x );
				float3 tanToWorld1 = float3( WorldSpaceTangent.y, WorldSpaceBiTangent.y, WorldSpaceNormal.y );
				float3 tanToWorld2 = float3( WorldSpaceTangent.z, WorldSpaceBiTangent.z, WorldSpaceNormal.z );
				float3 ase_tanViewDir =  tanToWorld0 * WorldSpaceViewDirection.x + tanToWorld1 * WorldSpaceViewDirection.y  + tanToWorld2 * WorldSpaceViewDirection.z;
				ase_tanViewDir = normalize(ase_tanViewDir);
				float2 paralaxOffset255 = ParallaxOffset( lerpResult418.r , PupilParallaxHeight574 , ase_tanViewDir );
				float2 ParallaxPush_Vec2580 = paralaxOffset255;
				float2 uv0147 = IN.ase_texcoord7.yz * appendResult152.xy + ParallaxPush_Vec2580;
				float clampResult122 = clamp( ( pow( distance( appendResult149 , uv0147 ) , ( _PupilSharpness * 7.0 ) ) + ( 1.0 - IrisPupil_MASK585 ) ) , 0.0 , 1.0 );
				float PupilMaskArea625 = clampResult122;
				float Sclera_MASK591 = tex2DNode166.g;
				float clampResult719 = clamp( ( ( _EyeVeinColorAmountA.a * 1.5 ) * Sclera_MASK591 ) , 0.0 , 1.0 );
				float4 lerpResult177 = lerp( ( _EyeBallColorGlossA * ( 1.0 - IrisPupil_MASK585 ) ) , ( _EyeVeinColorAmountA * Sclera_MASK591 ) , clampResult719);
				float4 LimbalRing_Color619 = _RingColorAmount;
				float LimbalRing_MASK590 = tex2DNode166.r;
				float eyeLimbalRingPower612 = ( _RingColorAmount.a * LimbalRing_MASK590 );
				float4 lerpResult184 = lerp( lerpResult177 , LimbalRing_Color619 , eyeLimbalRingPower612);
				float IrisPupilFactor577 = ( temp_output_151_0 * 0.017 );
				float eyeSizing616 = ( _IrisSize + _EyeSize + IrisPupilFactor577 );
				float2 temp_cast_9 = (eyeSizing616).xx;
				float2 uv0190 = IN.ase_texcoord7.yz * temp_cast_9 + ( ( ParallaxPush_Vec2580 * float2( 0.15,0.15 ) ) + ( ( 1.0 - eyeSizing616 ) / 2.0 ) );
				float mulTime765 = _Time.y * _IrisRotationAnimation;
				float cos764 = cos( mulTime765 );
				float sin764 = sin( mulTime765 );
				float2 rotator764 = mul( uv0190 - float2( 0.5,0.5 ) , float2x2( cos764 , -sin764 , sin764 , cos764 )) + float2( 0.5,0.5 );
				float4 BaseIrisColors809 = ( ( ( ( tex2D( _IrisExtraDetail, rotator764 ) * _IrisExtraColorAmountA ) * _IrisExtraColorAmountA.a ) * IrisPupil_MASK585 ) + ( IrisPupil_MASK585 * _IrisBaseColor ) );
				float4 temp_output_326_0 = ( PupilMaskArea625 * ( ( lerpResult184 * lerpResult184 ) + BaseIrisColors809 ) );
				float dotResult5_g38 = dot( SafeNormalize(_MainLightPosition.xyz) , IN.ase_normal );
				float _MinimumGlow_Instance = UNITY_ACCESS_INSTANCED_PROP(RRF_HumanShadersEyeShadersEyeShader_Model3,_MinimumGlow);
				float clampResult478 = clamp( ( ( 1.0 * dotResult5_g38 ) * PupilMaskArea625 ) , _MinimumGlow_Instance , 1.0 );
				float4 transform3_g40 = mul(GetObjectToWorldMatrix(),float4( 0,-3,1,0.78 ));
				float dotResult6_g40 = dot( float4( WorldSpaceNormal , 0.0 ) , transform3_g40 );
				float clampResult7_g40 = clamp( dotResult6_g40 , 0.0 , 1.0 );
				float4 transform2_g40 = mul(GetObjectToWorldMatrix(),float4( 0,1.2,1,0.78 ));
				float dotResult5_g40 = dot( float4( WorldSpaceNormal , 0.0 ) , transform2_g40 );
				float clampResult8_g40 = clamp( dotResult5_g40 , 0.0 , 1.0 );
				float3 temp_cast_12 = (pow( ( clampResult7_g40 * clampResult8_g40 ) , _EyeShadingPower )).xxx;
				float temp_output_2_0_g41 = ( _EyeShadingPower * 0.5 );
				float temp_output_3_0_g41 = ( 1.0 - temp_output_2_0_g41 );
				float3 appendResult7_g41 = (float3(temp_output_3_0_g41 , temp_output_3_0_g41 , temp_output_3_0_g41));
				float4 lerpResult568 = lerp( ( temp_output_326_0 * float4( ( clampResult478 * ( ( temp_cast_12 * temp_output_2_0_g41 ) + appendResult7_g41 ) ) , 0.0 ) ) , float4( 0,0,0,0 ) , eyeLimbalRingPower612);
				float4 lerpResult646 = lerp( _PupilColorEmissivenessA , lerpResult568 , PupilMaskArea625);
				float4 temp_output_674_0 = ( float4( eyeShading672 , 0.0 ) * lerpResult646 );
				float fresnelNdotV727 = dot( WorldSpaceNormal, SafeNormalize(_MainLightPosition.xyz) );
				float fresnelNode727 = ( 0.5 + 1.0 * pow( 1.0 - fresnelNdotV727, 1.0 ) );
				float FresnelLight732 = ( 1.0 - fresnelNode727 );
				float4 SubSurfaceArea784 = lerpResult177;
				float4 clampResult794 = clamp( ( FresnelLight732 * SubSurfaceArea784 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float dotResult782 = dot( SafeNormalize(_MainLightPosition.xyz) , WorldSpaceNormal );
				float LightComponent779 = dotResult782;
				float4 clampResult795 = clamp( ( LightComponent779 * SubSurfaceArea784 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 lerpResult787 = lerp( temp_output_674_0 , ( _MainLightColor * ( clampResult794 + clampResult795 + temp_output_674_0 ) ) , _SubSurfaceFromDirectionalLight);
				
				float2 temp_cast_17 = (( _MicroScatterScale * 1000.0 )).xx;
				float2 uv03_g45 = IN.ase_texcoord7.yz * temp_cast_17 + float2( 0,0 );
				float simplePerlin3D4_g45 = snoise( float3( uv03_g45 ,  0.0 ) );
				float2 appendResult6_g45 = (float2(simplePerlin3D4_g45 , simplePerlin3D4_g45));
				float4 appendResult572 = (float4(appendResult6_g45 , 1.0 , 0.0));
				float clampResult717 = clamp( ( ( 1.0 - IrisPupil_MASK585 ) * 0.1 ) , 0.0 , 1.0 );
				float4 temp_output_504_0 = ( appendResult572 * clampResult717 * _Eyeball_microScatter );
				float4 lerpResult502 = lerp( float4( float3(0,0,1) , 0.0 ) , appendResult572 , temp_output_504_0);
				float3 lerpResult139 = lerp( float3(0,0,1) , UnpackNormalScale( tex2D( _Lens_Base_Normal, eyeSizeUVs604 ), 1.0f ) , _LensPush);
				float3 lerpResult569 = lerp( BlendNormal( lerpResult502.xyz , UnpackNormalScale( tex2D( _Sclera_Normal, eyeSizeUVs604 ), _ScleraBumpScale ) ) , lerpResult139 , IrisPupil_MASK585);
				float3 NORMAL_OUTPUT640 = lerpResult569;
				
				float2 paralaxOffset411 = ParallaxOffset( tex2DNode416.r , ( PupilParallaxHeight574 * 0.03 ) , ase_tanViewDir );
				float2 uv0409 = IN.ase_texcoord7.yz * float2( 0,0 ) + paralaxOffset411;
				float2 ParallaxOffset_Vec2583 = uv0409;
				float2 eyeLocalUV633 = ( eyeSizeUVs604 + ParallaxOffset_Vec2583 );
				float cos373 = cos( SafeNormalize(_MainLightPosition.xyz).x );
				float sin373 = sin( SafeNormalize(_MainLightPosition.xyz).x );
				float2 rotator373 = mul( eyeLocalUV633 - float2( 0.5,0.5 ) , float2x2( cos373 , -sin373 , sin373 , cos373 )) + float2( 0.5,0.5 );
				float4 tex2DNode370 = tex2D( _CausticMask, rotator373 );
				float4 lerpResult761 = lerp( ( BaseIrisColors809 + ( BaseIrisColors809 * tex2DNode370 * ( _CausticPower * ( ( FresnelLight732 + 0.5 ) * 1.25 ) ) ) ) , ( BaseIrisColors809 + ( BaseIrisColors809 * tex2DNode370 * _CausticPower ) ) , _CausticFX_inDarkness);
				float4 clampResult745 = clamp( lerpResult761 , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 caustEmissission827 = clampResult745;
				float causticInDark824 = _CausticFX_inDarkness;
				float4 BaseColoring814 = ( PupilMaskArea625 * _MinimumGlow_Instance * temp_output_326_0 );
				float4 clampResult521 = clamp( ( lerpResult568 + lerpResult568 + ( BaseColoring814 + ( clampResult745 * PupilMaskArea625 ) ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float temp_output_665_0 = ( _PupilColorEmissivenessA.a * ( 1.0 - PupilMaskArea625 ) );
				float4 lerpResult648 = lerp( clampResult521 , lerpResult646 , temp_output_665_0);
				float4 PreEmissive804 = lerpResult648;
				float4 PupilGlow833 = ( _PupilColorEmissivenessA * temp_output_665_0 );
				
				float clampResult661 = clamp( ( ( LimbalRing_MASK590 * _LimbalRingMetalness ) + ( _EyeBallMetalness * ( 1.0 - IrisPupil_MASK585 ) ) + ( IrisPupil_MASK585 * _IrisPupilMetalness ) ) , 0.0 , 1.0 );
				float METALNESS_OUTPUT663 = clampResult661;
				
				float EyeBallGloss622 = _EyeBallColorGlossA.a;
				float lerpResult135 = lerp( EyeBallGloss622 , ( _LensGloss * IrisPupil_MASK585 ) , IrisPupil_MASK585);
				float4 microScatter608 = temp_output_504_0;
				float lerpResult525 = lerp( ( ( _LimbalRingGloss * LimbalRing_MASK590 ) + lerpResult135 ) , 0.0 , ( ( 1.0 - IrisPupil_MASK585 ) * microScatter608 ).x);
				float SMOOTHNESS_OUTPUT642 = lerpResult525;
				
				float3 Albedo = ( lerpResult787 * _MainLightColor ).rgb;
				float3 Normal = NORMAL_OUTPUT640;
				float3 Emission = ( ( ( ( caustEmissission827 * causticInDark824 ) + ( _MainLightColor * PreEmissive804 ) ) * PupilMaskArea625 ) + PupilGlow833 ).rgb;
				float3 Specular = 0.5;
				float Metallic = METALNESS_OUTPUT663;
				float Smoothness = SMOOTHNESS_OUTPUT642;
				float Occlusion = 1;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				float3 BakedGI = 0;

				InputData inputData;
				inputData.positionWS = WorldSpacePosition;

				#ifdef _NORMALMAP
					inputData.normalWS = normalize(TransformTangentToWorld(Normal, half3x3(WorldSpaceTangent, WorldSpaceBiTangent, WorldSpaceNormal)));
				#else
					#if !SHADER_HINT_NICE_QUALITY
						inputData.normalWS = WorldSpaceNormal;
					#else
						inputData.normalWS = normalize(WorldSpaceNormal);
					#endif
				#endif

				inputData.viewDirectionWS = WorldSpaceViewDirection;
				inputData.shadowCoord = IN.shadowCoord;

				#ifdef ASE_FOG
					inputData.fogCoord = IN.fogFactorAndVertexLight.x;
				#endif

				inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;
				inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, IN.lightmapUVOrVertexSH.xyz, inputData.normalWS );
				#ifdef _ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#endif
				half4 color = UniversalFragmentPBR(
					inputData, 
					Albedo, 
					Metallic, 
					Specular, 
					Smoothness, 
					Occlusion, 
					Emission, 
					Alpha);

				#ifdef ASE_FOG
					#ifdef TERRAIN_SPLAT_ADDPASS
						color.rgb = MixFogColor(color.rgb, half3( 0, 0, 0 ), IN.fogFactorAndVertexLight.x );
					#else
						color.rgb = MixFog(color.rgb, IN.fogFactorAndVertexLight.x);
					#endif
				#endif
				
				#if _AlphaClip
					clip(Alpha - AlphaClipThreshold);
				#endif
				
				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				return color;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			ZWrite On
			ZTest LEqual

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define ASE_SRP_VERSION 70106

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex ShadowPassVertex
			#pragma fragment ShadowPassFragment


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			UNITY_INSTANCING_BUFFER_START(NewAmplifyShader)
			UNITY_INSTANCING_BUFFER_END(NewAmplifyShader)
			CBUFFER_START( UnityPerMaterial )
			float _EyeShadingPower;
			float4 _PupilColorEmissivenessA;
			half _PupilSize;
			float _EyeSize;
			float _LimbalEdge_Adjustment;
			float _PupilAutoDilateFactor;
			float _PupilAffectedByLight_Amount;
			float _PupilHeight1Width1;
			float _PushParallaxMask;
			float _PupilParallaxHeight;
			float _PupilSharpness;
			float4 _EyeBallColorGlossA;
			float4 _EyeVeinColorAmountA;
			float4 _RingColorAmount;
			float _IrisSize;
			float _IrisRotationAnimation;
			float4 _IrisExtraColorAmountA;
			float4 _IrisBaseColor;
			float _SubSurfaceFromDirectionalLight;
			float _MicroScatterScale;
			float _Eyeball_microScatter;
			float _ScleraBumpScale;
			float _LensPush;
			float _CausticPower;
			float _CausticFX_inDarkness;
			float _LimbalRingMetalness;
			float _EyeBallMetalness;
			float _IrisPupilMetalness;
			float _LimbalRingGloss;
			float _LensGloss;
			CBUFFER_END


			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			
			float3 _LightDirection;

			VertexOutput ShadowPassVertex( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld(v.vertex.xyz);
				float3 normalWS = TransformObjectToWorldDir(v.ase_normal);

				float4 clipPos = TransformWorldToHClip( ApplyShadowBias( positionWS, normalWS, _LightDirection ) );

				#if UNITY_REVERSED_Z
					clipPos.z = min(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#else
					clipPos.z = max(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#endif
				o.clipPos = clipPos;

				return o;
			}

			half4 ShadowPassFragment(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );

				
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				#if _AlphaClip
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				return 0;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask 0

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define ASE_SRP_VERSION 70106

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			

			UNITY_INSTANCING_BUFFER_START(NewAmplifyShader)
			UNITY_INSTANCING_BUFFER_END(NewAmplifyShader)
			CBUFFER_START( UnityPerMaterial )
			float _EyeShadingPower;
			float4 _PupilColorEmissivenessA;
			half _PupilSize;
			float _EyeSize;
			float _LimbalEdge_Adjustment;
			float _PupilAutoDilateFactor;
			float _PupilAffectedByLight_Amount;
			float _PupilHeight1Width1;
			float _PushParallaxMask;
			float _PupilParallaxHeight;
			float _PupilSharpness;
			float4 _EyeBallColorGlossA;
			float4 _EyeVeinColorAmountA;
			float4 _RingColorAmount;
			float _IrisSize;
			float _IrisRotationAnimation;
			float4 _IrisExtraColorAmountA;
			float4 _IrisBaseColor;
			float _SubSurfaceFromDirectionalLight;
			float _MicroScatterScale;
			float _Eyeball_microScatter;
			float _ScleraBumpScale;
			float _LensPush;
			float _CausticPower;
			float _CausticFX_inDarkness;
			float _LimbalRingMetalness;
			float _EyeBallMetalness;
			float _IrisPupilMetalness;
			float _LimbalRingGloss;
			float _LensGloss;
			CBUFFER_END


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			
			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				o.clipPos = TransformObjectToHClip(v.vertex.xyz);
				return o;
			}

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				#if _AlphaClip
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Meta"
			Tags { "LightMode"="Meta" }

			Cull Off

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define ASE_SRP_VERSION 70106

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#pragma multi_compile_instancing


			sampler2D _RGBMask;
			sampler2D _ParallaxMask;
			sampler2D _IrisExtraDetail;
			sampler2D _CausticMask;
			UNITY_INSTANCING_BUFFER_START(NewAmplifyShader)
				UNITY_DEFINE_INSTANCED_PROP(float, _MinimumGlow)
			UNITY_INSTANCING_BUFFER_END(NewAmplifyShader)
			CBUFFER_START( UnityPerMaterial )
			float _EyeShadingPower;
			float4 _PupilColorEmissivenessA;
			half _PupilSize;
			float _EyeSize;
			float _LimbalEdge_Adjustment;
			float _PupilAutoDilateFactor;
			float _PupilAffectedByLight_Amount;
			float _PupilHeight1Width1;
			float _PushParallaxMask;
			float _PupilParallaxHeight;
			float _PupilSharpness;
			float4 _EyeBallColorGlossA;
			float4 _EyeVeinColorAmountA;
			float4 _RingColorAmount;
			float _IrisSize;
			float _IrisRotationAnimation;
			float4 _IrisExtraColorAmountA;
			float4 _IrisBaseColor;
			float _SubSurfaceFromDirectionalLight;
			float _MicroScatterScale;
			float _Eyeball_microScatter;
			float _ScleraBumpScale;
			float _LensPush;
			float _CausticPower;
			float _CausticFX_inDarkness;
			float _LimbalRingMetalness;
			float _EyeBallMetalness;
			float _IrisPupilMetalness;
			float _LimbalRingGloss;
			float _LensGloss;
			CBUFFER_END


			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_tangent : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			inline float2 ParallaxOffset( half h, half height, half3 viewDir )
			{
				h = h * height - height/2.0;
				float3 v = normalize( viewDir );
				v.z += 0.42;
				return h* (v.xy / v.z);
			}
			

			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				o.ase_texcoord.w = ase_vertexTangentSign;
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord2.xyz = ase_worldTangent;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord3.xyz = ase_worldBitangent;
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				o.ase_texcoord4.xyz = ase_worldPos;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_normal = v.ase_normal;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.w = 0;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				o.clipPos = MetaVertexPosition( v.vertex, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST, unity_DynamicLightmapST );
				return o;
			}

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float3 ase_worldNormal = IN.ase_texcoord.xyz;
				float4 transform457 = mul(GetObjectToWorldMatrix(),float4( 0,-3,1,0.78 ));
				float dotResult458 = dot( float4( ase_worldNormal , 0.0 ) , transform457 );
				float clampResult464 = clamp( dotResult458 , 0.0 , 1.0 );
				float4 transform462 = mul(GetObjectToWorldMatrix(),float4( 0,1.2,1,0.78 ));
				float dotResult461 = dot( float4( ase_worldNormal , 0.0 ) , transform462 );
				float clampResult465 = clamp( dotResult461 , 0.0 , 1.0 );
				float3 temp_cast_2 = (pow( ( clampResult464 * clampResult465 ) , _EyeShadingPower )).xxx;
				float temp_output_2_0_g43 = ( _EyeShadingPower * 0.5 );
				float temp_output_3_0_g43 = ( 1.0 - temp_output_2_0_g43 );
				float3 appendResult7_g43 = (float3(temp_output_3_0_g43 , temp_output_3_0_g43 , temp_output_3_0_g43));
				float3 eyeShading672 = ( ( temp_cast_2 * temp_output_2_0_g43 ) + appendResult7_g43 );
				float3 break690 = _MainLightColor.rgb;
				float ase_vertexTangentSign = IN.ase_texcoord.w;
				float3 temp_cast_4 = (ase_vertexTangentSign).xxx;
				float dotResult4_g24 = dot( SafeNormalize(_MainLightPosition.xyz) , temp_cast_4 );
				float2 temp_cast_5 = (_EyeSize).xx;
				float2 temp_cast_6 = (( ( 1.0 - _EyeSize ) / 2.0 )).xx;
				float2 uv0264 = IN.ase_texcoord1.xy * temp_cast_5 + temp_cast_6;
				float2 eyeSizeUVs604 = uv0264;
				float4 tex2DNode166 = tex2D( _RGBMask, eyeSizeUVs604 );
				float lerpResult706 = lerp( tex2DNode166.b , ( tex2DNode166.b - tex2DNode166.r ) , _LimbalEdge_Adjustment);
				float clampResult721 = clamp( lerpResult706 , 0.0 , 1.0 );
				float IrisPupil_MASK585 = clampResult721;
				float lerpResult536 = lerp( _PupilSize , ( _PupilSize + ( ( ( ( ( break690.x + break690.y + break690.z ) / 3.0 ) * ( dotResult4_g24 - (-1.0 + (_MainLightColor.a - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) ) ) * IrisPupil_MASK585 ) * _PupilAutoDilateFactor ) ) , _PupilAffectedByLight_Amount);
				float clampResult545 = clamp( lerpResult536 , 0.0 , 99.0 );
				float temp_output_151_0 = ( 100.0 - clampResult545 );
				float2 appendResult149 = (float2(( temp_output_151_0 / 2.0 ) , ( temp_output_151_0 / ( _PupilHeight1Width1 * 2.0 ) )));
				float4 appendResult152 = (float4(temp_output_151_0 , ( temp_output_151_0 / _PupilHeight1Width1 ) , 0.0 , 0.0));
				float2 uv_ParallaxMask416 = IN.ase_texcoord1.xy;
				float4 tex2DNode416 = tex2D( _ParallaxMask, uv_ParallaxMask416 );
				float4 lerpResult418 = lerp( float4( 0,0,0,0 ) , tex2DNode416 , _PushParallaxMask);
				float PupilParallaxHeight574 = _PupilParallaxHeight;
				float3 ase_worldTangent = IN.ase_texcoord2.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord3.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 ase_worldPos = IN.ase_texcoord4.xyz;
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - ase_worldPos );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_tanViewDir =  tanToWorld0 * ase_worldViewDir.x + tanToWorld1 * ase_worldViewDir.y  + tanToWorld2 * ase_worldViewDir.z;
				ase_tanViewDir = normalize(ase_tanViewDir);
				float2 paralaxOffset255 = ParallaxOffset( lerpResult418.r , PupilParallaxHeight574 , ase_tanViewDir );
				float2 ParallaxPush_Vec2580 = paralaxOffset255;
				float2 uv0147 = IN.ase_texcoord1.xy * appendResult152.xy + ParallaxPush_Vec2580;
				float clampResult122 = clamp( ( pow( distance( appendResult149 , uv0147 ) , ( _PupilSharpness * 7.0 ) ) + ( 1.0 - IrisPupil_MASK585 ) ) , 0.0 , 1.0 );
				float PupilMaskArea625 = clampResult122;
				float Sclera_MASK591 = tex2DNode166.g;
				float clampResult719 = clamp( ( ( _EyeVeinColorAmountA.a * 1.5 ) * Sclera_MASK591 ) , 0.0 , 1.0 );
				float4 lerpResult177 = lerp( ( _EyeBallColorGlossA * ( 1.0 - IrisPupil_MASK585 ) ) , ( _EyeVeinColorAmountA * Sclera_MASK591 ) , clampResult719);
				float4 LimbalRing_Color619 = _RingColorAmount;
				float LimbalRing_MASK590 = tex2DNode166.r;
				float eyeLimbalRingPower612 = ( _RingColorAmount.a * LimbalRing_MASK590 );
				float4 lerpResult184 = lerp( lerpResult177 , LimbalRing_Color619 , eyeLimbalRingPower612);
				float IrisPupilFactor577 = ( temp_output_151_0 * 0.017 );
				float eyeSizing616 = ( _IrisSize + _EyeSize + IrisPupilFactor577 );
				float2 temp_cast_9 = (eyeSizing616).xx;
				float2 uv0190 = IN.ase_texcoord1.xy * temp_cast_9 + ( ( ParallaxPush_Vec2580 * float2( 0.15,0.15 ) ) + ( ( 1.0 - eyeSizing616 ) / 2.0 ) );
				float mulTime765 = _Time.y * _IrisRotationAnimation;
				float cos764 = cos( mulTime765 );
				float sin764 = sin( mulTime765 );
				float2 rotator764 = mul( uv0190 - float2( 0.5,0.5 ) , float2x2( cos764 , -sin764 , sin764 , cos764 )) + float2( 0.5,0.5 );
				float4 BaseIrisColors809 = ( ( ( ( tex2D( _IrisExtraDetail, rotator764 ) * _IrisExtraColorAmountA ) * _IrisExtraColorAmountA.a ) * IrisPupil_MASK585 ) + ( IrisPupil_MASK585 * _IrisBaseColor ) );
				float4 temp_output_326_0 = ( PupilMaskArea625 * ( ( lerpResult184 * lerpResult184 ) + BaseIrisColors809 ) );
				float dotResult5_g38 = dot( SafeNormalize(_MainLightPosition.xyz) , IN.ase_normal );
				float _MinimumGlow_Instance = UNITY_ACCESS_INSTANCED_PROP(NewAmplifyShader,_MinimumGlow);
				float clampResult478 = clamp( ( ( 1.0 * dotResult5_g38 ) * PupilMaskArea625 ) , _MinimumGlow_Instance , 1.0 );
				float4 transform3_g40 = mul(GetObjectToWorldMatrix(),float4( 0,-3,1,0.78 ));
				float dotResult6_g40 = dot( float4( ase_worldNormal , 0.0 ) , transform3_g40 );
				float clampResult7_g40 = clamp( dotResult6_g40 , 0.0 , 1.0 );
				float4 transform2_g40 = mul(GetObjectToWorldMatrix(),float4( 0,1.2,1,0.78 ));
				float dotResult5_g40 = dot( float4( ase_worldNormal , 0.0 ) , transform2_g40 );
				float clampResult8_g40 = clamp( dotResult5_g40 , 0.0 , 1.0 );
				float3 temp_cast_12 = (pow( ( clampResult7_g40 * clampResult8_g40 ) , _EyeShadingPower )).xxx;
				float temp_output_2_0_g41 = ( _EyeShadingPower * 0.5 );
				float temp_output_3_0_g41 = ( 1.0 - temp_output_2_0_g41 );
				float3 appendResult7_g41 = (float3(temp_output_3_0_g41 , temp_output_3_0_g41 , temp_output_3_0_g41));
				float4 lerpResult568 = lerp( ( temp_output_326_0 * float4( ( clampResult478 * ( ( temp_cast_12 * temp_output_2_0_g41 ) + appendResult7_g41 ) ) , 0.0 ) ) , float4( 0,0,0,0 ) , eyeLimbalRingPower612);
				float4 lerpResult646 = lerp( _PupilColorEmissivenessA , lerpResult568 , PupilMaskArea625);
				float4 temp_output_674_0 = ( float4( eyeShading672 , 0.0 ) * lerpResult646 );
				float fresnelNdotV727 = dot( ase_worldNormal, SafeNormalize(_MainLightPosition.xyz) );
				float fresnelNode727 = ( 0.5 + 1.0 * pow( 1.0 - fresnelNdotV727, 1.0 ) );
				float FresnelLight732 = ( 1.0 - fresnelNode727 );
				float4 SubSurfaceArea784 = lerpResult177;
				float4 clampResult794 = clamp( ( FresnelLight732 * SubSurfaceArea784 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float dotResult782 = dot( SafeNormalize(_MainLightPosition.xyz) , ase_worldNormal );
				float LightComponent779 = dotResult782;
				float4 clampResult795 = clamp( ( LightComponent779 * SubSurfaceArea784 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 lerpResult787 = lerp( temp_output_674_0 , ( _MainLightColor * ( clampResult794 + clampResult795 + temp_output_674_0 ) ) , _SubSurfaceFromDirectionalLight);
				
				float2 paralaxOffset411 = ParallaxOffset( tex2DNode416.r , ( PupilParallaxHeight574 * 0.03 ) , ase_tanViewDir );
				float2 uv0409 = IN.ase_texcoord1.xy * float2( 0,0 ) + paralaxOffset411;
				float2 ParallaxOffset_Vec2583 = uv0409;
				float2 eyeLocalUV633 = ( eyeSizeUVs604 + ParallaxOffset_Vec2583 );
				float cos373 = cos( SafeNormalize(_MainLightPosition.xyz).x );
				float sin373 = sin( SafeNormalize(_MainLightPosition.xyz).x );
				float2 rotator373 = mul( eyeLocalUV633 - float2( 0.5,0.5 ) , float2x2( cos373 , -sin373 , sin373 , cos373 )) + float2( 0.5,0.5 );
				float4 tex2DNode370 = tex2D( _CausticMask, rotator373 );
				float4 lerpResult761 = lerp( ( BaseIrisColors809 + ( BaseIrisColors809 * tex2DNode370 * ( _CausticPower * ( ( FresnelLight732 + 0.5 ) * 1.25 ) ) ) ) , ( BaseIrisColors809 + ( BaseIrisColors809 * tex2DNode370 * _CausticPower ) ) , _CausticFX_inDarkness);
				float4 clampResult745 = clamp( lerpResult761 , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 caustEmissission827 = clampResult745;
				float causticInDark824 = _CausticFX_inDarkness;
				float4 BaseColoring814 = ( PupilMaskArea625 * _MinimumGlow_Instance * temp_output_326_0 );
				float4 clampResult521 = clamp( ( lerpResult568 + lerpResult568 + ( BaseColoring814 + ( clampResult745 * PupilMaskArea625 ) ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float temp_output_665_0 = ( _PupilColorEmissivenessA.a * ( 1.0 - PupilMaskArea625 ) );
				float4 lerpResult648 = lerp( clampResult521 , lerpResult646 , temp_output_665_0);
				float4 PreEmissive804 = lerpResult648;
				float4 PupilGlow833 = ( _PupilColorEmissivenessA * temp_output_665_0 );
				
				
				float3 Albedo = ( lerpResult787 * _MainLightColor ).rgb;
				float3 Emission = ( ( ( ( caustEmissission827 * causticInDark824 ) + ( _MainLightColor * PreEmissive804 ) ) * PupilMaskArea625 ) + PupilGlow833 ).rgb;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				#if _AlphaClip
					clip(Alpha - AlphaClipThreshold);
				#endif

				MetaInput metaInput = (MetaInput)0;
				metaInput.Albedo = Albedo;
				metaInput.Emission = Emission;
				
				return MetaFragment(metaInput);
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Universal2D"
			Tags { "LightMode"="Universal2D" }

			Blend One Zero , One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define ASE_SRP_VERSION 70106

			#pragma enable_d3d11_debug_symbols
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			
			#pragma multi_compile_instancing


			sampler2D _RGBMask;
			sampler2D _ParallaxMask;
			sampler2D _IrisExtraDetail;
			UNITY_INSTANCING_BUFFER_START(NewAmplifyShader)
				UNITY_DEFINE_INSTANCED_PROP(float, _MinimumGlow)
			UNITY_INSTANCING_BUFFER_END(NewAmplifyShader)
			CBUFFER_START( UnityPerMaterial )
			float _EyeShadingPower;
			float4 _PupilColorEmissivenessA;
			half _PupilSize;
			float _EyeSize;
			float _LimbalEdge_Adjustment;
			float _PupilAutoDilateFactor;
			float _PupilAffectedByLight_Amount;
			float _PupilHeight1Width1;
			float _PushParallaxMask;
			float _PupilParallaxHeight;
			float _PupilSharpness;
			float4 _EyeBallColorGlossA;
			float4 _EyeVeinColorAmountA;
			float4 _RingColorAmount;
			float _IrisSize;
			float _IrisRotationAnimation;
			float4 _IrisExtraColorAmountA;
			float4 _IrisBaseColor;
			float _SubSurfaceFromDirectionalLight;
			float _MicroScatterScale;
			float _Eyeball_microScatter;
			float _ScleraBumpScale;
			float _LensPush;
			float _CausticPower;
			float _CausticFX_inDarkness;
			float _LimbalRingMetalness;
			float _EyeBallMetalness;
			float _IrisPupilMetalness;
			float _LimbalRingGloss;
			float _LensGloss;
			CBUFFER_END


			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float3 ase_normal : NORMAL;
			};

			inline float2 ParallaxOffset( half h, half height, half3 viewDir )
			{
				h = h * height - height/2.0;
				float3 v = normalize( viewDir );
				v.z += 0.42;
				return h* (v.xy / v.z);
			}
			

			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;

				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				o.ase_texcoord.w = ase_vertexTangentSign;
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord2.xyz = ase_worldTangent;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord3.xyz = ase_worldBitangent;
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				o.ase_texcoord4.xyz = ase_worldPos;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_normal = v.ase_normal;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.w = 0;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( v.vertex.xyz );
				o.clipPos = vertexInput.positionCS;
				return o;
			}

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				float3 ase_worldNormal = IN.ase_texcoord.xyz;
				float4 transform457 = mul(GetObjectToWorldMatrix(),float4( 0,-3,1,0.78 ));
				float dotResult458 = dot( float4( ase_worldNormal , 0.0 ) , transform457 );
				float clampResult464 = clamp( dotResult458 , 0.0 , 1.0 );
				float4 transform462 = mul(GetObjectToWorldMatrix(),float4( 0,1.2,1,0.78 ));
				float dotResult461 = dot( float4( ase_worldNormal , 0.0 ) , transform462 );
				float clampResult465 = clamp( dotResult461 , 0.0 , 1.0 );
				float3 temp_cast_2 = (pow( ( clampResult464 * clampResult465 ) , _EyeShadingPower )).xxx;
				float temp_output_2_0_g43 = ( _EyeShadingPower * 0.5 );
				float temp_output_3_0_g43 = ( 1.0 - temp_output_2_0_g43 );
				float3 appendResult7_g43 = (float3(temp_output_3_0_g43 , temp_output_3_0_g43 , temp_output_3_0_g43));
				float3 eyeShading672 = ( ( temp_cast_2 * temp_output_2_0_g43 ) + appendResult7_g43 );
				float3 break690 = _MainLightColor.rgb;
				float ase_vertexTangentSign = IN.ase_texcoord.w;
				float3 temp_cast_4 = (ase_vertexTangentSign).xxx;
				float dotResult4_g24 = dot( SafeNormalize(_MainLightPosition.xyz) , temp_cast_4 );
				float2 temp_cast_5 = (_EyeSize).xx;
				float2 temp_cast_6 = (( ( 1.0 - _EyeSize ) / 2.0 )).xx;
				float2 uv0264 = IN.ase_texcoord1.xy * temp_cast_5 + temp_cast_6;
				float2 eyeSizeUVs604 = uv0264;
				float4 tex2DNode166 = tex2D( _RGBMask, eyeSizeUVs604 );
				float lerpResult706 = lerp( tex2DNode166.b , ( tex2DNode166.b - tex2DNode166.r ) , _LimbalEdge_Adjustment);
				float clampResult721 = clamp( lerpResult706 , 0.0 , 1.0 );
				float IrisPupil_MASK585 = clampResult721;
				float lerpResult536 = lerp( _PupilSize , ( _PupilSize + ( ( ( ( ( break690.x + break690.y + break690.z ) / 3.0 ) * ( dotResult4_g24 - (-1.0 + (_MainLightColor.a - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) ) ) * IrisPupil_MASK585 ) * _PupilAutoDilateFactor ) ) , _PupilAffectedByLight_Amount);
				float clampResult545 = clamp( lerpResult536 , 0.0 , 99.0 );
				float temp_output_151_0 = ( 100.0 - clampResult545 );
				float2 appendResult149 = (float2(( temp_output_151_0 / 2.0 ) , ( temp_output_151_0 / ( _PupilHeight1Width1 * 2.0 ) )));
				float4 appendResult152 = (float4(temp_output_151_0 , ( temp_output_151_0 / _PupilHeight1Width1 ) , 0.0 , 0.0));
				float2 uv_ParallaxMask416 = IN.ase_texcoord1.xy;
				float4 tex2DNode416 = tex2D( _ParallaxMask, uv_ParallaxMask416 );
				float4 lerpResult418 = lerp( float4( 0,0,0,0 ) , tex2DNode416 , _PushParallaxMask);
				float PupilParallaxHeight574 = _PupilParallaxHeight;
				float3 ase_worldTangent = IN.ase_texcoord2.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord3.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 ase_worldPos = IN.ase_texcoord4.xyz;
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - ase_worldPos );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_tanViewDir =  tanToWorld0 * ase_worldViewDir.x + tanToWorld1 * ase_worldViewDir.y  + tanToWorld2 * ase_worldViewDir.z;
				ase_tanViewDir = normalize(ase_tanViewDir);
				float2 paralaxOffset255 = ParallaxOffset( lerpResult418.r , PupilParallaxHeight574 , ase_tanViewDir );
				float2 ParallaxPush_Vec2580 = paralaxOffset255;
				float2 uv0147 = IN.ase_texcoord1.xy * appendResult152.xy + ParallaxPush_Vec2580;
				float clampResult122 = clamp( ( pow( distance( appendResult149 , uv0147 ) , ( _PupilSharpness * 7.0 ) ) + ( 1.0 - IrisPupil_MASK585 ) ) , 0.0 , 1.0 );
				float PupilMaskArea625 = clampResult122;
				float Sclera_MASK591 = tex2DNode166.g;
				float clampResult719 = clamp( ( ( _EyeVeinColorAmountA.a * 1.5 ) * Sclera_MASK591 ) , 0.0 , 1.0 );
				float4 lerpResult177 = lerp( ( _EyeBallColorGlossA * ( 1.0 - IrisPupil_MASK585 ) ) , ( _EyeVeinColorAmountA * Sclera_MASK591 ) , clampResult719);
				float4 LimbalRing_Color619 = _RingColorAmount;
				float LimbalRing_MASK590 = tex2DNode166.r;
				float eyeLimbalRingPower612 = ( _RingColorAmount.a * LimbalRing_MASK590 );
				float4 lerpResult184 = lerp( lerpResult177 , LimbalRing_Color619 , eyeLimbalRingPower612);
				float IrisPupilFactor577 = ( temp_output_151_0 * 0.017 );
				float eyeSizing616 = ( _IrisSize + _EyeSize + IrisPupilFactor577 );
				float2 temp_cast_9 = (eyeSizing616).xx;
				float2 uv0190 = IN.ase_texcoord1.xy * temp_cast_9 + ( ( ParallaxPush_Vec2580 * float2( 0.15,0.15 ) ) + ( ( 1.0 - eyeSizing616 ) / 2.0 ) );
				float mulTime765 = _Time.y * _IrisRotationAnimation;
				float cos764 = cos( mulTime765 );
				float sin764 = sin( mulTime765 );
				float2 rotator764 = mul( uv0190 - float2( 0.5,0.5 ) , float2x2( cos764 , -sin764 , sin764 , cos764 )) + float2( 0.5,0.5 );
				float4 BaseIrisColors809 = ( ( ( ( tex2D( _IrisExtraDetail, rotator764 ) * _IrisExtraColorAmountA ) * _IrisExtraColorAmountA.a ) * IrisPupil_MASK585 ) + ( IrisPupil_MASK585 * _IrisBaseColor ) );
				float4 temp_output_326_0 = ( PupilMaskArea625 * ( ( lerpResult184 * lerpResult184 ) + BaseIrisColors809 ) );
				float dotResult5_g38 = dot( SafeNormalize(_MainLightPosition.xyz) , IN.ase_normal );
				float _MinimumGlow_Instance = UNITY_ACCESS_INSTANCED_PROP(NewAmplifyShader,_MinimumGlow);
				float clampResult478 = clamp( ( ( 1.0 * dotResult5_g38 ) * PupilMaskArea625 ) , _MinimumGlow_Instance , 1.0 );
				float4 transform3_g40 = mul(GetObjectToWorldMatrix(),float4( 0,-3,1,0.78 ));
				float dotResult6_g40 = dot( float4( ase_worldNormal , 0.0 ) , transform3_g40 );
				float clampResult7_g40 = clamp( dotResult6_g40 , 0.0 , 1.0 );
				float4 transform2_g40 = mul(GetObjectToWorldMatrix(),float4( 0,1.2,1,0.78 ));
				float dotResult5_g40 = dot( float4( ase_worldNormal , 0.0 ) , transform2_g40 );
				float clampResult8_g40 = clamp( dotResult5_g40 , 0.0 , 1.0 );
				float3 temp_cast_12 = (pow( ( clampResult7_g40 * clampResult8_g40 ) , _EyeShadingPower )).xxx;
				float temp_output_2_0_g41 = ( _EyeShadingPower * 0.5 );
				float temp_output_3_0_g41 = ( 1.0 - temp_output_2_0_g41 );
				float3 appendResult7_g41 = (float3(temp_output_3_0_g41 , temp_output_3_0_g41 , temp_output_3_0_g41));
				float4 lerpResult568 = lerp( ( temp_output_326_0 * float4( ( clampResult478 * ( ( temp_cast_12 * temp_output_2_0_g41 ) + appendResult7_g41 ) ) , 0.0 ) ) , float4( 0,0,0,0 ) , eyeLimbalRingPower612);
				float4 lerpResult646 = lerp( _PupilColorEmissivenessA , lerpResult568 , PupilMaskArea625);
				float4 temp_output_674_0 = ( float4( eyeShading672 , 0.0 ) * lerpResult646 );
				float fresnelNdotV727 = dot( ase_worldNormal, SafeNormalize(_MainLightPosition.xyz) );
				float fresnelNode727 = ( 0.5 + 1.0 * pow( 1.0 - fresnelNdotV727, 1.0 ) );
				float FresnelLight732 = ( 1.0 - fresnelNode727 );
				float4 SubSurfaceArea784 = lerpResult177;
				float4 clampResult794 = clamp( ( FresnelLight732 * SubSurfaceArea784 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float dotResult782 = dot( SafeNormalize(_MainLightPosition.xyz) , ase_worldNormal );
				float LightComponent779 = dotResult782;
				float4 clampResult795 = clamp( ( LightComponent779 * SubSurfaceArea784 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 lerpResult787 = lerp( temp_output_674_0 , ( _MainLightColor * ( clampResult794 + clampResult795 + temp_output_674_0 ) ) , _SubSurfaceFromDirectionalLight);
				
				
				float3 Albedo = ( lerpResult787 * _MainLightColor ).rgb;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				half4 color = half4( Albedo, Alpha );

				#if _AlphaClip
					clip(Alpha - AlphaClipThreshold);
				#endif

				return color;
			}
			ENDHLSL
		}
		
	}
	//CustomEditor "UnityEditor.ShaderGraph.PBRMasterGUI"
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=17500
1927;7;1906;1015;5345.26;627.2748;3.588609;True;True
Node;AmplifyShaderEditor.CommentaryNode;615;-3521.69,-824.9874;Inherit;False;2148.08;465.2037;Sizing;9;616;323;578;247;604;264;265;266;267;Sizing;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;267;-3461.919,-655.2391;Float;False;Property;_EyeSize;EyeSize;12;0;Create;True;0;0;False;0;1;0.96;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;266;-3120.949,-498.1446;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;265;-2921.522,-489.6063;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;264;-2715.254,-530.2677;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;6,6;False;1;FLOAT2;-2.5,-2.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;604;-2419.218,-497.7717;Float;False;eyeSizeUVs;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;635;-3474.641,-314.61;Inherit;False;1296.923;486.1872;Eye Local UV setup and RGB masking for Sclera, Limbal Ring and Iris Area;11;633;410;590;584;166;605;705;706;707;721;591;RGB Mixer map;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;605;-3389.858,-91.25156;Inherit;False;604;eyeSizeUVs;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;166;-3081.737,-257.9168;Inherit;True;Property;_RGBMask;RGBMask;0;1;[NoScaleOffset];Create;True;0;0;False;1;Header(Main Textures);-1;d0431c3a16ed8b54c8d648bb79ca09a5;ea1c686f188c8ef46b8c015f1c344441;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;693;-6657.773,-1941.334;Inherit;False;889.9717;218.2189;Comment;4;685;690;691;692;GetLightColorIntensity;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;705;-2699.987,-67.25137;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;707;-2990.846,75.49301;Float;False;Property;_LimbalEdge_Adjustment;LimbalEdge_Adjustment;9;0;Create;True;0;0;False;0;0;0.422;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;685;-6625.374,-1893.515;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.BreakToComponentsNode;690;-6441.943,-1882.795;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.LerpOp;706;-2435.563,-16.65071;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;721;-2309.206,6.238053;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;662;-2148.269,-314.4674;Inherit;False;1320.225;575.4196;Make Metalness;11;723;722;585;657;655;656;660;661;663;724;725;Metalness;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;691;-6151.062,-1889.845;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;631;-5732.188,-1686.254;Inherit;False;1277.707;559.7808;PupilControl;9;587;543;555;91;542;537;535;536;686;Pupil Control;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;692;-5920.385,-1873.472;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;585;-2113.652,59.17068;Float;False;IrisPupil_MASK;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;694;-5715.541,-1608.325;Inherit;False;PupilAffectedByLight_float;-1;;24;676c5e5a2752c454fab10b64fa534af1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;587;-5682.188,-1524.082;Inherit;False;585;IrisPupil_MASK;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;686;-5367.417,-1635.279;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;555;-5227.093,-1567.955;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;543;-5604.761,-1418.477;Float;False;Property;_PupilAutoDilateFactor;PupilAutoDilateFactor;27;0;Create;True;0;0;False;0;0;15.4;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-5598.821,-1329.853;Half;False;Property;_PupilSize;PupilSize;24;0;Create;True;0;0;False;0;70;78.4;0.001;99;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;542;-4991.899,-1533.648;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;537;-4816.12,-1435.986;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;535;-5604.813,-1241.473;Float;False;Property;_PupilAffectedByLight_Amount;PupilAffectedByLight_Amount;28;0;Create;True;0;0;False;0;0;0.372;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;536;-4638.481,-1360.838;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;164;-4298.575,-1570.661;Inherit;False;3085.553;637.4598;Pupil;23;625;122;286;155;285;146;600;214;213;147;149;148;152;582;154;157;153;156;577;327;151;328;545;Pupil Control - UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;545;-4217.713,-1472.758;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;99;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;151;-4007.638,-1495.003;Inherit;False;2;0;FLOAT;100;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;328;-4259.182,-1326.615;Float;False;Constant;_IrisPupilBond;Iris-Pupil-Bond;23;0;Create;True;0;0;False;0;0.017;0.017;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;632;-5718.911,-1080.675;Inherit;False;733.9878;169.0557;ParallaxHeight Variable;2;257;574;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;327;-3863.809,-1370.011;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;257;-5668.911,-1030.676;Float;False;Property;_PupilParallaxHeight;PupilParallaxHeight;31;0;Create;True;0;0;False;0;2.5;1.66;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;579;-5723.329,-855.0426;Inherit;False;2130.722;818.1102;Eye-Pupil/Iris Parallax;13;583;409;411;414;412;575;580;255;576;418;256;419;416;Parallax;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;577;-3717.449,-1269.604;Float;False;IrisPupilFactor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;578;-2417.713,-588.0516;Inherit;False;577;IrisPupilFactor;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;416;-5673.329,-785.6605;Inherit;True;Property;_ParallaxMask;ParallaxMask;29;1;[NoScaleOffset];Create;True;0;0;False;1;Header(Parallax Control);-1;None;451268057d3fa344e8695ec36ec39129;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;247;-3471.69,-774.9874;Float;False;Property;_IrisSize;IrisSize;13;0;Create;True;0;0;False;0;1;3.12;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;419;-4996.699,-631.905;Float;False;Property;_PushParallaxMask;PushParallaxMask;30;0;Create;True;0;0;False;0;1;0.78;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;574;-5266.923,-1026.62;Float;False;PupilParallaxHeight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;576;-4634.585,-613.153;Inherit;False;574;PupilParallaxHeight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;323;-2141.998,-700.5798;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;418;-4636.011,-805.0426;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;256;-4611.694,-510.8292;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;168;-3471.395,582.1473;Inherit;False;1464.509;1000.859;Inputs;21;595;594;261;182;593;133;589;284;581;612;249;617;250;283;190;618;619;622;764;765;767;Color Inputs;1,1,1,1;0;0
Node;AmplifyShaderEditor.ParallaxOffsetHlpNode;255;-4176.507,-630.6099;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;616;-1614.072,-706.6902;Float;False;eyeSizing;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;580;-3865.203,-632.0921;Float;False;ParallaxPush_Vec2;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;617;-3335.841,1340.692;Inherit;False;616;eyeSizing;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;581;-3107.184,1240.347;Inherit;False;580;ParallaxPush_Vec2;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;249;-3059.993,1343.938;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;250;-2771.354,1336.247;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;284;-2787.769,1243.331;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.15,0.15;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;156;-4234.873,-1134.933;Float;False;Property;_PupilHeight1Width1;Pupil Height>1/Width<1;25;0;Create;True;0;0;False;0;1;1;0.01;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;618;-2607.011,1192.988;Inherit;False;616;eyeSizing;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;-3787.29,-1140.465;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;767;-2727.793,1097.685;Float;False;Property;_IrisRotationAnimation;IrisRotationAnimation;14;0;Create;True;0;0;False;0;0;0;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;283;-2529.156,1305.702;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;153;-3576.956,-1451.407;Inherit;False;2;0;FLOAT;2;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;148;-3471.602,-1299.328;Inherit;False;2;0;FLOAT;2;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;154;-3431.687,-1153.436;Inherit;False;2;0;FLOAT;2;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;765;-2410.755,1107.652;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;152;-3385.445,-1469.719;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;582;-3439.066,-1353.865;Inherit;False;580;ParallaxPush_Vec2;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;190;-2287.319,1239.682;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;6,6;False;1;FLOAT2;-2.5,-2.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;147;-3142.418,-1484.83;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;213;-3061.348,-1158.257;Float;False;Property;_PupilSharpness;PupilSharpness;26;0;Create;True;0;0;False;0;5;1.11;0.1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;218;-1952.744,598.4021;Inherit;False;1171.74;940.1422;IrisFunk;13;613;620;177;175;210;330;185;415;187;598;170;184;719;Iris mixing;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;149;-3195.629,-1254.792;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;764;-2147.478,1065.569;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;170;-1908.036,772.9764;Float;False;Property;_EyeVeinColorAmountA;EyeVeinColor-Amount(A);7;0;Create;True;0;0;False;0;0.375,0,0,0;0.3823529,0.1539494,0.1152682,0.541;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;187;-1915.38,1314.087;Float;False;Property;_IrisExtraColorAmountA;IrisExtraColor-Amount(A);6;0;Create;True;0;0;False;0;0.08088237,0.07573904,0.04698314,0.591;0.1317042,0.1997405,0.2132353,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;591;-2598.692,-201.7008;Float;False;Sclera_MASK;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;600;-2560.442,-1136.279;Inherit;False;585;IrisPupil_MASK;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;146;-2833.775,-1415.964;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;214;-2742.639,-1160.017;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;7;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;590;-2606.34,-272.9257;Float;False;LimbalRing_MASK;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;185;-1903.107,1108.585;Inherit;True;Property;_IrisExtraDetail;IrisExtraDetail;1;1;[NoScaleOffset];Create;True;0;0;False;0;-1;7b7c97e104d9817418725e17f5ca2659;e2d81eed3c8d580428baa06160f91a78;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;-1477.025,1234.005;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;589;-2864.632,691.246;Inherit;False;585;IrisPupil_MASK;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;182;-3417.43,823.6976;Float;False;Property;_RingColorAmount;RingColor-Amount;8;0;Create;True;0;0;False;0;0,0,0,0;0.3970588,0.3970588,0.3970588,0.353;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;598;-1920.4,962.3043;Inherit;False;591;Sclera_MASK;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;285;-2145.143,-1129.367;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;169;-757.5884,665.5753;Inherit;False;2366.183;1252.259;Mixing;28;135;134;623;20;451;603;326;627;325;626;478;489;476;103;321;322;319;636;126;251;586;775;776;777;778;809;810;814;Extra Mixing;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;593;-3406.51,1006.378;Inherit;False;590;LimbalRing_MASK;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;155;-2514.058,-1422.359;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;12;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;415;-1600.302,890.2409;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;286;-1928.995,-1223.143;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;133;-3418.101,633.1917;Float;False;Property;_EyeBallColorGlossA;EyeBallColor-Gloss(A);4;0;Create;True;0;0;False;2;Header(Color Customization);Space(6);1,1,1,0.853;1,1,1,0.803;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;595;-2446.204,695.3149;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;261;-2990.515,965.6833;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;126;-706.0718,1582.184;Float;False;Property;_IrisBaseColor;IrisBaseColor;5;0;Create;True;0;0;False;0;0.4999702,0.5441177,0.4641004,1;0.02205884,0.02141006,0.02141006,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;251;-456.2553,1311.411;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;2;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;330;-1427.309,932.8994;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;586;-727.6842,1492.685;Inherit;False;585;IrisPupil_MASK;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;322;-282.0901,1335.033;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;319;-268.5711,1451.92;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;122;-1718.151,-1212.716;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;475;-1700.735,2697.333;Inherit;False;1855.592;580.5686;Eye Shading - Created local shadows around the eye (fake AO);13;672;461;466;462;459;484;465;483;464;457;463;458;467;Eye Shading;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;619;-3107.881,821.9865;Float;False;LimbalRing_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;612;-2755.021,996.3271;Float;False;eyeLimbalRingPower;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;-1506.27,780.9657;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;594;-2220.49,630.9065;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;719;-1268.518,930.5994;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;457;-1638.375,2904.376;Inherit;False;1;0;FLOAT4;0,-3,1,0.78;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;613;-1336.574,638.1853;Inherit;False;612;eyeLimbalRingPower;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;620;-1315.666,713.5411;Inherit;False;619;LimbalRing_Color;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;177;-1135.945,790.793;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;462;-1650.735,3082.156;Inherit;False;1;0;FLOAT4;0,1.2,1,0.78;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;459;-1644.911,2747.333;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;321;-98.59876,1373.383;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;670;839.3718,2052.064;Inherit;False;2223.228;278.96;Final Mixing - Emissive;7;452;471;521;628;743;815;827;Final Mixing for Emissive;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;625;-1467.025,-1211.886;Float;False;PupilMaskArea;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;636;621.0922,1793.227;Inherit;False;LightDirectionZone_float;-1;;38;ce816473eb2cf6d4e96d84f2ab098aa5;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;184;-940.8968,678.6216;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;731;3123.164,2083.213;Inherit;False;1280.288;387.6746;Improved Light Falloff with inverse Fresnel and Light Dir;4;732;730;727;728;Light falloff simple;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;809;137.0322,1370.998;Float;False;BaseIrisColors;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;461;-1343.11,2985.45;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;628;875.7011,2241.544;Inherit;False;625;PupilMaskArea;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;458;-1338.131,2816.313;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;464;-1110.505,2800.719;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;465;-1102.694,2956.886;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;638;1637.879,1474.012;Inherit;False;1022.617;442.3356;LocalShadowPass Extra limbal Ring effect;5;637;481;470;614;568;Shadow FX;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;476;1164.363,1806.311;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-711.0731,707.4684;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;219;-1716.819,1929.655;Inherit;False;2546.831;732.6423;IrisConeCaustics;20;376;373;50;334;370;634;737;745;750;757;759;760;761;762;781;782;779;763;811;824;Caustics;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;728;3173.164,2155.734;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;810;-113.5322,1155.883;Inherit;False;809;BaseIrisColors;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;489;594.1643,1489.961;Float;False;InstancedProperty;_MinimumGlow;MinimumGlow;35;0;Create;True;0;0;False;0;0.2;0.09;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;781;-1653.115,2468.666;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;626;347.6477,1229.792;Inherit;False;625;PupilMaskArea;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;463;-878.1376,2862.101;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;467;-1382.126,3177.075;Float;False;Property;_EyeShadingPower;EyeShadingPower;34;0;Create;True;0;0;False;0;0.5;0.01;0.01;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;637;1687.879,1711.533;Inherit;False;LocalShadowing;32;;40;cbbcb7bdaf1755b499ae374337e1f753;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;325;192.3898,1121.124;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;478;1393.377,1657.579;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;727;3483.091,2133.213;Inherit;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0.5;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;376;-1658.832,2193.938;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PowerNode;466;-721.2878,2889.497;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;730;3774.033,2132.466;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;481;1956.37,1618.656;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;782;-1278.697,2339.555;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;326;809.9284,1364.676;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;484;-726.0908,3109.957;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;732;4044.787,2122.227;Float;False;FresnelLight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;470;2139.102,1524.012;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;483;-439.5578,2937.341;Inherit;False;Lerp White To;-1;;43;047d7c189c36a62438973bad9d37b1c2;0;2;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;779;-1092.743,2331.438;Float;False;LightComponent;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;652;2682.394,1397.634;Inherit;False;950.9968;628.9937;Final Outputs and Pupil Color control;14;648;643;646;664;665;647;666;668;667;650;673;674;832;833;Final Gather;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;614;1811.435,1810.744;Inherit;False;612;eyeLimbalRingPower;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;784;-955.7665,827.1627;Float;False;SubSurfaceArea;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;647;2707.268,1444.284;Float;False;Property;_PupilColorEmissivenessA;PupilColor-Emissiveness(A);23;0;Create;True;0;0;False;2;Header(Pupil Control);Space(6);0,0,0,0;0.03676468,0.03568337,0.03568337,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;790;3196.831,409.8283;Inherit;True;732;FresnelLight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;780;3180.02,606.7944;Inherit;True;779;LightComponent;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;783;3180.29,794.4534;Inherit;True;784;SubSurfaceArea;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;650;2701.278,1917.861;Inherit;False;625;PupilMaskArea;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;672;-105.6883,2930.192;Float;False;eyeShading;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;568;2399.684,1767.644;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;646;3168.31,1518.499;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;785;3518.789,722.4212;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;673;3112.564,1438.569;Inherit;False;672;eyeShading;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;793;3519.296,515.304;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;795;3764.5,737.1391;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;674;3447.683,1541.704;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;794;3754.959,510.9361;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;796;4065.512,548.1868;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;788;4060.938,721.3491;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;797;4316.654,628.1948;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;789;3885.831,1021.573;Float;False;Property;_SubSurfaceFromDirectionalLight;SubSurfaceFromDirectionalLight;38;0;Create;True;0;0;False;0;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;848;3715.594,1390.391;Inherit;False;1443.159;515.8131;FinalEmissive;11;804;806;818;829;831;830;826;844;845;847;846;Final Emissive;1,1,1,1;0;0
Node;AmplifyShaderEditor.LightColorNode;802;4524.5,1166.623;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;505;-511.9602,-644.9;Inherit;False;1832.025;501.339;Fake Microscatter effect - May be replaced with a simple noise-normalmap in a newer version;11;502;572;504;503;608;669;499;588;713;715;717;Microscatter;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;167;-560.9434,47.91427;Inherit;False;2142.244;468.7774;Normal Maps;9;331;602;139;333;607;141;138;140;606;Normal Maps;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;671;2253.061,110.756;Inherit;False;809.7659;371.8926;Blend normals;2;640;569;Blends Normal maps;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;639;1635.956,1088.942;Inherit;False;1461.426;267.9109;Protect Iris area from eyewhite micro scatter;5;642;527;611;609;610;Mask out Microscatter;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;787;4517.122,869.8699;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;525;2474.173,966.8337;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;763;397.4344,1914.998;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;762;234.1925,2220.282;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;643;3330.132,1925.106;Inherit;False;642;SMOOTHNESS_OUTPUT;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;664;3342.195,1860.429;Inherit;False;663;METALNESS_OUTPUT;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;657;-1763.756,67.64504;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;140;198.0932,97.91426;Float;False;Constant;_Vector0;Vector 0;10;0;Create;True;0;0;False;0;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;609;1657.123,1258.416;Inherit;False;608;microScatter;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;502;1123.114,-510.9321;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;775;698.8759,941.0576;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;778;519.8759,895.0576;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;138;-276.5837,165.2453;Inherit;True;Property;_Lens_Base_Normal;Lens_Base_Normal;3;1;[NoScaleOffset];Create;True;0;0;False;0;-1;8ee6d0418eaa08e40ad667b400177c1c;e575b95fc35e1be4c93f2b963878ec25;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;135;80.12472,988.3787;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;623;-351.8134,813.577;Inherit;False;622;EyeBallGloss;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;827;929.7286,2075.794;Float;False;caustEmissission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;777;240.8759,934.0576;Inherit;False;590;LimbalRing_MASK;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;610;1663.956,1168.022;Inherit;False;585;IrisPupil_MASK;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;606;-538.2026,188.7793;Inherit;False;604;eyeSizeUVs;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;663;-1083.006,-143.5471;Float;False;METALNESS_OUTPUT;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;648;3441.668,1712.301;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;640;2799.827,160.756;Float;False;NORMAL_OUTPUT;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;846;5004.753,1708.175;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;845;4771.337,1668.933;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;655;-1801.268,-260.4674;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;139;755.3265,321.9293;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;844;4039.651,1791.205;Inherit;False;625;PupilMaskArea;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;818;4036.508,1640.483;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;829;4028.655,1440.391;Inherit;False;827;caustEmissission;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;833;3404.886,1640.262;Float;False;PupilGlow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;569;2476.724,223.1104;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;641;5295.641,1523.715;Inherit;False;640;NORMAL_OUTPUT;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;661;-1288.506,19.15284;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;602;1156.075,388.4355;Inherit;False;585;IrisPupil_MASK;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;660;-1491.204,-109.2472;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;804;3765.594,1730.662;Float;False;PreEmissive;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;331;956.9222,93.24535;Inherit;True;Property;_Sclera_Normal;Sclera_Normal;2;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;97ac39d433ae05047abf79173f71d460;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;826;4537.544,1572.856;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;806;3771.776,1560.623;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;656;-1683.046,-62.42888;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;527;2256.172,1242.286;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BlendNormalsNode;332;1668.206,90.51281;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;611;1938.345,1179.715;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;803;4842.954,1036.472;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;832;3186.553,1655.089;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;141;-276.5095,369.9954;Float;False;Property;_LensPush;LensPush;16;0;Create;True;0;0;False;0;0.64;0.48;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;830;4327.083,1479.824;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;334;260.7897,2022.928;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;824;282.5758,2504.359;Float;False;causticInDark;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;588;-506.7211,-583.7661;Inherit;False;585;IrisPupil_MASK;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;847;4697.979,1781.792;Inherit;False;833;PupilGlow;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;451;1172.024,1472.768;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;761;431.1953,2104.292;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;717;97.39243,-306.1013;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;627;795.5042,1280.395;Inherit;False;625;PupilMaskArea;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;757;-263.9395,2337.472;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;811;-583.9844,1967.001;Inherit;False;809;BaseIrisColors;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;370;-650.2144,2062.136;Inherit;True;Property;_CausticMask;CausticMask;20;1;[NoScaleOffset];Create;True;0;0;False;1;Header(Caustic FX);-1;None;d9e87f40b033e4245bb68d58ff0930bc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;759;-562.4992,2366.532;Inherit;False;ConstantBiasScale;-1;;44;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;1.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;373;-934.2298,2080.128;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-651.8834,2270.156;Float;False;Property;_CausticPower;CausticPower;21;0;Create;True;0;0;False;0;17;3.7;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;737;-795.378,2360.672;Inherit;False;732;FresnelLight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;634;-1561.857,2019.873;Inherit;False;633;eyeLocalUV;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;633;-2953.703,-10.51019;Float;False;eyeLocalUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;584;-3424.641,63.08065;Inherit;False;583;ParallaxOffset_Vec2;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;583;-4153.616,-354.6765;Float;False;ParallaxOffset_Vec2;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxOffsetHlpNode;411;-4944.352,-301.8562;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;412;-5246.854,-223.3449;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;414;-5227.638,-363.4906;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.03;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;575;-5597.397,-369.1516;Inherit;False;574;PupilParallaxHeight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;503;373.7202,-606.47;Float;False;Constant;_FlatNormal;FlatNormal;31;0;Create;True;0;0;False;0;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClampOpNode;745;657.967,2126.984;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;814;1390.149,1505.289;Float;False;BaseColoring;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;743;1523.932,2170.736;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;722;-2105.917,-106.2091;Float;False;Property;_EyeBallMetalness;EyeBallMetalness;19;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;831;4043.524,1535.406;Inherit;False;824;causticInDark;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;608;1064.798,-255.6428;Float;False;microScatter;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;410;-3143.635,-18.3141;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;642;2793.351,1160.468;Float;False;SMOOTHNESS_OUTPUT;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;-150.6111,980.5873;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;409;-4628.915,-351.2112;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;724;-2111.768,155.1683;Float;False;Property;_IrisPupilMetalness;IrisPupilMetalness;18;0;Create;True;0;0;False;0;0;0.08;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;723;-2128.732,-215.2754;Float;False;Property;_LimbalRingMetalness;LimbalRingMetalness;17;0;Create;True;0;0;False;1;Header(Metalness);0;0.07;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;607;660.5301,82.57835;Inherit;False;604;eyeSizeUVs;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;725;-1887.699,4.125536;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;776;217.8759,859.0576;Float;False;Property;_LimbalRingGloss;LimbalRingGloss;10;0;Create;True;0;0;False;0;0;0.496;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;333;586.7011,158.6582;Float;False;Property;_ScleraBumpScale;ScleraBumpScale;11;0;Create;True;0;0;False;0;0;0.7;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;603;-734.5588,1055.458;Inherit;False;585;IrisPupil_MASK;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;521;2887.6,2102.064;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;713;-250.4354,-532.1979;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;715;-87.53503,-401.5688;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;504;816.5957,-357.6282;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;499;353.9738,-222.3932;Float;False;Property;_Eyeball_microScatter;Eyeball_microScatter;39;0;Create;True;0;0;False;0;0;1.24;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;622;-3092.575,727.5042;Float;False;EyeBallGloss;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-753.7518,947.6635;Float;False;Property;_LensGloss;LensGloss;15;0;Create;True;0;0;False;0;0.98;0.89;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;666;2805.619,1764.239;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;760;9.352644,2231.054;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;572;404.3301,-453.4742;Inherit;False;FLOAT4;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;471;2670.734,2118.573;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;452;2057.326,2164.549;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;665;3010.243,1717.121;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;750;-32.18269,2504.431;Float;False;Property;_CausticFX_inDarkness;CausticFX_inDarkness;22;0;Create;True;0;0;False;0;17;0.56;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;669;-43.51121,-496.9287;Inherit;False;MicroScatterScale_vec2;36;;45;27afac86e902b3f4680f2698fbeab237;0;0;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;668;2732.629,1848.105;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;667;2859.071,1863.319;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;815;1458.395,2093.988;Inherit;False;814;BaseColoring;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;852;5977.844,1606.051;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Meta;0;3;Meta;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;True;2;False;-1;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;849;5977.844,1606.051;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;2;RRF_HumanShaders/EyeShaders/EyeShader_Model3;94348b07e5e8bab40bd6c8a1e3df54cd;True;Forward;0;0;Forward;12;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;True;1;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;12;Workflow;1;Surface;0;  Blend;0;Two Sided;1;Cast Shadows;1;Receive Shadows;1;GPU Instancing;1;LOD CrossFade;1;Built-in Fog;1;Meta Pass;1;Override Baked GI;0;Vertex Position,InvertActionOnDeselection;1;0;5;True;True;True;True;True;False;;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;853;5977.844,1606.051;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Universal2D;0;4;Universal2D;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;True;1;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;True;True;True;True;True;0;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=Universal2D;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;851;5977.844,1606.051;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthOnly;0;2;DepthOnly;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;True;False;False;False;False;0;False;-1;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;850;5977.844,1606.051;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ShadowCaster;0;1;ShadowCaster;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
WireConnection;266;0;267;0
WireConnection;265;0;266;0
WireConnection;264;0;267;0
WireConnection;264;1;265;0
WireConnection;604;0;264;0
WireConnection;166;1;605;0
WireConnection;705;0;166;3
WireConnection;705;1;166;1
WireConnection;690;0;685;1
WireConnection;706;0;166;3
WireConnection;706;1;705;0
WireConnection;706;2;707;0
WireConnection;721;0;706;0
WireConnection;691;0;690;0
WireConnection;691;1;690;1
WireConnection;691;2;690;2
WireConnection;692;0;691;0
WireConnection;585;0;721;0
WireConnection;686;0;692;0
WireConnection;686;1;694;0
WireConnection;555;0;686;0
WireConnection;555;1;587;0
WireConnection;542;0;555;0
WireConnection;542;1;543;0
WireConnection;537;0;91;0
WireConnection;537;1;542;0
WireConnection;536;0;91;0
WireConnection;536;1;537;0
WireConnection;536;2;535;0
WireConnection;545;0;536;0
WireConnection;151;1;545;0
WireConnection;327;0;151;0
WireConnection;327;1;328;0
WireConnection;577;0;327;0
WireConnection;574;0;257;0
WireConnection;323;0;247;0
WireConnection;323;1;267;0
WireConnection;323;2;578;0
WireConnection;418;1;416;0
WireConnection;418;2;419;0
WireConnection;255;0;418;0
WireConnection;255;1;576;0
WireConnection;255;2;256;0
WireConnection;616;0;323;0
WireConnection;580;0;255;0
WireConnection;249;0;617;0
WireConnection;250;0;249;0
WireConnection;284;0;581;0
WireConnection;157;0;156;0
WireConnection;283;0;284;0
WireConnection;283;1;250;0
WireConnection;153;0;151;0
WireConnection;153;1;156;0
WireConnection;148;0;151;0
WireConnection;154;0;151;0
WireConnection;154;1;157;0
WireConnection;765;0;767;0
WireConnection;152;0;151;0
WireConnection;152;1;153;0
WireConnection;190;0;618;0
WireConnection;190;1;283;0
WireConnection;147;0;152;0
WireConnection;147;1;582;0
WireConnection;149;0;148;0
WireConnection;149;1;154;0
WireConnection;764;0;190;0
WireConnection;764;2;765;0
WireConnection;591;0;166;2
WireConnection;146;0;149;0
WireConnection;146;1;147;0
WireConnection;214;0;213;0
WireConnection;590;0;166;1
WireConnection;185;1;764;0
WireConnection;210;0;185;0
WireConnection;210;1;187;0
WireConnection;285;0;600;0
WireConnection;155;0;146;0
WireConnection;155;1;214;0
WireConnection;415;0;170;4
WireConnection;286;0;155;0
WireConnection;286;1;285;0
WireConnection;595;0;589;0
WireConnection;261;0;182;4
WireConnection;261;1;593;0
WireConnection;251;0;210;0
WireConnection;251;1;187;4
WireConnection;330;0;415;0
WireConnection;330;1;598;0
WireConnection;322;0;251;0
WireConnection;322;1;586;0
WireConnection;319;0;586;0
WireConnection;319;1;126;0
WireConnection;122;0;286;0
WireConnection;619;0;182;0
WireConnection;612;0;261;0
WireConnection;175;0;170;0
WireConnection;175;1;598;0
WireConnection;594;0;133;0
WireConnection;594;1;595;0
WireConnection;719;0;330;0
WireConnection;177;0;594;0
WireConnection;177;1;175;0
WireConnection;177;2;719;0
WireConnection;321;0;322;0
WireConnection;321;1;319;0
WireConnection;625;0;122;0
WireConnection;184;0;177;0
WireConnection;184;1;620;0
WireConnection;184;2;613;0
WireConnection;809;0;321;0
WireConnection;461;0;459;0
WireConnection;461;1;462;0
WireConnection;458;0;459;0
WireConnection;458;1;457;0
WireConnection;464;0;458;0
WireConnection;465;0;461;0
WireConnection;476;0;636;0
WireConnection;476;1;628;0
WireConnection;103;0;184;0
WireConnection;103;1;184;0
WireConnection;463;0;464;0
WireConnection;463;1;465;0
WireConnection;325;0;103;0
WireConnection;325;1;810;0
WireConnection;478;0;476;0
WireConnection;478;1;489;0
WireConnection;727;4;728;0
WireConnection;466;0;463;0
WireConnection;466;1;467;0
WireConnection;730;0;727;0
WireConnection;481;0;478;0
WireConnection;481;1;637;0
WireConnection;782;0;376;0
WireConnection;782;1;781;0
WireConnection;326;0;626;0
WireConnection;326;1;325;0
WireConnection;484;0;467;0
WireConnection;732;0;730;0
WireConnection;470;0;326;0
WireConnection;470;1;481;0
WireConnection;483;1;466;0
WireConnection;483;2;484;0
WireConnection;779;0;782;0
WireConnection;784;0;177;0
WireConnection;672;0;483;0
WireConnection;568;0;470;0
WireConnection;568;2;614;0
WireConnection;646;0;647;0
WireConnection;646;1;568;0
WireConnection;646;2;650;0
WireConnection;785;0;780;0
WireConnection;785;1;783;0
WireConnection;793;0;790;0
WireConnection;793;1;783;0
WireConnection;795;0;785;0
WireConnection;674;0;673;0
WireConnection;674;1;646;0
WireConnection;794;0;793;0
WireConnection;788;0;794;0
WireConnection;788;1;795;0
WireConnection;788;2;674;0
WireConnection;797;0;796;0
WireConnection;797;1;788;0
WireConnection;787;0;674;0
WireConnection;787;1;797;0
WireConnection;787;2;789;0
WireConnection;525;0;775;0
WireConnection;525;2;527;0
WireConnection;763;0;811;0
WireConnection;763;1;334;0
WireConnection;762;0;811;0
WireConnection;762;1;760;0
WireConnection;657;0;585;0
WireConnection;657;1;724;0
WireConnection;502;0;503;0
WireConnection;502;1;572;0
WireConnection;502;2;504;0
WireConnection;775;0;778;0
WireConnection;775;1;135;0
WireConnection;778;0;776;0
WireConnection;778;1;777;0
WireConnection;138;1;606;0
WireConnection;135;0;623;0
WireConnection;135;1;134;0
WireConnection;135;2;603;0
WireConnection;827;0;745;0
WireConnection;663;0;661;0
WireConnection;648;0;521;0
WireConnection;648;1;646;0
WireConnection;648;2;665;0
WireConnection;640;0;569;0
WireConnection;846;0;845;0
WireConnection;846;1;847;0
WireConnection;845;0;826;0
WireConnection;845;1;844;0
WireConnection;655;0;590;0
WireConnection;655;1;723;0
WireConnection;139;0;140;0
WireConnection;139;1;138;0
WireConnection;139;2;141;0
WireConnection;818;0;806;0
WireConnection;818;1;804;0
WireConnection;833;0;832;0
WireConnection;569;0;332;0
WireConnection;569;1;139;0
WireConnection;569;2;602;0
WireConnection;661;0;660;0
WireConnection;660;0;655;0
WireConnection;660;1;656;0
WireConnection;660;2;657;0
WireConnection;804;0;648;0
WireConnection;331;1;607;0
WireConnection;331;5;333;0
WireConnection;826;0;830;0
WireConnection;826;1;818;0
WireConnection;656;0;722;0
WireConnection;656;1;725;0
WireConnection;527;0;611;0
WireConnection;527;1;609;0
WireConnection;332;0;502;0
WireConnection;332;1;331;0
WireConnection;611;0;610;0
WireConnection;803;0;787;0
WireConnection;803;1;802;0
WireConnection;832;0;647;0
WireConnection;832;1;665;0
WireConnection;830;0;829;0
WireConnection;830;1;831;0
WireConnection;334;0;811;0
WireConnection;334;1;370;0
WireConnection;334;2;757;0
WireConnection;824;0;750;0
WireConnection;451;0;627;0
WireConnection;451;1;489;0
WireConnection;451;2;326;0
WireConnection;761;0;763;0
WireConnection;761;1;762;0
WireConnection;761;2;750;0
WireConnection;717;0;715;0
WireConnection;757;0;50;0
WireConnection;757;1;759;0
WireConnection;370;1;373;0
WireConnection;759;3;737;0
WireConnection;373;0;634;0
WireConnection;373;2;376;1
WireConnection;633;0;410;0
WireConnection;583;0;409;0
WireConnection;411;0;416;0
WireConnection;411;1;414;0
WireConnection;411;2;412;0
WireConnection;414;0;575;0
WireConnection;745;0;761;0
WireConnection;814;0;451;0
WireConnection;743;0;745;0
WireConnection;743;1;628;0
WireConnection;608;0;504;0
WireConnection;410;0;605;0
WireConnection;410;1;584;0
WireConnection;642;0;525;0
WireConnection;134;0;20;0
WireConnection;134;1;603;0
WireConnection;409;1;411;0
WireConnection;725;0;585;0
WireConnection;521;0;471;0
WireConnection;713;0;588;0
WireConnection;715;0;713;0
WireConnection;504;0;572;0
WireConnection;504;1;717;0
WireConnection;504;2;499;0
WireConnection;622;0;133;4
WireConnection;666;0;668;0
WireConnection;760;0;811;0
WireConnection;760;1;370;0
WireConnection;760;2;50;0
WireConnection;572;0;669;0
WireConnection;471;0;568;0
WireConnection;471;1;568;0
WireConnection;471;2;452;0
WireConnection;452;0;815;0
WireConnection;452;1;743;0
WireConnection;665;0;647;4
WireConnection;665;1;666;0
WireConnection;668;0;667;0
WireConnection;667;0;650;0
WireConnection;849;0;803;0
WireConnection;849;1;641;0
WireConnection;849;2;846;0
WireConnection;849;3;664;0
WireConnection;849;4;643;0
ASEEND*/
//CHKSM=22EC0956FA749CAB72DC994BA7C8D2D9A093048E
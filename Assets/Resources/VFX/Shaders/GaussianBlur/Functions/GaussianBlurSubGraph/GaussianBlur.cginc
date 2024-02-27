void GaussianBlur_float(UnityTexture2D Texture, float2 UV, float Blur, float Quality, float Directions, UnitySamplerState Sampler, out float4 Out, out float TextureAlpha)
{
	const float Pi = 6.28318530718;
	float4 tex = Texture.Sample(Sampler, UV);
	float4 col = tex;
	float2 texels = _Texture_TexelSize.xy;
	float2 radius = (Blur * 6.28 * texels) / texels;
	for( float d=0.0; d<Pi; d+=Pi/Directions)
	{
		for(float i=1.0/Quality; i<=1.0; i+=1.0/Quality)
		{
			col += Texture.Sample(Sampler, UV+float2(cos(d),sin(d))*radius*i);		
		}
	}
	col /= Quality * Directions - 15.0;
	Out = col;
	TextureAlpha = tex.a;
}
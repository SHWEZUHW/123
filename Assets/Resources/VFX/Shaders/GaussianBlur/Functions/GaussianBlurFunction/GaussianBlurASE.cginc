float4 GaussianBlurASE_float(sampler2D Texture, float2 UV, float Blur, float Quality, float Directions, out float TextureAlpha)
{
	const float Pi = 6.28318530718;
	float4 tex = Texture.Sample(Sampler, UV);
	float4 col = tex;
	float x; float y;;
	Texture.GetDimensions(x,y);
	float2 texels = float2(x,y);
	float2 radius = (Blur * 6.28 * texels) / texels;
	for( float d=0.0; d<Pi; d+=Pi/Directions)
	{
		for(float i=1.0/Quality; i<=1.0; i+=1.0/Quality)
		{
			col += Texture.Sample(Sampler, UV+float2(cos(d),sin(d))*radius*i);		
		}
	}
	col /= Quality * Directions - 15.0;
	TextureAlpha = tex.a;
	return col;
}
varying lowp vec2 var_texcoord0;

uniform lowp sampler2D DIFFUSE_TEXTURE;

uniform lowp vec4 time;

void main()
{
    gl_FragColor = texture2D(DIFFUSE_TEXTURE, vec2(mod(var_texcoord0.x + time.x, time.y), var_texcoord0.y));
}

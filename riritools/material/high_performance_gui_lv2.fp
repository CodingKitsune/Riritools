varying lowp vec2 var_texcoord0;

uniform lowp sampler2D texture;

void main()
{
    gl_FragColor = texture2D(texture, var_texcoord0.xy);
}

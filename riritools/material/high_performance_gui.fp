varying lowp vec2 var_texcoord0;
varying lowp vec4 var_color;

uniform lowp sampler2D texture;

void main()
{
    gl_FragColor = texture2D(texture, var_texcoord0.xy) * var_color;
}

varying lowp vec2 var_texcoord0;
varying lowp vec4 var_face_color;

uniform lowp vec4 texture_size_recip;
uniform lowp sampler2D texture;

void main()
{
    gl_FragColor = vec4(var_face_color.xyz, 1.0) * texture2D(texture, var_texcoord0.xy).x * var_face_color.w;
}

uniform highp mat4 u_ModelViewMatrix;
uniform highp mat4 u_ProjectionMatrix;


attribute vec4 a_Position;
attribute vec4 a_Color;
attribute vec2 a_Texture;

varying lowp vec4 frag_Color;
varying lowp vec2 frag_Texture;

void main(void) {
    frag_Color = a_Color;
    gl_Position = u_ProjectionMatrix * u_ModelViewMatrix * a_Position;
    frag_Texture = a_Texture;
}

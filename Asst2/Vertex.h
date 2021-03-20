#import <UIKit/UIKit.h>

typedef enum {
    VertexAttribPosition = 0,
    VertexAttribColor,
    VertexAttribTexture
}   VertexAttributes;

typedef struct {
    GLfloat Position[3];
    GLfloat Color[4];
    GLfloat Texture[2];
}   Vertex;

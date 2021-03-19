#import <UIKit/UIKit.h>

typedef enum {
    VertexAttribPosition = 0,
    VertexAttribColor
}   VertexAttributes;

typedef struct {
    GLfloat Position[3];
    GLfloat Color[4];
}   Vertex;

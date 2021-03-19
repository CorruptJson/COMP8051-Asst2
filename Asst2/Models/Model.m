//
//  Model.m
//  Asst2
//
//  Created by socas on 2021-03-18.
//

#import "Model.h"
#import <OpenGLES/ES2/glext.h>


@implementation Model {
    char *_name;
    GLuint _vao;
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    unsigned int _vertexCount;
    unsigned int _indexCount;
    BaseEffect *_shader;
}





// constructor
- (instancetype)initWithName:(char *)name shader:(BaseEffect *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)vertexCount indices:(GLubyte *) indices indexCount:(unsigned int)indexCount {
    
    if ((self = [super init])) {
        _name = name;
        _vertexCount = vertexCount;
        _indexCount = indexCount;
        _shader = shader;
        
        
        
        glGenVertexArraysOES(1, &_vao);
        glBindVertexArrayOES(_vao);

        // vertex buffer
        glGenBuffers(1, &_vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, vertexCount * sizeof(Vertex), vertices, GL_STATIC_DRAW);

        //index buffer
        glGenBuffers(1, &_indexBuffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indexCount * sizeof(GLubyte), indices, GL_STATIC_DRAW);

        // enable vertex attributes
        glEnableVertexAttribArray(VertexAttribPosition);
        glVertexAttribPointer(VertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), offsetof(Vertex, Position));

        glEnableVertexAttribArray(VertexAttribColor);
        glVertexAttribPointer(VertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), offsetof(Vertex, Color));

        // reset binds
        glBindVertexArrayOES(0);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    }
    return self;
}

- (void) render {
    [_shader prepareToDraw];
    
    glBindVertexArrayOES(_vao);
    glDrawElements(GL_TRIANGLES, _indexCount, GL_UNSIGNED_BYTE, 0);
    glBindVertexArrayOES(0);
}


@end

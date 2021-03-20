//
//  Model.m
//  Asst2
//
//  Created by socas on 2021-03-18.
//

#import "Cube.h"
#import <OpenGLES/ES2/glext.h>


@implementation Cube {
    char *_name;
    GLuint _vao;
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    unsigned int _vertexCount;
    unsigned int _indexCount;
    BaseEffect *_shader;
    bool _isRotating;
    Wall _north, _east, _south, _west;
}

const static Vertex vertices[] = {
    // front
    { {1, -1, 1}, {0, 0, 0, 1}}, //1
    {{1, 1, 1}, {0, 0, 0, 1}}, //2
    {{-1, 1, 1}, {0, 0, 0, 1}}, //3
    {{-1, -1, 1}, {0, 0, 0, 1}}, //4
    
    // back
    {{-1,-1,-1}, {1, 1, 1, 1}}, //5
    {{-1, 1,-1}, {1, 1, 1, 1}}, //6
    {{1, 1, -1}, {1, 1, 1, 1}}, //7
    {{1, -1, -1}, {1, 1, 1, 1}} //8
};


const static GLubyte indices[] = {
    //front
    0, 1, 2,
    2, 3, 0,
    //back,
    4, 5, 6,
    6, 7, 4,
    //left
    3, 2, 5,
    5, 4, 3,
    //right
    7, 6, 1,
    1, 0, 7,
    //top
    1, 6, 5,
    5, 2, 1,
    //bottom
    3, 4, 7,
    7, 0, 3,
    
    // INVERTED
    //front
    2, 1, 0,
    0, 3, 2,
    //back,
    6, 5, 4,
    4, 7, 6,
    //left
    5, 2, 3,
    3, 4, 5,
    //right
    1, 6, 7,
    7, 0, 1,
    //top
    5, 6, 1,
    1, 2, 5,
    //bottom
    7, 4, 3,
    3, 0, 7
};

// constructor
- (instancetype)initWithName:(char *)name shader:(BaseEffect *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)vertexCount indices:(GLubyte *) indices indexCount:(unsigned int)indexCount {
    
    if ((self = [super init])) {
        _name = name;
        _vertexCount = vertexCount;
        _indexCount = indexCount;
        _shader = shader;
        self.position = GLKVector3Make(0, 0, 0);
        self.rotationX = 0;
        self.rotationY = 0;
        self.rotationZ = 0;
        self.scale = 1.0;
        
        
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

- (instancetype)initWithShader:(BaseEffect *)shader {
    if ((self = [self initWithName:"cube" shader:shader vertices:(Vertex *)vertices vertexCount:sizeof(vertices)/sizeof(vertices[0]) indices:indices indexCount:sizeof(indices)/sizeof(indices[0])])) {
        
        _isRotating = true;
        _shader = shader;
            
    }
    return self;
}



- (GLKMatrix4)modelMatrix {
    GLKMatrix4 modelMatrix = GLKMatrix4Identity;
    modelMatrix = GLKMatrix4Translate(modelMatrix, self.position.x, self.position.y, self.position.z);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationX, 1, 0, 0);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationY, 0, 1, 0);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationZ, 0, 0, 1);
    modelMatrix = GLKMatrix4Scale(modelMatrix, self.scale, self.scale, self.scale);
    return modelMatrix;
}


- (void) render:(GLKMatrix4)parentModelViewMatrix {
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(parentModelViewMatrix, [self modelMatrix]);
    
    _shader.modelViewMatrix = modelViewMatrix;
    [_shader prepareToDraw];
    
    glBindVertexArrayOES(_vao);
    glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_BYTE, 0);
    glBindVertexArrayOES(0);
}

- (void)renderAsWall:(GLKMatrix4)parentModelViewMatrix {
    _isRotating = false;
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(parentModelViewMatrix, [self modelMatrix]);
    
    _shader.modelViewMatrix = modelViewMatrix;
    [_shader prepareToDraw];
    
    glBindVertexArrayOES(_vao);
    
    //_north = BOTH;
    //_west = BOTH;
    //_south = BOTH;
    //_east = BOTH;
    
    
    // wall drawing
    if (_north != EMPTY) {
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, 0);
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, 0+36);
    }
    if (_east != EMPTY) {
        
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, 12);
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, 12+36);
    }
    if (_south != EMPTY) {
       glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, 6);
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, 6+36);
    }
    if (_west != EMPTY) {
        
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, 18);
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, 18+36);
    }
    
    
    
    
    
    glBindVertexArrayOES(0);
}


- (void)updateWithDelta:(NSTimeInterval)dt {
    if (_isRotating) {
        //self.rotationZ += M_PI * dt * 0.1;
        self.rotationY += M_PI * dt * 0.5;
    }
}


@end

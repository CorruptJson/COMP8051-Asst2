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
    { {1, -1, 1}, {1, 1, 1, 1}, {1, 0}}, //1
    {{1, 1, 1}, {1, 1, 1, 1}, {1, 1}}, //2
    {{-1, 1, 1}, {1, 1, 1, 1}, {0, 1}}, //3
    {{-1, -1, 1}, {1, 1, 1, 1}, {0, 0}}, //4
    
    // back
    {{-1,-1,-1}, {1, 1, 1, 1}, {1, 0}}, //5
    {{-1, 1,-1}, {1, 1, 1, 1}, {1, 1}}, //6
    {{1, 1, -1}, {1, 1, 1, 1}, {0, 1}}, //7
    {{1, -1, -1}, {1, 1, 1, 1}, {0, 0}}, //8
    
    // Left
    {{-1, -1, 1}, {1, 1, 1, 1}, {1, 0}},
    {{-1, 1, 1}, {1, 1, 1, 1}, {1, 1}},
    {{-1, 1, -1}, {1, 1, 1, 1}, {0, 1}},
    {{-1, -1, -1}, {1, 1, 1, 1}, {0, 0}},
    
    // Right
    {{1, -1, -1}, {1, 1, 1, 1}, {1, 0}},
    {{1, 1,-1}, {1, 1, 1, 1}, {1, 1}},
    {{1, 1, 1}, {1, 1, 1, 1}, {0, 1}},
    {{1, -1, 1}, {1, 1, 1, 1}, {0, 0}},
    
    // Top
    {{1, 1, 1}, {1, 1, 1, 1}, {1, 0}},
    {{1, 1, -1}, {1, 1, 1, 1}, {1, 1}},
    {{-1, 1, -1}, {1, 1, 1, 1}, {0, 1}},
    {{-1, 1, 1}, {1, 1, 1, 1}, {0, 0}},
    
    // Bottom
    {{1, -1, -1}, {1, 1, 1, 1}, {1, 0}},
    {{1, -1, 1}, {1, 1, 1, 1}, {1, 1}},
    {{-1, -1, 1}, {1, 1, 1, 1}, {0, 1}},
    {{-1, -1, -1}, {1, 1, 1, 1}, {0, 0}}
};


const static GLubyte indices[] = {
    //front
    0, 1, 2,
    2, 3, 0,
    //back,
    4, 5, 6,
    6, 7, 4,
    //left
    8, 9, 10,
    10, 11, 8,
    //right
    12, 13, 14,
    14, 15, 12,
    //top
    16, 17, 18,
    18, 19, 16,
    //bottom
    20, 21, 22,
    22, 23, 20,
    
    // INVERTED
    //front
    2, 1, 0,
    0, 3, 2,
    //back,
    6, 5, 4,
    4, 7, 6,
    //left
    10, 9, 8,
    8, 11, 10,
    //right
    14, 13, 12,
    12, 15, 14,
    //top
    18, 17, 16,
    16, 19, 18,
    //bottom
    22, 21, 20,
    20, 23, 22
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
        
        self.crateTex = [self loadTexture:@"crate.jpg"];
        self.floorTex = [self loadTexture:@"floor.jpg"];
        self.wallTex = [self loadTexture:@"wall.jpg"];
        
        
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
        
        glEnableVertexAttribArray(VertexAttribTexture);
        glVertexAttribPointer(VertexAttribTexture, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), offsetof(Vertex, Texture));

        // reset binds
        glBindVertexArrayOES(0);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    }
    return self;
}

- (instancetype)initWithShader:(BaseEffect *)shader {
    if ((self = [self initWithName:"cube" shader:shader vertices:(Vertex *)vertices vertexCount:sizeof(vertices)/sizeof(vertices[0]) indices:indices indexCount:sizeof(indices)/sizeof(indices[0])])) {
        // LOAD DESIRED TEXTURE
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
    _shader.tex = self.crateTex;
    [_shader prepareToDraw];
    
    glBindVertexArrayOES(_vao);
    glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_BYTE, 0);
    glBindVertexArrayOES(0);
}





- (void)renderAsWall:(GLKMatrix4)parentModelViewMatrix {
    _isRotating = false;
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(parentModelViewMatrix, [self modelMatrix]);
    
    _shader.modelViewMatrix = modelViewMatrix;
    _shader.tex = self.wallTex;
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
    
    _shader.tex = self.floorTex;
    [_shader prepareToDraw];
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, 30 + 36);
    
    
    glBindVertexArrayOES(0);
    
}


- (void)updateWithDelta:(NSTimeInterval)dt {
    if (_isRotating) {
        //self.rotationZ += M_PI * dt * 0.1;
        self.rotationY += M_PI * dt * 0.5;
    }
}

-(GLuint)loadTexture: (NSString *)filename {
    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    NSDictionary *options = @{ GLKTextureLoaderOriginBottomLeft: @YES };
    GLKTextureInfo *info = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];

    if(info == nil){
        NSLog(@"Error loading texture file: %@", error.localizedDescription);
    } else{
        return info.name;
    }
    return nil;
}


@end

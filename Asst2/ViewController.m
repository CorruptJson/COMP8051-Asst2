#import "ViewController.h"
#import "Vertex.h"
#import "BaseEffect.h"

@implementation ViewController {
    GLuint _vertexBuffer, _indexBuffer;
    BaseEffect *_shader;
    GLsizei _indexCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:(kEAGLRenderingAPIOpenGLES3)];
    
    [EAGLContext setCurrentContext:view.context];
    [self setupShader];
    [self setupVertexBuffer];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [_shader prepareToDraw];
    
    glEnableVertexAttribArray(VertexAttribPosition);
    glVertexAttribPointer(VertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), offsetof(Vertex, Position));
    
    glEnableVertexAttribArray(VertexAttribColor);
    glVertexAttribPointer(VertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), offsetof(Vertex, Position));
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    //glDrawArrays(GL_TRIANGLES, 0, 3);
    glDrawElements(GL_TRIANGLES, _indexCount, GL_UNSIGNED_BYTE, 0);
    
    glDisableVertexAttribArray(VertexAttribPosition);
    glDisableVertexAttribArray(VertexAttribColor);
}

- (void)setupVertexBuffer {
    const static Vertex vertices[] = {
        {{1,-1,0}, {0,1,0,1}}, //red
        {{1,1,0}, {0,1,0,1}}, //green
        {{-1,1,0}, {0,1,1,1}}, // blue
        {{-1,-1,0}, {0,1,0, 1}} // black
    };
    
    const static GLubyte indices[] = {
        0, 1, 2,
        2, 3, 0
    };
    _indexCount = sizeof(indices) / sizeof(indices[0]);
    
    // vertex buffer
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    //index buffer
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
}

- (void)setupShader {
    _shader = [[BaseEffect alloc]
               initWithVertexShader:@"VertexShader.glsl" fragmentShader:@"FragmentShader.glsl"];
}


@end

#import "ViewController.h"
#import "Vertex.h"
#import "BaseEffect.h"
#import "Cube.h"

@implementation ViewController {
    BaseEffect *_shader;
    Cube *_cube;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:(kEAGLRenderingAPIOpenGLES3)];
    
    [EAGLContext setCurrentContext:view.context];
    [self setupScene];
}



// called from viewDidLoad
- (void)setupScene {
    _shader = [[BaseEffect alloc]
               initWithVertexShader:@"VertexShader.glsl" fragmentShader:@"FragmentShader.glsl"];
    
    //create objects here
    _cube = [[Cube alloc] initWithShader:_shader];
    _cube.position = GLKVector3Make(0, 0, 0);
    
    
    _shader.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85), self.view.bounds.size.width / self.view.bounds.size.height, 1, 150);
}



- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    // background color
    glClearColor(0, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // backface culling
    glEnable(GL_CULL_FACE);
    
    // view
    GLKMatrix4 viewMatrix = GLKMatrix4MakeTranslation(0, 0, -5);
    
    // render objects
    [_cube render:viewMatrix];
    

}

// updates every frame
- (void)update {
    [_cube updateWithDelta:self.timeSinceLastUpdate];
}


@end

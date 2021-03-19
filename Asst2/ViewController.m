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




- (void)setupScene {
    _shader = [[BaseEffect alloc]
               initWithVertexShader:@"VertexShader.glsl" fragmentShader:@"FragmentShader.glsl"];
    _cube = [[Cube alloc] initWithShader:_shader];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [_cube render];
    

}


@end

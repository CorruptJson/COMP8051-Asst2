#import "ViewController.h"
#import "Vertex.h"
#import "BaseEffect.h"
#import "Cube.h"

@implementation ViewController {
    BaseEffect *_shader;
    Cube *_cube, *_cube2;
    float i;
    
    // IB ACTION VARIABLES
    float rotX;
    float rotY;
    float posX;
    float posY;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:(kEAGLRenderingAPIOpenGLES3)];
    
    [EAGLContext setCurrentContext:view.context];
    [self setupScene];
    
    // Double tap gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.numberOfTapsRequired = 2;
        [self.view addGestureRecognizer:tapGesture];
}


// Double tap handler
- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        NSLog(@"TAPPED THE SCREEN!");
    }
}


// CONTROLS
- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    // Rotate cube
    if(sender.numberOfTouches == 1){
        // Will use translation on screen space as rotation factor
        CGPoint translation = [sender translationInView:sender.view];

        float x = translation.x/sender.view.frame.size.width;
        float y = translation.y/sender.view.frame.size.height;

        // Check direction of travel
        CGPoint velocity = [sender velocityInView:self.view];

        // Travelling in y dir
        if(fabs(velocity.y) > fabs(velocity.x)){
            // Right
            if(velocity.y > 0){
                rotY += 0.1;
            }
            // Left
            if(velocity.y <0){
                rotY -= 0.1;
            }
        }
        // Travelling in x dir
        if(fabs(velocity.x) > fabs(velocity.y)){
            // Right
            if(velocity.x > 0){
                rotX += 0.1;
            }
            // Left
            if(velocity.x <0){
                rotX -= 0.1;
            }
        }
        
        NSLog(@"VELOCITY X: %f", velocity.x);
        NSLog(@"GESTURE X: %f", x);
        NSLog(@"VELOCITY Y: %f", velocity.y);
        NSLog(@"GESTURE Y: %f", y);
    }

    // Drag cube
    else if(sender.numberOfTouches == 2){
        NSLog(@"2 FING DRAG!");

    }
}





// called from viewDidLoad
- (void)setupScene {
    _shader = [[BaseEffect alloc]
               initWithVertexShader:@"VertexShader.glsl" fragmentShader:@"FragmentShader.glsl"];
    
    //create objects here
    _cube = [[Cube alloc] initWithShader:_shader];
    _cube2 = [[Cube alloc] initWithShader:_shader];
    _cube.position = GLKVector3Make(0, 0, 0);
    _cube2.position = GLKVector3Make(-2, 0, 0);
   
    
    
    
    _shader.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85), self.view.bounds.size.width / self.view.bounds.size.height, 1, 150);
}


// called repeatedly
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    // background color
    glClearColor(0, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // backface culling
    glEnable(GL_CULL_FACE);
    
    // view
    GLKMatrix4 viewMatrix = GLKMatrix4MakeTranslation(0, 0, -10);
    
    // Apply adjustement factor from IBAction gesture inputs.
    viewMatrix = GLKMatrix4MakeLookAt(0, 0, -10, rotX, rotY, 0, 0, 1, 0);
    
    // render objects
    [_cube render:viewMatrix];
    [_cube2 render:viewMatrix];
    [_cube2 renderAsWall];
}

// updates every frame
- (void)update {
    [_cube updateWithDelta:self.timeSinceLastUpdate];
    
    [_cube2 updateWithDelta:self.timeSinceLastUpdate];
    i+= 0.05;
}


@end

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
    float rotZ;
    float posX;
    float posY;
    float posZ;
    float rotationSpeed;
    float movementSpeed;
    float SavedRotX;
    float SavedRotY;
    float SavedRotZ;
    float SavedPosX;
    float SavedPosY;
    float SavedPosZ;
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
    
    // Set default speeds for movement and rotation
    rotationSpeed = 0.1f;
    movementSpeed = 0.2f;
    
    // Set default camera orientation
    posX = 0.0f;
    posY = 0.0f;
    posZ = -10.0f;
    rotX = 0.0f;
    rotY = 0.0f;
    rotZ = 0.0f;
    
    // Save the orientation to be restored later.
    SavedPosX = posX;
    SavedPosY = posY;
    SavedPosZ = posZ;
    SavedRotX = rotX;
    SavedRotY = rotY;
    SavedRotZ = rotZ;
}


// Double tap handler
- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        // Reset to starting position here.
    }
}


// CONTROLS

// Rotate camera on drag
- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    // Rotate camera
    if(sender.numberOfTouches == 1){
        // Check direction of travel
        CGPoint velocity = [sender velocityInView:self.view];

        // Travelling in y dir
        if(fabs(velocity.y) > fabs(velocity.x)){
            // Right
            if(velocity.y > 0){
                rotY += rotationSpeed;
            }
            // Left
            if(velocity.y <0){
                rotY -= rotationSpeed;
            }
        }
        // Travelling in x dir
        if(fabs(velocity.x) > fabs(velocity.y)){
            // Right
            if(velocity.x > 0){
                rotX += rotationSpeed;
            }
            // Left
            if(velocity.x <0){
                rotX -= rotationSpeed;
            }
        }
    }
}

// Translate camera on tap
- (IBAction)hold:(UILongPressGestureRecognizer *)sender {
    if(sender.state == UIGestureRecognizerStateBegan){
        // When the hold begins
        NSLog(@"HOLD BEGAN");
        
        posX += movementSpeed;
    }
    if(sender.state == UIGestureRecognizerStateChanged){
        // While the hold is ongoing
        NSLog(@"HOLD CONTINUING");
        
        posX += movementSpeed;
    }
    if(sender.state == UIGestureRecognizerStateEnded){
        // When the hold is released
        NSLog(@"HOLD END");
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
    GLKMatrix4 viewMatrix = GLKMatrix4MakeTranslation(posX, posY, posZ);
    
    // Apply adjustement factor from IBAction gesture inputs.
    viewMatrix = GLKMatrix4MakeLookAt(posX, posY, posZ, rotX, rotY, rotZ, 0, 1, 0);
    
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

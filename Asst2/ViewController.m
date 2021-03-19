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
    float rotationAngleX;
    float rotationAngleY;
    float rotationSpeed;
    float movementSpeed;
    float SavedRotX;
    float SavedRotY;
    float SavedRotZ;
    float SavedPosX;
    float SavedPosY;
    float SavedPosZ;
    float rotation;
    float savedRotation;
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
    rotationAngleX = 0.0f;
    rotationAngleY = 0.0f;
    rotationSpeed = 1.0f;
    movementSpeed = 0.2f;
    
    // Set default camera orientation
    posX = 0.0f;
    posY = 0.0f;
    posZ = -10.0f;
    rotX = 0.0f;
    rotY = 0.0f;
    rotZ = 0.0f;
    rotation = 45.0f;
    
    // Save the orientation to be restored later.
    SavedPosX = posX;
    SavedPosY = posY;
    SavedPosZ = posZ;
    SavedRotX = rotX;
    SavedRotY = rotY;
    SavedRotZ = rotZ;
    savedRotation = rotation;
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
//        if(fabs(velocity.y) > fabs(velocity.x)){
//            // Up
//            if(velocity.y > 0){
//                rotationAngleY += rotationSpeed;
////                rotY = posY + sin(rotationAngleY);
//            }
//            // Down
//            if(velocity.y <0){
//                rotationAngleY -= rotationSpeed;
////                rotY = posY + sin(rotationAngleY);
//            }
//        }
        // Travelling in x dir
        if(fabs(velocity.x) > fabs(velocity.y)){
            if(rotation > 360){
                rotation = 0;
            }
            if(rotation < 0){
                rotation = 360;
            }
            else if(rotation >= 0 || rotation < 90){
                rotationAngleY = (90.0f) / 10.0f;
                rotationAngleX = (-90.0f + (rotation * 2.0f))/10.0f;
            }
            else if(rotation >= 90 || rotation < 180){
                rotationAngleY = (90.0f - ((rotation-90) * 2.0f))/10.0f;
                rotationAngleX = 90.0f/10.0f;
            }
            else if(rotation >= 180 || rotation < 270){
                rotationAngleY = (-90.0f)/10.0f;
                rotationAngleX = (90.0f - ((rotation-180) * 2.0f))/10.0f;
            }
            else if(rotation >= 270 || rotation < 360){
                rotationAngleY = (-90.0f + ((rotation-270) * 2.0f))/10.0f;
                rotationAngleX = -90.0f/10.0f;
            }
                
            
            // Left
            if(velocity.x < 0){
                rotation -= rotationSpeed;
            }
            // Right
            if(velocity.x > 0){
                rotation += rotationSpeed;
            }
            NSLog(@"ROTATION: %f", rotation);
            NSLog(@"X: %f", rotationAngleX);
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
    _cube.position = GLKVector3Make(5, 0, 0);
    _cube2.position = GLKVector3Make(0, 0, 0);
   
    
    
    
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
    viewMatrix = GLKMatrix4MakeLookAt(posX, posY, posZ, rotationAngleX, 0, 0, 0, 1, 0);
    
    // render objects
    [_cube render:viewMatrix];
    [_cube2 renderAsWall:viewMatrix];

}

// updates every frame
- (void)update {
    [_cube updateWithDelta:self.timeSinceLastUpdate];
    
    [_cube2 updateWithDelta:self.timeSinceLastUpdate];
    i+= 0.05;
}


@end

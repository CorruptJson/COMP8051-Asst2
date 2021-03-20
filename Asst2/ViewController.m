#import "ViewController.h"
#import "Vertex.h"
#import "BaseEffect.h"
#import "Cube.h"

@implementation ViewController {
    BaseEffect *_shader;
    Cube *_cube;
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
    float savedRotX;
    float SavedPosX;
    float SavedPosY;
    float SavedPosZ;
    float rotation;
    float savedRotation;

    
}


//entrance: bottom left
//exit: top right

bool *maze[4][4] = {
    {false, false, false, true},
    {true, false, false, true},
    {true, true, true, true},
    {true, false, false, true},
};

NSMutableArray<Cube *> *cubes;



- (void)viewDidLoad {
    [super viewDidLoad];
    cubes = [[NSMutableArray alloc] initWithCapacity:16];
    
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:(kEAGLRenderingAPIOpenGLES3)];
    
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    
    [EAGLContext setCurrentContext:view.context];
    [self setupScene];
    
    // Double tap gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.numberOfTapsRequired = 2;
        [self.view addGestureRecognizer:tapGesture];
    
    // Set default speeds for movement and rotation
    rotationAngleX = 0.0f;
    rotationSpeed = 1.0f;
    movementSpeed = 0.2f;
    
    // Set default camera orientation
    posX = 0.0f;
    posY = 0.0f;
    posZ = -7.0f;
    rotation = 45.0f;
    
    // Save the orientation to be restored later.
    SavedPosX = posX;
    SavedPosY = posY;
    SavedPosZ = posZ;
    savedRotX = rotationAngleX;
    savedRotation = rotation;
}


// Double tap handler
- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        // Reset to starting position here.
        posX = SavedPosX;
        posY = SavedPosY;
        posZ = SavedPosZ;
        rotationAngleX = savedRotX;
        rotation = savedRotation;
    }
}


// CONTROLS

// Rotate camera on drag
- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    // Move Camera
    if(sender.numberOfTouches == 1){
        CGPoint velocity = [sender velocityInView:self.view];
        
        // Y-direction
        if(fabs(velocity.y) > fabs(velocity.x)){
            // Up
            if(velocity.y > 0){
                // USING POS Z HERE SINCE IT IS Y ON SCREEN SPACE BUT CORRELATING MOVEMENT IS Z IN 3D SPACE
                posZ += movementSpeed;
            }
            // Down
            if(velocity.y < 0){
                posZ -= movementSpeed;
            }
        }
        // X-direction
        if(fabs(velocity.x) > fabs(velocity.y)){
            // Right
            if(velocity.x > 0){
                posX += movementSpeed;
            }
            // Left
            if(velocity.x < 0){
                posX -= movementSpeed;
            }
        }
    }
    
    // Rotate camera
    if(sender.numberOfTouches == 2){
        // Check direction of travel
        CGPoint velocity = [sender velocityInView:self.view];
        
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
        }
    }
}


// called from viewDidLoad
- (void)setupScene {
    _shader = [[BaseEffect alloc]
               initWithVertexShader:@"VertexShader.glsl" fragmentShader:@"FragmentShader.glsl"];
    
    //create objects here
    
    _cube = [[Cube alloc] initWithShader:_shader];
    _cube.position = GLKVector3Make(1.5,0,-9);
    _cube.scale = 0.5;

    
    // Set walls to be active for maze
    for (int r = 0; r < 4; r++) {
        for (int c = 0; c < 4; c++) {
            [cubes insertObject:[[Cube alloc] initWithShader:_shader] atIndex:((r * 4) + c)];
            cubes[(r * 4) + c].position = GLKVector3Make(c * -2, 0 ,r * -2);
            
            if ( (r == 0 && c != 3 ) || ((r * 4 + c != 3) && maze[r-1][c] == false)) {
                cubes[(r * 4) + c].north = BOTH;
            }
            if ( c == 0 || maze[r][c-1] == false) {
                cubes[(r * 4) + c].west = BOTH;
            }
            if ( c == 3 || maze[r][c+1] == false) {
                cubes[(r * 4) + c].east = BOTH;
            }
            if ( (r == 3 && c!= 0) || ((r * 4 + c != 12) && maze[r+1][c] == false)) {
                cubes[(r * 4) + c].south = BOTH;
            }
            // Center empty walls
            if (r != 0 && r != 3 && c != 0 && c!=3 && maze[r][c] == false) {
                cubes[(r * 4) + c].north = EMPTY;
                cubes[(r * 4) + c].west = EMPTY;
                cubes[(r * 4) + c].east = EMPTY;
                cubes[(r * 4) + c].south = EMPTY;
            }
            


            
        }
    }
   
    
    
    
    _shader.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85), self.view.bounds.size.width / self.view.bounds.size.height, 1, 150);
}


// called repeatedly
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    // background color
    glClearColor(0, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);

    
    // Enable blend mode for texturing
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    // view
    GLKMatrix4 viewMatrix = GLKMatrix4MakeTranslation(posX, posY, posZ);
    
    // Rotation
    //GLKQuaternion quat = GLKQuaternionMakeWithAngleAndAxis(-rotation, rotationAngleX, rotationAngleY, 0);
    
    //GLKMatrix4 rotationMatrix = GLKMatrix4MakeWithQuaternion(quat);
    
//    GLKVector3 forwardDir = GLKVector3Make(SavedPosX, SavedPosY, SavedPosZ);
//    GLKVector3 rotatedWithForward = GLKMatrix4MultiplyVector3(rotationMatrix, forwardDir);
//    GLKVector3 positionVec = GLKVector3Make(posX, posY, posZ);
//    GLKVector3 target = GLKVector3Add(positionVec, rotatedWithForward);
    
    // Apply adjustement factor from IBAction gesture inputs.
    viewMatrix = GLKMatrix4Multiply(viewMatrix, GLKMatrix4MakeLookAt(SavedPosX, SavedPosY, SavedPosZ, rotationAngleX, 0, 0, 0, 1, 0));
    
    
    // render objects
    for (int i = 0; i < 16; i++) {
        [cubes[i] renderAsWall:viewMatrix];
    }
    [_cube render:viewMatrix];


}

// updates every frame
- (void)update {
    [_cube updateWithDelta:self.timeSinceLastUpdate];
}


@end

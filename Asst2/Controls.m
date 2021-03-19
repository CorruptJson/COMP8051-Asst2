//
//  Controls.m
//  AssignmentOneTest

#import "Controls.h"
#import <GLKit/GLKit.h>

@interface Controls ()
{
    // 1
    // Depth
    float   _depth;
}

@end

@implementation Controls

- (id)initWithDepth:(float)z Scale:(float)scale Translation:(GLKVector2)trans
{
    if(self = [super init])
    {
        // 2
        // Depth
        _depth = z;
    }
    
    return self;
}

- (void)start
{
}

- (void)scale:(float)scale
{
}

- (void)translate:(GLKVector2)trans multiply:(float)mult
{
}

- (GLKMatrix4)getModelViewMatrix
{
    // 3
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 0.0f, 0.0f, -_depth);
    
    return modelViewMatrix;
}

@end


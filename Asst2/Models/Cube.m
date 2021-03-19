//
//  Cube.m
//  Asst2
//
//  Created by socas on 2021-03-19.
//

#import <Foundation/Foundation.h>
#import "Cube.h"

@implementation Cube


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
    7, 0, 3
};
// _indexCount = sizeof(indices) / sizeof(indices[0]);

- (instancetype)initWithShader:(BaseEffect *)shader {
    if ((self = [super initWithName:"cube" shader:shader vertices:(Vertex *)vertices vertexCount:sizeof(vertices)/sizeof(vertices[0]) indices:indices indexCount:sizeof(indices)/sizeof(indices[0])])) {
            
    }
    return self;
}

- (void)updateWithDelta:(NSTimeInterval)dt {
    self.rotationZ += M_PI * dt;
    self.rotationY += M_PI * dt;
}


@end

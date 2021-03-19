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
    {{1,-1,0}, {1,0,0,1}}, //red
    {{1,1,0}, {0,1,0,1}}, //green
    {{-1,1,0}, {0,1,1,1}}, // blue
    {{-1,-1,0}, {0,0,0, 1}} // black
};

const static GLubyte indices[] = {
    0, 1, 2,
    2, 3, 0
};
// _indexCount = sizeof(indices) / sizeof(indices[0]);

- (instancetype)initWithShader:(BaseEffect *)shader {
    if ((self = [super initWithName:"cube" shader:shader vertices:(Vertex *)vertices vertexCount:sizeof(vertices)/sizeof(vertices[0]) indices:indices indexCount:sizeof(indices)/sizeof(indices[0])])) {
            
    }
    return self;
}

@end

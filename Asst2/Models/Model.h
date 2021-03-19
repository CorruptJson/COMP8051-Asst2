//
//  Model.h
//  Asst2
//
//  Created by socas on 2021-03-18.
//

#import <Foundation/Foundation.h>
#import "Vertex.h"
#import "BaseEffect.h"

@import GLKit;


@interface Model : NSObject


@property (nonatomic, strong) BaseEffect *shader;
@property (nonatomic, assign) GLKVector3 position;
@property (nonatomic) float rotationX;
@property (nonatomic) float rotationY;
@property (nonatomic) float rotationZ;
@property (nonatomic) float scale;


- (instancetype)initWithName:(char *)name shader:(BaseEffect *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)vertexCount indices:(GLubyte *) indices indexCount:(unsigned int)indexCount;

- (void)render:(GLKMatrix4)parentModelViewMatrix;
- (void)updateWithDelta:(NSTimeInterval)dt;
@end


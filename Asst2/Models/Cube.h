//
//  Cube.h
//  Asst2
//
//  Created by socas on 2021-03-18.
//

#import <Foundation/Foundation.h>
#import "Vertex.h"
#import "BaseEffect.h"

@import GLKit;

typedef enum Wall{
    EMPTY,
    BOTH,
    LEFT,
    RIGHT
}Wall;

@interface Cube : NSObject


@property (nonatomic) BaseEffect *shader;
@property (nonatomic) GLuint _vao;
@property (nonatomic, assign) GLKVector3 position;
@property (nonatomic) float rotationX;
@property (nonatomic) float rotationY;
@property (nonatomic) float rotationZ;
@property (nonatomic) float scale;
@property (nonatomic) bool isRotating;
@property (nonatomic) enum Wall north, east, south, west;
@property (nonatomic) GLuint crateTex, wallTex, floorTex;


- (instancetype)initWithName:(char *)name shader:(BaseEffect *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)vertexCount indices:(GLubyte *) indices indexCount:(unsigned int)indexCount;
- (instancetype)initWithShader:(BaseEffect *)shader;
- (GLKMatrix4)modelMatrix;
- (void)render:(GLKMatrix4)parentModelViewMatrix;
- (void)renderAsWall:(GLKMatrix4)parentModelViewMatrix;
- (void)renderAsFloor:(GLKMatrix4)parentModelViewMatrix;
- (void)updateWithDelta:(NSTimeInterval)dt;
-(GLuint)loadTexture: (NSString *)filename;

@end


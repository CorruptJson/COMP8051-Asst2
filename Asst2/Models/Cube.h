//
//  Cube.h
//  Asst2
//
//  Created by socas on 2021-03-19.
//

#import "Model.h"
#import "BaseEffect.h"

@interface Cube : Model

@property (nonatomic) bool isRotating;

- (instancetype)initWithShader:(BaseEffect *)shader;
- (void)renderAsWall;

@end

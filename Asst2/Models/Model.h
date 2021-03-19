//
//  Model.h
//  Asst2
//
//  Created by socas on 2021-03-18.
//

#import <Foundation/Foundation.h>
#import "Vertex.h"
#import "BaseEffect.h"

@interface Model : NSObject


@property (nonatomic, strong) BaseEffect *shader;

- (instancetype)initWithName:(char *)name shader:(BaseEffect *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)vertexCount indices:(GLubyte *) indices indexCount:(unsigned int)indexCount;

- (void)render;

@end


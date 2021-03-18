//
//  BaseEffect.h
//  Asst2
//
//  Created by socas on 2021-03-18.
//

#import <Foundation/Foundation.h>

@import GLKit;

@interface BaseEffect : NSObject

@property (nonatomic, assign) GLuint programHandle;


- (id)initWithVertexShader:(NSString *)vertexShader
            fragmentShader:(NSString *)fragmentShader;

- (void)prepareToDraw;

@end

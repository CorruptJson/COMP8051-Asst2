//
//  Controls.h
//  AssignmentOneTest
//
//  Created by Hoang-Yen Chung on 2021-02-17.
//

#ifndef Controls_h
#define Controls_h

#import <GLKit/GLKit.h>

@interface Controls : NSObject

- (id)initWithDepth:(float)z Scale:(float)scale Translation:(GLKVector2)trans;
- (void)start;
- (void)scale:(float)scale;
- (void)translate:(GLKVector2)trans multiply:(float)mult;
- (GLKMatrix4)getModelViewMatrix;

@end


#endif /* Controls_h */

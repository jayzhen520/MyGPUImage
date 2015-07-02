#import "GPUImageThreeInputFilter.h"
#import <GLKit/GLKit.h>

@interface GPUImageSaturationBlendFilter : GPUImageTwoInputFilter
{
    GLint factorUniform;
    
    GLuint mvpUniform;
    
    GLKVector3 movexyz;
    GLKVector3 rotatexyz;
    float radians;
    GLKVector3 scalexyz;
    
    GLfloat rotateZ;
    //other factor.
}

@property(readwrite, nonatomic) CGFloat factor;
@property(readwrite, nonatomic) GLKMatrix4 mvp;

- (void)translateX:(float) xt Y:(float) yt Z:(float)zt;

- (void)rotateX:(float)xr Y:(float)yr Z:(float)zr radians:(float)ra;

- (void)scaleX:(float)sx Y:(float)sy Z:(float)sz;

- (void)setMvp;

@end

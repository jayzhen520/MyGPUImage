#import "GPUImageTwoInputFilter.h"
#import <GLKit/GLKit.h>

@interface GPUImageSaturationBlendFilter : GPUImageTwoInputFilter
{
    GLint picAspectUniform;
    GLint fbrightnessUniform;
    
    GLint faceSourceSizeAspectUniform;
    
    GLuint mvpUniform;
    
    float last_tx;
    float last_ty;
    
    float last_s;
    
    float last_r;
    
//    GLKVector3 movexyz;
//    GLKVector3 rotatexyz;
//    float radians;
//    GLKVector3 scalexyz;
    
//    GLfloat rotateZ;
    //other factor.
}

@property(readwrite, nonatomic) CGFloat picAspect;
@property(readwrite, nonatomic) CGFloat fbrightness;
@property(readwrite, nonatomic) GLKMatrix4 mvp;
@property(readwrite, nonatomic) CGFloat faceSourceSizeAspect;


/*
 以下三个函数请使用增量值作为输入，通常获得的值（x,y）为手势的末端与手势初始位置之差，这里要输入的值是此次的(x,y)-上次的(x,y)
 */
- (void)translateX:(float) xt Y:(float) yt;

- (void)rotate:(float)ra;

- (void)scaleX:(float)sx Y:(float)sy;

/*
 *此函数只在用户对图片（而非相机）处理时使用。
 */
- (void)newFrameReady;

@end

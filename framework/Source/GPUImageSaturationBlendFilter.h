#import "GPUImageTwoInputFilter.h"

@interface GPUImageSaturationBlendFilter : GPUImageTwoInputFilter
{
    GLint factorUniform;
}

@property(readwrite, nonatomic) CGFloat factor;

@end

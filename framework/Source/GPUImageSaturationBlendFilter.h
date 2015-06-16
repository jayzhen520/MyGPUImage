#import "GPUImageThreeInputFilter.h"

@interface GPUImageSaturationBlendFilter : GPUImageThreeInputFilter
{
    GLint factorUniform;
}

@property(readwrite, nonatomic) CGFloat factor;

@end

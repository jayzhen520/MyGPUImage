#import "GPUImageSaturationBlendFilter.h"

/**
 * Saturation blend mode based upon pseudo code from the PDF specification.
 */
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kGPUImageSaturationBlendFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D inputImageTexture3;
 
 uniform lowp float factor;
 
 highp vec4 gray_filter(lowp vec4 inputColor){
     highp float gray = 0.299 * inputColor.r + 0.587 * inputColor.g + 0.114 * inputColor.b;
     return vec4(gray, gray, gray, inputColor.a);
 }
 
 lowp vec4 bright_contrast_filter(lowp vec4 inputColor, lowp float brightness, lowp float contrast){
     lowp vec3 resultColor = (inputColor.rgb - 0.5) * contrast + 0.5 + brightness;
     return vec4(resultColor.rgb, inputColor.a);
 }
 
 void main()
 {

     highp vec4 cameraColor = texture2D(inputImageTexture, textureCoordinate);
     highp vec4 squareColor = texture2D(inputImageTexture2, textureCoordinate);
     highp vec4 holeColor = texture2D(inputImageTexture3, textureCoordinate);
     
     cameraColor = gray_filter(cameraColor);
     cameraColor = bright_contrast_filter(cameraColor, factor, 1.0);
     
     highp vec4 c = cameraColor * (1.0 - holeColor.a) + squareColor * holeColor.a;
     
     //gl_FragColor = mix(cameraColor, stencilColor, stencilColor.a);
     gl_FragColor = c;
     //gl_FragColor = stencilColor;
 }
);
#else
NSString *const kGPUImageSaturationBlendFragmentShaderString = SHADER_STRING
(
 varying vec2 textureCoordinate;
 varying vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 float lum(vec3 c) {
     return dot(c, vec3(0.3, 0.59, 0.11));
 }
 
 vec3 clipcolor(vec3 c) {
     float l = lum(c);
     float n = min(min(c.r, c.g), c.b);
     float x = max(max(c.r, c.g), c.b);
     
     if (n < 0.0) {
         c.r = l + ((c.r - l) * l) / (l - n);
         c.g = l + ((c.g - l) * l) / (l - n);
         c.b = l + ((c.b - l) * l) / (l - n);
     }
     if (x > 1.0) {
         c.r = l + ((c.r - l) * (1.0 - l)) / (x - l);
         c.g = l + ((c.g - l) * (1.0 - l)) / (x - l);
         c.b = l + ((c.b - l) * (1.0 - l)) / (x - l);
     }
     
     return c;
 }
 
 vec3 setlum(vec3 c, float l) {
     float d = l - lum(c);
     c = c + vec3(d);
     return clipcolor(c);
 }
 
 float sat(vec3 c) {
     float n = min(min(c.r, c.g), c.b);
     float x = max(max(c.r, c.g), c.b);
     return x - n;
 }
 
 float mid(float cmin, float cmid, float cmax, float s) {
     return ((cmid - cmin) * s) / (cmax - cmin);
 }
 
 vec3 setsat(vec3 c, float s) {
     if (c.r > c.g) {
         if (c.r > c.b) {
             if (c.g > c.b) {
                 /* g is mid, b is min */
                 c.g = mid(c.b, c.g, c.r, s);
                 c.b = 0.0;
             } else {
                 /* b is mid, g is min */
                 c.b = mid(c.g, c.b, c.r, s);
                 c.g = 0.0;
             }
             c.r = s;
         } else {
             /* b is max, r is mid, g is min */
             c.r = mid(c.g, c.r, c.b, s);
             c.b = s;
             c.r = 0.0;
         }
     } else if (c.r > c.b) {
         /* g is max, r is mid, b is min */
         c.r = mid(c.b, c.r, c.g, s);
         c.g = s;
         c.b = 0.0;
     } else if (c.g > c.b) {
         /* g is max, b is mid, r is min */
         c.b = mid(c.r, c.b, c.g, s);
         c.g = s;
         c.r = 0.0;
     } else if (c.b > c.g) {
         /* b is max, g is mid, r is min */
         c.g = mid(c.r, c.g, c.b, s);
         c.b = s;
         c.r = 0.0;
     } else {
         c = vec3(0.0);
     }
     return c;
 }z
 
 void main()
 {
	 vec4 baseColor = texture2D(inputImageTexture, textureCoordinate);
	 vec4 overlayColor = texture2D(inputImageTexture2, textureCoordinate2);
     
     gl_FragColor = vec4(baseColor.rgb * (1.0 - overlayColor.a) + setlum(setsat(baseColor.rgb, sat(overlayColor.rgb)), lum(baseColor.rgb)) * overlayColor.a, baseColor.a);
 }
);
#endif


@implementation GPUImageSaturationBlendFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageSaturationBlendFragmentShaderString]))
    {
		return nil;
    }
    
    factorUniform = [filterProgram uniformIndex:@"factor"];
    self.factor = 0.5;
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setFactor:(CGFloat)newValue;
{
    _factor = newValue;
    
    [self setFloat:_factor forUniform:factorUniform program:filterProgram];
}

@end

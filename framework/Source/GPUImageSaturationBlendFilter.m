#import "GPUImageSaturationBlendFilter.h"
#import "GPUImageAddMiddleLayer.h"

/**
 * Saturation blend mode based upon pseudo code from the PDF specification.
 */
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE

NSString * const kGPUImageSaturationBlendVertexShaderString = SHADER_STRING
(
 attribute vec4 position;
 attribute vec4 inputTextureCoordinate;
 varying vec2 textureCoordinate;
 varying vec2 textureCoordinate2;
 
 uniform mat4 mvp;
 
 void main() {
     /*highp vec4 pos = mvp * position;
//     gl_Position = mvp * position;
//     pos.y *= 3.0;
     gl_Position = pos;
//     gl_Position = position;
     textureCoordinate = inputTextureCoordinate.xy;*/
     
     gl_Position = position;
     highp vec4 texPos = mvp * position;
     
     textureCoordinate = inputTextureCoordinate.xy;
     texPos.y *= 1920.0 / 1200.0;
     textureCoordinate2 = (texPos.xy + 1.0) / 2.0;
     
 }
);

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

     highp vec4 cameraColor;
     if(textureCoordinate2.x > 1.0 || textureCoordinate2.y > 1.0 || textureCoordinate2.x < 0.0 || textureCoordinate2.y < 0.0){
         cameraColor = vec4(0.0, 0.0, 0.0, 1.0);
     }else{
         cameraColor = texture2D(inputImageTexture3, textureCoordinate2);
     }
     
     
     highp vec4 squareColor = texture2D(inputImageTexture, textureCoordinate);
     highp vec4 holeColor = texture2D(inputImageTexture2, textureCoordinate);
     
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
    /*
     initWithVertexShaderFromString:(NSString *)vertexShaderString fragmentShaderFromString:(NSString *)fragmentShaderString;
     */
    if (!(self = [super initWithVertexShaderFromString:kGPUImageSaturationBlendVertexShaderString fragmentShaderFromString:kGPUImageSaturationBlendFragmentShaderString]))
    {
		return nil;
    }
    
    factorUniform = [filterProgram uniformIndex:@"factor"];
    self.factor = 0.5;
    
    /*
     * OpenGL Matrix
     */
//    _mvp = GLKMatrix4Identity;
    
    scalexyz.x = 1.0;
    scalexyz.y = 1.0;
    scalexyz.z = 1.0;
    
    rotatexyz.z = 1.0;
//    movexyz = {0.0, 0.0, 0.0};
//    rotatexyz = {0.0, 0.0, 0.0};
    
    mvpUniform = [filterProgram uniformIndex:@"mvp"];
//    self.mvp = GLKMatrix4Identity;
//    [self setMvp:GLKMatrix4Identity];
    self.mvp = GLKMatrix4Identity;
    [self setMvp:GLKMatrix4Identity];
    
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setFactor:(CGFloat)newValue
{
    _factor = newValue;
    
    [self setFloat:_factor forUniform:factorUniform program:filterProgram];
}

- (void)translateX:(float) tx Y:(float) ty Z:(float) tz
{
    //GLKMatrix4Translate(mvp, tx, ty, tz);
    movexyz.x = tx;
    movexyz.y = ty;
    movexyz.z = tz;
}

- (void)translateX:(float) tx
{
    //GLKMatrix4Translate(mvp, tx, ty, tz);
    movexyz.x = tx;
}

- (void)translateY:(float) ty
{
    //GLKMatrix4Translate(mvp, tx, ty, tz);
    movexyz.y = ty;
}

- (void)rotateX:(float)rx Y:(float)ry Z:(float)rz radians:(float)ra
{
    //GLKMatrix4Translate(mvp, rx, ry, rz);
    //对rx,ry,rz进行判断，如果rx,ry,rz都为0，系统函数在进行Normalize时会出现错误。
    rotatexyz.x = rx;
    rotatexyz.y = ry;
    rotatexyz.z = rz;
    
    radians = ra;
}

- (void)scaleX:(float)sx Y:(float)sy Z:(float)sz
{
    scalexyz.x = sx;
    scalexyz.y = sy;
    scalexyz.z = sz;
}

- (void)setMvp:(GLKMatrix4)newValue
{
    _mvp = newValue;
    
    GLKMatrix4 temp1;
    GLKMatrix4 temp2;
    GLKMatrix4 temp3;
    temp1 = GLKMatrix4ScaleWithVector3(_mvp, scalexyz);
    temp2 = GLKMatrix4RotateWithVector3(temp1, radians, rotatexyz);
    temp3 = GLKMatrix4TranslateWithVector3(temp2, movexyz);
    
    GPUMatrix4x4 mvp_trans;//GPUImage风格
    //GPUMatrix4x4 * xx = malloc(sizeof(GPUMatrix4x4));
    [GPUImageAddMiddleLayer MatrixTransFromGLKitMatrix4:temp3 ToGPUMatrix4x4:&mvp_trans];
    
    [self setMatrix4f:mvp_trans forUniform:mvpUniform program:filterProgram];
}

- (void)updateMvp;
{
    GLKMatrix4 temp1;
    GLKMatrix4 temp2;
    GLKMatrix4 temp3;
    temp1 = GLKMatrix4ScaleWithVector3(_mvp, scalexyz);
    temp2 = GLKMatrix4RotateWithVector3(temp1, radians, rotatexyz);
    temp3 = GLKMatrix4TranslateWithVector3(temp2, movexyz);

    GPUMatrix4x4 mvp_trans;//GPUImage风格
    //GPUMatrix4x4 * xx = malloc(sizeof(GPUMatrix4x4));
    [GPUImageAddMiddleLayer MatrixTransFromGLKitMatrix4:temp3 ToGPUMatrix4x4:&mvp_trans];

    [self setMatrix4f:mvp_trans forUniform:mvpUniform program:filterProgram];

}

@end

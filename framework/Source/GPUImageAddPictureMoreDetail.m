//
//  GPUImageAddPictureMoreDetail.m
//  GPUImage
//
//  Created by 季震 on 6/26/15.
//  Copyright (c) 2015 Brad Larson. All rights reserved.
//

#import "GPUImageAddPictureMoreDetail.h"

@implementation GPUImageAddPictureMoreDetail

- (id)initWithImage:(UIImage *)newImageSource smoothlyScaleOutput:(BOOL)smoothlyScaleOutput withPath:(NSString *)picPath;
{
    _picturePath = picPath;
    
    return [self initWithCGImage:[newImageSource CGImage] smoothlyScaleOutput:smoothlyScaleOutput];
}

- (BOOL)processImageWithCompletionHandler:(void (^)(void))completion;{
    if(hasProcessedImage == NO){
        return [super processImageWithCompletionHandler:completion];
    }
    return YES;
}

@end

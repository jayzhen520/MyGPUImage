//
//  GPUImageAddOutputFuncAdd.m
//  GPUImage
//
//  Created by 季震 on 6/28/15.
//  Copyright (c) 2015 Brad Larson. All rights reserved.
//

#import "GPUImageAddOutputFuncAdd.h"

@implementation GPUImageAddOutputFuncAdd

- (void)delTarget:(id<GPUImageInput>)newTarget atTextureLocation:(NSInteger)textureLocation;
{
    /*如果没有这个target, 就不用删除了。*/
    if(![targets containsObject:newTarget])
    {
        return;
    }
    
    cachedMaximumOutputSize = CGSizeZero;
    runSynchronouslyOnVideoProcessingQueue(^{
        /*[self setInputFramebufferForTarget:newTarget atIndex:textureLocation];
        [targets addObject:newTarget];
        [targetTextureIndices addObject:[NSNumber numberWithInteger:textureLocation]];*/
//        [self delInputFramebufferForTarget:oldTarget andIndex:textureLocation];
//        [targets delObject:oldTarget];
//        [targetTextureIndices delObject:[NSNumber numberWithInteger:textureLocation]];

        
        allTargetsWantMonochromeData = allTargetsWantMonochromeData && [newTarget wantsMonochromeInput];
    });
}

@end

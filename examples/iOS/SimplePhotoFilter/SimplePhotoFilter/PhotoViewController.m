#import <Foundation/Foundation.h>
#import "PhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    mode = BAOZOUFACE_USE_PHOTO;
    
    return self;
}

- (void)loadView 
{
	CGRect mainScreenFrame = [[UIScreen mainScreen] bounds];
	    
    // Yes, I know I'm a caveman for doing all this by hand
	GPUImageView *primaryView = [[GPUImageView alloc] initWithFrame:mainScreenFrame];
	primaryView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    filterSettingsSlider = [[UISlider alloc] initWithFrame:CGRectMake(25.0, mainScreenFrame.size.height - 30.0, mainScreenFrame.size.width - 50.0, 40.0)];
    [filterSettingsSlider addTarget:self action:@selector(updateSliderValue:) forControlEvents:UIControlEventValueChanged];
	filterSettingsSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    filterSettingsSlider.minimumValue = 0.0;
    filterSettingsSlider.maximumValue = 3.0;
    filterSettingsSlider.value = 0.5;
    
    [primaryView addSubview:filterSettingsSlider];
    
    photoCaptureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    photoCaptureButton.frame = CGRectMake(round(mainScreenFrame.size.width / 2.0 - 150.0 / 2.0), mainScreenFrame.size.height - 90.0, 150.0, 40.0);
    [photoCaptureButton setTitle:@"Capture Photo" forState:UIControlStateNormal];
	photoCaptureButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [photoCaptureButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [photoCaptureButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    [primaryView addSubview:photoCaptureButton];
    
    ////////////////////////////////////////////
    
//    - (IBAction)updateSliderValue:(id)sender
    CGRect rectlr = {25.0, mainScreenFrame.size.height - 150.0, mainScreenFrame.size.width - 50.0, 40.0};
    UISlider * slr = [self addSlider:picLeftRightMove inPosition:&rectlr withmaxis:1.0f minis:-1.0f originis:0.0 useFuncClass:@selector(lr:)];
    [primaryView addSubview:slr];
    
    CGRect rectud = {25.0, mainScreenFrame.size.height - 120.0, mainScreenFrame.size.width - 50.0, 40.0};
    UISlider * sud = [self addSlider:picUpDownMove inPosition:&rectud withmaxis:1.0f minis:-1.0f originis:0.0 useFuncClass:@selector(ud:)];
    [primaryView addSubview:sud];
    
    CGRect rects = {25.0, mainScreenFrame.size.height - 90.0, mainScreenFrame.size.width - 50.0, 40.0};
    UISlider * ss = [self addSlider:picScale inPosition:&rects withmaxis:4.0f minis:0.2f originis:1.0 useFuncClass:@selector(s:)];
    [primaryView addSubview:ss];
    
    CGRect rectr = {25.0, mainScreenFrame.size.height - 60.0, mainScreenFrame.size.width - 50.0, 40.0};
    UISlider * sr = [self addSlider:picRotate inPosition:&rectr withmaxis:10.0f minis:-10.0f originis:1.0 useFuncClass:@selector(r:)];
    [primaryView addSubview:sr];
    
    ////////////////////////////////////////////
    
    
	self.view = primaryView;	
}

- (UISlider *)addSlider:(UISlider *)slider inPosition:(CGRect *)rect withmaxis:(float)max minis:(float)min originis:(float)origin useFuncClass:(SEL)ufc;
{
    /*add sliter to control photo*/
    slider = [[UISlider alloc] initWithFrame:*rect];
    [slider addTarget:self action:ufc forControlEvents:UIControlEventValueChanged];
    slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    slider.minimumValue = min;
    slider.maximumValue = max;
    slider.value = origin;
    return slider;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    filter = [[GPUImageSaturationBlendFilter alloc] init];
    GPUImageView *filterView = (GPUImageView *)self.view;
    [filter addTarget:filterView];
    
    UIImage *inputImage;
    inputImage = [UIImage imageNamed:@"pic/pandas/表情600_hole.png"];
    
    sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
    [sourcePicture processImage];
    [sourcePicture addTarget:filter];
    
    switch (mode) {
        case BAOZOUFACE_USE_CAMERA:
            [self useCamera];
            break;
        case BAOZOUFACE_USE_PHOTO:
            [self usePhoto];
            break;
        default:
            break;
    }
    
}

- (void)useCamera{
    stillCamera = [[GPUImageStillCamera alloc] init];

    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    [stillCamera addTarget:filter];
    
    [stillCamera startCameraCapture];
}

- (void)usePhoto{
    UIImage * photoImage;
    photoImage = [UIImage imageNamed:@"pic/fbb.jpg"];
    sourcePhotoPicture = [[GPUImagePicture alloc]initWithImage:photoImage smoothlyScaleOutput:YES];
    [sourcePhotoPicture processImage];
    [sourcePhotoPicture addTarget:filter];
    
    GPUImageSaturationBlendFilter * baozoubiaoqingfilter = (GPUImageSaturationBlendFilter *)filter;
    CGSize pixelSizeOfImage = [sourcePhotoPicture outputImageSize];
    /*这个值应当在加载图片时就进行设置，因为这里没有出发加载图片的动作，因此初始没有进行设置，刚进来时，图会以正方形显示，会出现图像的变形*/
    float aspect = pixelSizeOfImage.width / (1.0 * pixelSizeOfImage.height);
    [baozoubiaoqingfilter setFaceSourceSizeAspect:aspect];
    [baozoubiaoqingfilter newFrameReady];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)updateSliderValue:(id)sender
{
//    [(GPUImagePixellateFilter *)filter setFractionalWidthOfAPixel:[(UISlider *)sender value]];
//    [(GPUImageGammaFilter *)filter setGamma:[(UISlider *)sender value]];
    
    GPUImageSaturationBlendFilter * baozoubiaoqingfilter = (GPUImageSaturationBlendFilter *)filter;
    [baozoubiaoqingfilter setFbrightness:[(UISlider *)sender value]];
    [baozoubiaoqingfilter newFrameReady];
    
}

- (IBAction)lr:(id)sender
{
    GPUImageSaturationBlendFilter * baozoubiaoqingfilter = (GPUImageSaturationBlendFilter *)filter;
    
    float xvalue = [(UISlider *)sender value];
    [baozoubiaoqingfilter translateX:xvalue Y:0.0];
    
    [baozoubiaoqingfilter newFrameReady];

//    [baozoubiaoqingfilter informTargetsAboutNewFrameAtTime:time];
}

- (IBAction)ud:(id)sender
{
    GPUImageSaturationBlendFilter * baozoubiaoqingfilter = (GPUImageSaturationBlendFilter *)filter;
    float yvalue = [(UISlider *)sender value];
    [baozoubiaoqingfilter translateX:0.0 Y:yvalue];

    [baozoubiaoqingfilter newFrameReady];
}

- (IBAction)s:(id)sender{
    
    GPUImageSaturationBlendFilter * baozoubiaoqingfilter = (GPUImageSaturationBlendFilter *)filter;
    
    float svalue = [(UISlider *)sender value];
    [baozoubiaoqingfilter scaleX:svalue Y:svalue];
    
    [baozoubiaoqingfilter newFrameReady];

}

-(IBAction)r:(id)sender{
    
    GPUImageSaturationBlendFilter * baozoubiaoqingfilter = (GPUImageSaturationBlendFilter *)filter;
    //默认为沿着z轴做旋转
    float rvalue = [(UISlider *)sender value];
    
    [baozoubiaoqingfilter rotate:rvalue];

    [baozoubiaoqingfilter newFrameReady];
}


- (IBAction)takePhoto:(id)sender;
{
    //[photoCaptureButton setEnabled:NO];
    
    /*[stillCamera capturePhotoAsJPEGProcessedUpToFilter:filter withCompletionHandler:^(NSData *processedJPEG, NSError *error){

        // Save to assets library
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        [library writeImageDataToSavedPhotosAlbum:processedJPEG metadata:stillCamera.currentCaptureMetadata completionBlock:^(NSURL *assetURL, NSError *error2)
         {
             if (error2) {
                 NSLog(@"ERROR: the image failed to be written");
             }
             else {
                 NSLog(@"PHOTO SAVED - assetURL: %@", assetURL);
             }
			 
             runOnMainQueueWithoutDeadlocking(^{
                 [photoCaptureButton setEnabled:YES];
             });
         }];
    }];*/
    
    
//    NSString * pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test2.png"];
//    
//    [UIImagePNGRepresentation(processedImage) writeToFile:pngPath atomically:YES];
//    
//    NSError * myError;
//    NSFileManager * fileMgr = [NSFileManager defaultManager];
//    NSString * documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&myError]);
    
    [stillCamera capturePhotoAsImageProcessedUpToFilter:filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        
         /*NSString * pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
        
        [UIImagePNGRepresentation(processedImage) writeToFile:pngPath atomically:YES];
        
        NSError * myError;
        NSFileManager * fileMgr = [NSFileManager defaultManager];
        NSString * documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&myError]);*/
        
        
        if (error) {
            NSLog(@"ERROR: could not capture = %@", error);
        } else {
            NSLog(@"PHOTO SAVED - ??");
            
            // save photo to album
            UIImageWriteToSavedPhotosAlbum(processedImage, nil, nil, nil);
        }
        
        
    }];
    
    
    
    
    
}

@end
































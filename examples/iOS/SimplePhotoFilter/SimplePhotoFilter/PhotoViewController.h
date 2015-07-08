#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface PhotoViewController : UIViewController
{
    GPUImageStillCamera *stillCamera;
    GPUImageOutput<GPUImageInput> *filter, *secondFilter, *terminalFilter;
    UISlider *filterSettingsSlider;
    UIButton *photoCaptureButton;
    
    UISlider *picLeftRightMove;
    UISlider *picUpDownMove;
    UISlider *picScale;
    UISlider *picRotate;
    
    //为渲染的两张图准备的，跟显示并无关系。
    GPUImagePicture *sourcePicture;
    GPUImagePicture * sourcePicture2;
}

- (IBAction)updateSliderValue:(id)sender;
- (IBAction)takePhoto:(id)sender;

- (IBAction)lr:(id)sender;
- (IBAction)ud:(id)sender;
- (IBAction)s:(id)sender;
- (IBAction)r:(id)sender;

@end

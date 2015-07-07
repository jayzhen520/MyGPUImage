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
    
    
    GPUImagePicture *sourcePicture;
    GPUImagePicture * sourcePicture2;
    
    GPUImagePicture *memoryPressurePicture1, *memoryPressurePicture2;
}

- (IBAction)updateSliderValue:(id)sender;
- (IBAction)takePhoto:(id)sender;

- (IBAction)lr:(id)sender;
- (IBAction)ud:(id)sender;
- (IBAction)s:(id)sender;
- (IBAction)r:(id)sender;

@end

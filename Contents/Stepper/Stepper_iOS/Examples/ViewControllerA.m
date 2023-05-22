//
//  ViewControllerA.m
//  GMStepperExample
//
//  Created by Kwan Hyun Son on 2020/11/07.
//

#import "ViewControllerA.h"
@import IosKit;

@interface ViewControllerA ()
@property (strong, nonatomic) IBOutletCollection(MGUStepper) NSArray <MGUStepper *>*steppers;
@property (weak, nonatomic) IBOutlet UIStepper *appleStepper;
#if DEBUG
@property (nonatomic, copy) void (^printTimerGaps)(void);
#endif
@end

@implementation ViewControllerA

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MGUStepper - xib";
    for (MGUStepper *stepper in self.steppers) {
        [stepper addTarget:self
                    action:@selector(stepperValueChanged:)
          forControlEvents:UIControlEventValueChanged];
    }
    
    [self.appleStepper addTarget:self
                          action:@selector(appleStepperValueChanged:forEvent:)
                forControlEvents:UIControlEventValueChanged];
    
#if DEBUG
    __block CFAbsoluteTime prevTime = 0.0f; // typedef CFTimeInterval CFAbsoluteTime;
    self.printTimerGaps = ^void(void) {
        CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
        if (prevTime != 0.0) {
            printf("now - prevTime : %f \n", now - prevTime);
        }
        prevTime = now;
    };
#endif
}


- (void)stepperValueChanged:(MGUStepper *)sender {
    NSLog(@"stepper.value %f", sender.value);
}

- (void)appleStepperValueChanged:(UIStepper *)sender forEvent:(UIEvent *)event {
    NSLog(@"stepper.value %f", sender.value);
    self.printTimerGaps();
}

@end

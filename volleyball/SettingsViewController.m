//
//  SettingsViewController.m
//  volleyball
//
//  Created by JASON HARRIS on 11/18/15.
//  Copyright © 2015 Jason Harris. All rights reserved.
//

#import "SettingsViewController.h"
#import <Masonry.h>

@interface SettingsViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setScreenHeightandWidth];
    // Do any additional setup after loading the view.
    UIImage *backgroundSlice = [UIImage imageNamed:@"background-slice_small_ocean&sand"];
    CGFloat sizeRatio = backgroundSlice.size.height / self.screenHeight;
    backgroundSlice = [UIImage imageWithCGImage:backgroundSlice.CGImage scale:sizeRatio orientation:backgroundSlice.imageOrientation];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundSlice];
    
    [self displayButtons];
}

-(void)displayButtons
{
    UIImage *exitButtonImage = [UIImage imageNamed:@"beachvolleyball-exitbutton"];
    CGFloat sizeRatio = exitButtonImage.size.height / self.screenHeight * 8;
    exitButtonImage = [UIImage imageWithCGImage:exitButtonImage.CGImage
                                          scale:sizeRatio                           // scales image down smaller
                                    orientation:UIImageOrientationUpMirrored];    //flips image
    self.backButton = [[UIButton alloc] init];
    self.backButton.accessibilityLabel = @"backButton";
    [self.backButton setImage:exitButtonImage forState:UIControlStateNormal];
    
    [self.view addSubview:self.backButton];
    
    NSLog(@"%1f",exitButtonImage.size.height);
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.bottomMargin.equalTo(self.view).offset(-15);
    }];
    
    
    NSArray *buttonArray = @[self.backButton];
    for (UIButton *button in buttonArray) {
        [button addTarget:self
                   action:@selector(buttonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    }
}




-(void)buttonClicked:(UIButton *)sender
{
    
    if([sender.accessibilityLabel isEqualToString:@"backButton"])
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:transition forKey:nil];
        
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setScreenHeightandWidth
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.screenWidth = MAX(screenSize.width, screenSize.height);
    self.screenHeight = MIN(screenSize.width, screenSize.height);
}

@end

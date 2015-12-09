//
//  SettingsViewController.m
//  volleyball
//
//  Created by JASON HARRIS on 11/18/15.
//  Copyright © 2015 Jason Harris. All rights reserved.
//

#import "SettingsViewController.h"
#import <Masonry.h>
#import "DebugMenu.h"
#import <Appirater.h>

@interface SettingsViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *settingsButton;
@property (nonatomic, strong) UILabel *rateMeButton;
@property (nonatomic, strong) UILabel *settingsText;
@property (nonatomic, strong) UILabel *developedByJasonHarris;

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
    [self addDevelopedByJasonHarris];
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
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.bottomMargin.equalTo(self.view).offset(-15);
    }];
    
    UIImage *settingsImage = [UIImage imageNamed:@"beachvolleyball-settingsButton"];
    sizeRatio = settingsImage.size.height / self.screenHeight * 8;
    settingsImage = [UIImage imageWithCGImage:settingsImage.CGImage
                                        scale:sizeRatio
                                  orientation:settingsImage.imageOrientation];
    
    self.settingsButton = [[UIButton alloc] init];
    self.settingsButton.accessibilityLabel = @"settings";
    [self.settingsButton setImage:settingsImage forState:UIControlStateNormal];
    
    [self.view addSubview:self.settingsButton];
    
    [self.settingsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backButton);
        make.left.equalTo(self.backButton.mas_right).offset(10);
    }];
    
    
    
    
    NSArray *buttonArray = @[self.backButton, self.settingsButton];
    for (UIButton *button in buttonArray) {
        [button addTarget:self
                   action:@selector(buttonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
    [self displayRateMeButton];
    [self displayRegularText];
}

-(void)displayRateMeButton
{
    self.rateMeButton = [[UILabel alloc] init];
    self.rateMeButton.accessibilityLabel = @"rateMeButton";
    self.rateMeButton.text = @"Rate This App";
    self.rateMeButton.textColor = [UIColor whiteColor];
    self.rateMeButton.font = [UIFont fontWithName:@"SpinCycleOT" size:self.screenHeight / 18];
    self.rateMeButton.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapLabelWithGesture:)];
    [self.rateMeButton addGestureRecognizer:tap];
    
    [self.view addSubview:self.rateMeButton];
    
    float widthIs = [self.rateMeButton.text boundingRectWithSize:self.rateMeButton.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:self.rateMeButton.font} context:nil].size.width + 5;
    float heightIs = [self.rateMeButton.text boundingRectWithSize:self.rateMeButton.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:self.rateMeButton.font} context:nil].size.height + 5;
    
    
    
    [self.rateMeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
//        make.bottom.equalTo(self.view).offset(-heightIs/2);
        make.centerY.equalTo(self.backButton);
        
    }];
}


-(void)didTapLabelWithGesture:(UILabel *)sendingLabel
{
    [Appirater setDebug:YES];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:kAppiraterDeclinedToRate];
    [userDefaults setBool:NO forKey:kAppiraterRatedCurrentVersion];
    [Appirater userDidSignificantEvent:YES];
}


-(void)displayRegularText
{
    
    self.settingsText = [[UILabel alloc] init];
    self.settingsText.text = @"In order to hit the ball, tap the side opposite of where you want the ball to travel, do not swipe. If you want to hit up, tap below the ball, if you want to hit right, tap left of the ball. \n \n Multiplayer will work with both Bluetooth and WiFi. For best performance please turn off Bluetooth and use only WiFi. The phones will connect if they are both have Wifi on or are on the same WiFi network. \n \n This app was created by Jason Harris.  Please email me any comments or suggestions at jason.harris.coding@gmail.com. \n \n Thank you to all friends and family who supported me and allowed me to bounce ideas off them.";
    self.settingsText.textColor = [UIColor whiteColor];
    self.settingsText.font = [UIFont fontWithName:@"Arial Hebrew" size:self.screenHeight / 23];
    self.settingsText.lineBreakMode = NSLineBreakByWordWrapping;
    self.settingsText.textAlignment = NSTextAlignmentCenter;
    self.settingsText.numberOfLines = 0;
    
    [self.view addSubview:self.settingsText];
    
    
    [self.settingsText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.screenHeight/15);
        make.width.equalTo(self.view).multipliedBy(0.9);
        make.centerX.equalTo(self.view);
    }];
}

-(void)addDevelopedByJasonHarris
{
    self.developedByJasonHarris = [[UILabel alloc] init];
    self.developedByJasonHarris.text = @"Developed by Jason Harris";
    self.developedByJasonHarris.textColor = [UIColor whiteColor];
    self.developedByJasonHarris.alpha = 0.95;
    self.developedByJasonHarris.font = [UIFont fontWithName:@"Arial Hebrew" size:self.screenHeight / 25];
    [self.view addSubview:self.developedByJasonHarris];
    
    [self.developedByJasonHarris mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.centerY.equalTo(self.backButton);
    }];
    
}


-(void)buttonClicked:(UIButton *)sender
{
    
    if([sender isEqual:self.backButton])
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:transition forKey:nil];
        
        [self dismissViewControllerAnimated:NO completion:nil];
    } else if ([sender isEqual:self.settingsButton])
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        
        SettingsViewController *debugVC = [[DebugMenu alloc] init];
        [self presentViewController:debugVC animated:NO completion:^{
            //completion
        }];

        
        
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

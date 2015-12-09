//
//  DebugMenu.m
//  volleyball
//
//  Created by JASON HARRIS on 12/8/15.
//  Copyright © 2015 Jason Harris. All rights reserved.
//

#import "DebugMenu.h"
#import <Masonry.h>
#import "gameAndScoreDetails.h"
#import <Appirater.h>

@interface DebugMenu () <UITextFieldDelegate>
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *debugText;
@property (nonatomic, strong) UILabel *developedByJasonHarris;

//DEBUG ONES
@property (nonatomic, strong) UITextField *debugEasiness;
@property (nonatomic, strong) UITextField *yDebugValue;
@property (nonatomic, strong) UITextField *debugGravity;
@property (nonatomic, strong) UITextField *debugForce;
@property (nonatomic, strong) UITextField *debugWaitTime;
@property (nonatomic, strong) UISwitch *debugModeSwitch;


@end

@implementation DebugMenu

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
    
    
    
    
    
    NSArray *buttonArray = @[self.backButton];
    for (UIButton *button in buttonArray) {
        [button addTarget:self
                   action:@selector(buttonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [self debugStuff];
    [self displayRegularText];
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
    
    self.debugText = [[UILabel alloc] init];
    self.debugText.text = @"THIS IS THE DEBUG MENU - PLEASE BE CAREFUL";
    self.debugText.textColor = [UIColor whiteColor];
    self.debugText.font = [UIFont fontWithName:@"Arial Hebrew" size:self.screenHeight / 23];
    self.debugText.lineBreakMode = NSLineBreakByWordWrapping;
    self.debugText.textAlignment = NSTextAlignmentCenter;
    self.debugText.numberOfLines = 0;
    
    [self.view addSubview:self.debugText];
    
    
    [self.debugText mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    if([sender.accessibilityLabel isEqualToString:@"backButton"])
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:transition forKey:nil];
        
        [GameAndScoreDetails sharedGameDataStore].debugEasiness = self.debugEasiness.text.floatValue;
        [GameAndScoreDetails sharedGameDataStore].yComputerStrike = self.yDebugValue.text.floatValue;
        [GameAndScoreDetails sharedGameDataStore].debugGravity = self.debugGravity.text.floatValue;
        [GameAndScoreDetails sharedGameDataStore].debugForce = self.debugForce.text.floatValue;
        [GameAndScoreDetails sharedGameDataStore].debugWaitTime = self.debugWaitTime.text.floatValue;
        [GameAndScoreDetails sharedGameDataStore].debug = self.debugModeSwitch.isOn;
        
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

#pragma mark - delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - debug menu

-(void)debugStuff
{
    
    self.yDebugValue = [[UITextField alloc] init];
    self.yDebugValue.placeholder = @"y hit value";
    
    self.debugEasiness = [[UITextField alloc] init];
    self.debugEasiness.placeholder = @"debug easiness";
    self.debugEasiness.text = @"2";
    
    self.debugForce = [[UITextField alloc] init];
    self.debugForce.placeholder = @"hit force";
    self.debugForce.text = @"90";
    
    self.debugGravity = [[UITextField alloc] init];
    self.debugGravity.placeholder = @"gravity";
    self.debugGravity.text = @"-2.5";
    
    self.debugWaitTime = [[UITextField alloc] init];
    self.debugWaitTime.placeholder = @"wait time";
    self.debugWaitTime.text = @"0.33";
    
    self.debugModeSwitch = [[UISwitch alloc] init];
    self.debugModeSwitch.on = YES;
    [self.view addSubview:self.debugModeSwitch];
    [self.debugModeSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.left.equalTo(self.view).offset(10);
    }];
    
    
    NSArray *debugThingArray = @[self.debugWaitTime, self.yDebugValue,self.debugEasiness,self.debugForce,self.debugGravity];
    
    __block bool firstOne = YES;
    UITextField *previousThing;
    for (UITextField *textField in debugThingArray) {
        
        CGFloat fontSizeThing = self.screenHeight / 20;
        textField.font = [UIFont fontWithName:@"Arial Hebrew" size:fontSizeThing];
        [self.view addSubview:textField];
        
        
        CGFloat grayNESS = 0.9;
        textField.backgroundColor = [[UIColor alloc] initWithRed:grayNESS green:grayNESS blue:grayNESS alpha:1];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.textAlignment = NSTextAlignmentCenter;
        //        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(fontSizeThing*1.25));
            make.width.equalTo(@90);
            make.left.equalTo(self.view).offset(10);
            if(firstOne)
            {
                make.top.equalTo(self.debugModeSwitch.mas_bottom).offset(10);
                firstOne = NO;
            } else
            {
                make.top.equalTo(previousThing.mas_bottom).offset(10);
            }
            
            
        }];
        
        previousThing = textField;
    }
    
    
    
}


@end

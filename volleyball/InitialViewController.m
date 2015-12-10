//
//  InitialViewController.m
//  volleyball
//
//  Created by JASON HARRIS on 11/4/15.
//  Copyright © 2015 Jason Harris. All rights reserved.
//

#import "InitialViewController.h"
#import "MultiplayerViewController.h"
#import "gameAndScoreDetails.h"
#import <Masonry.h>
#import "GameViewController.h"
#import "MultiplayerViewController.h"
#import "SettingsViewController.h"


@interface InitialViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *multiplayerClicked;
@property (weak, nonatomic) IBOutlet UISegmentedControl *hostSwitch;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (strong, nonatomic) UILabel *beachVolleyballLabel;
@property (nonatomic, strong) UIButton *singlePlayerButton;
@property (nonatomic, strong) UIButton *multiplayerButton;
@property (nonatomic, strong) UIButton *settingsButton;
@property (nonatomic, strong) UIButton *computerButton;
@property (nonatomic, strong) UIButton *aiOpponantButton;

@property (nonatomic, strong) UIImage *sliderOff;
@property (nonatomic, strong) UIImage *sliderOn;


@property (nonatomic, strong) UILabel *developedByJasonHarris;

//DEBUG ONES
@property (nonatomic, strong) UITextField *debugEasiness;
@property (nonatomic, strong) UITextField *yDebugValue;
@property (nonatomic, strong) UITextField *debugGravity;
@property (nonatomic, strong) UITextField *debugForce;
@property (nonatomic, strong) UITextField *debugWaitTime;
@property (nonatomic, strong) UISwitch *debugModeSwitch;

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setScreenHeightandWidth];
    // Do any additional setup after loading the view.
    UIImage *backgroundSlice = [UIImage imageNamed:@"background-slice_small_ocean&sand"];
    CGFloat sizeRatio = backgroundSlice.size.height / self.screenHeight;
    backgroundSlice = [UIImage imageWithCGImage:backgroundSlice.CGImage scale:sizeRatio orientation:backgroundSlice.imageOrientation];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundSlice];
    [self addTitle];
    [self addButtons];
    [self addDevelopedByJasonHarris];
    
    
    [self debugStuff];
}



-(void)setScreenHeightandWidth
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.screenWidth = MAX(screenSize.width, screenSize.height);
    self.screenHeight = MIN(screenSize.width, screenSize.height);
}

-(void)addTitle
{
    self.beachVolleyballLabel = [[UILabel alloc] init];
    
    self.beachVolleyballLabel.font = [UIFont fontWithName:@"SpinCycleOT" size:self.screenWidth / 12.0];
    self.beachVolleyballLabel.text = @"BEACH VOLLEYBALL";
    self.beachVolleyballLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:self.beachVolleyballLabel];
    
    [self.beachVolleyballLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-self.screenHeight/6);
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
        make.bottom.and.right.equalTo(self.view).offset(-10);
    }];
    
}


-(void)addButtons
{
    //SINGLE PLAYER BUTTON
    UIImage *singlePlayerImage = [UIImage imageNamed:@"beachvolleyball-playButton"];
    CGFloat buttonIndent = self.screenWidth / 4;
    CGFloat buttonOffsetDown = self.screenHeight / 8;
    CGFloat sizeRatio = singlePlayerImage.size.height / self.screenHeight * 4;
    
    singlePlayerImage = [UIImage imageWithCGImage:singlePlayerImage.CGImage scale:sizeRatio orientation:singlePlayerImage.imageOrientation];
    CGFloat imageSize = singlePlayerImage.size.width;
    self.singlePlayerButton = [[UIButton alloc] init];
    self.singlePlayerButton.accessibilityLabel = @"singlePlayer";
    [self.singlePlayerButton setImage:singlePlayerImage forState:UIControlStateNormal];
    
    [self.view addSubview:self.singlePlayerButton];
    
    [self.singlePlayerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(self.screenWidth*0.2 - imageSize/2);
        make.centerY.equalTo(self.view).offset(buttonOffsetDown);
    }];
    
    
    //COMPUTER OPPONENT
    UIImage *computerImage = [UIImage imageNamed:@"beachvolleyball-shakePhone"];
    computerImage = [UIImage imageWithCGImage:computerImage.CGImage
                                        scale:computerImage.size.height / self.screenHeight * 4
                                  orientation:computerImage.imageOrientation];
    
    self.aiOpponantButton = [[UIButton alloc] init];
    self.aiOpponantButton.accessibilityLabel = @"computerOpponant";
    [self.aiOpponantButton setImage:computerImage forState:UIControlStateNormal];
    
    [self.view addSubview:self.aiOpponantButton];
    
    [self.aiOpponantButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(self.screenWidth*0.4 - imageSize/2);
        make.centerY.equalTo(self.view).offset(buttonOffsetDown);
    }];
    
    
    //MULTIPLAYER BUTTON
    UIImage *multiPlayerImage = [UIImage imageNamed:@"beachvolleyball-multiplayerButton"];
    multiPlayerImage = [UIImage imageWithCGImage:multiPlayerImage.CGImage scale:sizeRatio orientation:multiPlayerImage.imageOrientation];
    self.multiplayerButton = [[UIButton alloc] init];
    self.multiplayerButton.accessibilityLabel = @"multiPlayer";
    [self.multiplayerButton setImage:multiPlayerImage forState:UIControlStateNormal];
    
    [self.view addSubview:self.multiplayerButton];

    [self.multiplayerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(self.screenWidth*0.6 - imageSize/2);
        make.centerY.equalTo(self.view).offset(buttonOffsetDown);
    }];
    
    //SETTINGS BUTTON
    UIImage *settingsImage = [UIImage imageNamed:@"beachvolleyball-settingsButton"];
    settingsImage = [UIImage imageWithCGImage:settingsImage.CGImage scale:sizeRatio orientation:settingsImage.imageOrientation];
    self.settingsButton = [[UIButton alloc] init];
    self.settingsButton.accessibilityLabel = @"settings";
    [self.settingsButton setImage:settingsImage forState:UIControlStateNormal];
    
    [self.view addSubview:self.settingsButton];
    
    [self.settingsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(self.screenWidth*0.8 - imageSize/2);
        make.centerY.equalTo(self.view).offset(buttonOffsetDown);
    }];
    
    
    
    //COMPUTER SLIDER BUTTON
    self.sliderOff = [UIImage imageNamed:@"beachvolleyball-sliderOff"];
    self.sliderOff = [UIImage imageWithCGImage:self.sliderOff.CGImage scale:sizeRatio/0.75 orientation:self.sliderOff.imageOrientation];
    self.sliderOn = [UIImage imageNamed:@"beachvolleyball-sliderOn"];
    self.sliderOn = [UIImage imageWithCGImage:self.sliderOn.CGImage scale:sizeRatio/0.75 orientation:self.sliderOff.imageOrientation];
    self.computerButton = [[UIButton alloc] init];
    self.computerButton.accessibilityLabel = @"easyMode";
    [self.computerButton setImage:self.sliderOn forState:UIControlStateNormal];
    
    
    [self.view addSubview:self.computerButton];
    
    [self.computerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.aiOpponantButton);
        make.centerY.equalTo(self.aiOpponantButton).offset(singlePlayerImage.size.height * 0.75);
    }];
    
    //LABEL - VS COMPUTER OPPONET
    UILabel *computerOpponent = [[UILabel alloc] init];
    computerOpponent.text = @"vs computer";
    computerOpponent.textColor = [UIColor whiteColor];
    computerOpponent.alpha = 0.95;
    computerOpponent.font = [UIFont fontWithName:@"SpinCycleOT" size:self.screenHeight / 15];
    [self.view addSubview:computerOpponent];
    
    [computerOpponent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.computerButton);
        make.top.equalTo(self.computerButton.mas_bottom).offset(10);
    }];
    
    
    
    
    
    NSArray *buttonArray = @[self.singlePlayerButton, self.multiplayerButton, self.settingsButton, self.computerButton,self.aiOpponantButton];
    for (UIButton *button in buttonArray) {
        [button addTarget:self
                   action:@selector(buttonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    }

}


-(void)buttonClicked:(UIButton *)sendingButton
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if([sendingButton isEqual:self.singlePlayerButton])
    {
        [GameAndScoreDetails sharedGameDataStore].computerPlayer = NO;
        GameViewController *newGame = [sb instantiateViewControllerWithIdentifier:@"GameViewController"];
        [self presentViewController:newGame animated:YES completion:^{
            //completion
        }];
        
    } else if ([sendingButton isEqual:self.multiplayerButton])
    {
        [[GameAndScoreDetails sharedGameDataStore] resetGame];
        [GameAndScoreDetails sharedGameDataStore].host = self.hostSwitch.selectedSegmentIndex;
        [GameAndScoreDetails sharedGameDataStore].debug = 0;
        [GameAndScoreDetails sharedGameDataStore].computerPlayer = NO;
        self.debugModeSwitch.on = NO;
        
        MultiplayerViewController *newMultiGame = [sb instantiateViewControllerWithIdentifier:@"MultiplayerViewController"];
        [self presentViewController:newMultiGame animated:YES completion:^{
            //completion
        }];
        
    } else if ([sendingButton isEqual:self.settingsButton])
    {
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        
        SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
        [self presentViewController:settingsVC animated:NO completion:^{
            //completion
        }];
    } else if ([sendingButton isEqual:self.computerButton])
    {
        if ([self.computerButton.accessibilityLabel isEqualToString:@"easyMode"])
        {
            self.computerButton.accessibilityLabel = @"hardMode";
            [self.computerButton setImage:self.sliderOff forState:UIControlStateNormal];
        } else
        {
            self.computerButton.accessibilityLabel = @"easyMode";
            [self.computerButton setImage:self.sliderOn forState:UIControlStateNormal];
        }
    } else if([sendingButton isEqual:self.aiOpponantButton])
    {
        [GameAndScoreDetails sharedGameDataStore].debugEasiness = self.debugEasiness.text.floatValue;
        [GameAndScoreDetails sharedGameDataStore].yComputerStrike = self.yDebugValue.text.floatValue;
        [GameAndScoreDetails sharedGameDataStore].debugGravity = self.debugGravity.text.floatValue;
        [GameAndScoreDetails sharedGameDataStore].debugForce = self.debugForce.text.floatValue;
        [GameAndScoreDetails sharedGameDataStore].debugWaitTime = self.debugWaitTime.text.floatValue;
        [GameAndScoreDetails sharedGameDataStore].debug = self.debugModeSwitch.isOn;
        [GameAndScoreDetails sharedGameDataStore].computerPlayer = YES;
        GameViewController *newGame = [sb instantiateViewControllerWithIdentifier:@"GameViewController"];
        [self presentViewController:newGame animated:YES completion:^{
            //completion
        }];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
        [textField resignFirstResponder];
    return YES;
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[GameAndScoreDetails sharedGameDataStore] resetGame];
    if ([sender isEqual:self.multiplayerClicked])
    {
        [GameAndScoreDetails sharedGameDataStore].host = self.hostSwitch.selectedSegmentIndex;
    }
}


#pragma mark - debug stuff

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
    self.debugWaitTime.text = @"0.35";
    
    
    
    NSArray *debugThingArray = @[self.debugWaitTime, self.yDebugValue,self.debugEasiness,self.debugForce,self.debugGravity];
    UIView *previousThing = self.singlePlayerButton;
    __block bool firstOne = YES;
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
            make.right.equalTo(self.singlePlayerButton.mas_left);
            if(firstOne)
            {
                make.bottom.equalTo(self.singlePlayerButton.mas_bottom).offset(-5);
                firstOne = NO;
            } else
            {
                make.bottom.equalTo(previousThing.mas_top).offset(-fontSizeThing);
            }
            
            
        }];
        
        previousThing = textField;
    }
    
    self.debugModeSwitch = [[UISwitch alloc] init];
    self.debugModeSwitch.on = YES;
    [self.view addSubview:self.debugModeSwitch];
    [self.debugModeSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.debugWaitTime.mas_bottom).offset(10);
        make.centerX.equalTo(self.debugWaitTime);
    }];
    
    
}

@end

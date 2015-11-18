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


@interface InitialViewController ()
@property (weak, nonatomic) IBOutlet UIButton *multiplayerClicked;
@property (weak, nonatomic) IBOutlet UISegmentedControl *hostSwitch;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (strong, nonatomic) UILabel *beachVolleyballLabel;
@property (nonatomic, strong) UIButton *singlePlayerButton;
@property (nonatomic, strong) UIButton *multiplayerButton;
@property (nonatomic, strong) UIButton *settingsButton;

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        //MAIN THREAD BLOCK
        
    }];
    [self setScreenHeightandWidth];
    // Do any additional setup after loading the view.
    UIImage *backgroundSlice = [UIImage imageNamed:@"background-slice_small_ocean&sand"];
    CGFloat sizeRatio = backgroundSlice.size.height / self.screenHeight;
    backgroundSlice = [UIImage imageWithCGImage:backgroundSlice.CGImage scale:sizeRatio orientation:backgroundSlice.imageOrientation];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundSlice];
    [self addTitle];
    [self addButtons];
    
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
    
    self.beachVolleyballLabel.font = [UIFont fontWithName:@"SpinCycleOT" size:self.screenWidth / 14.0];
    self.beachVolleyballLabel.text = @"BEACH VOLLEYBALL";
    self.beachVolleyballLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:self.beachVolleyballLabel];
    
    [self.beachVolleyballLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-self.screenHeight/6);
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
    self.singlePlayerButton = [[UIButton alloc] init];
    self.singlePlayerButton.accessibilityLabel = @"singlePlayer";
    [self.singlePlayerButton setImage:singlePlayerImage forState:UIControlStateNormal];
    
    [self.view addSubview:self.singlePlayerButton];
    
    [self.singlePlayerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(-buttonIndent);
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
        make.centerX.equalTo(self.view);
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
        make.centerX.equalTo(self.view).offset(buttonIndent);
        make.centerY.equalTo(self.view).offset(buttonOffsetDown);
    }];
    
    NSArray *buttonArray = @[self.singlePlayerButton, self.multiplayerButton, self.settingsButton];
    for (UIButton *button in buttonArray) {
        [button addTarget:self
                   action:@selector(buttonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    }
}


-(void)buttonClicked:(UIButton *)sendingButton
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if([sendingButton.accessibilityLabel isEqualToString:@"singlePlayer"])
    {
        
        GameViewController *newGame = [sb instantiateViewControllerWithIdentifier:@"GameViewController"];
        [self presentViewController:newGame animated:YES completion:^{
            //completion
        }];
        
    } else if ([sendingButton.accessibilityLabel isEqualToString:@"multiPlayer"])
    {
        [[GameAndScoreDetails sharedGameDataStore] resetGame];
        [GameAndScoreDetails sharedGameDataStore].host = self.hostSwitch.selectedSegmentIndex;
        
        MultiplayerViewController *newMultiGame = [sb instantiateViewControllerWithIdentifier:@"MultiplayerViewController"];
        [self presentViewController:newMultiGame animated:YES completion:^{
            //completion
        }];
        
    } else if ([sendingButton.accessibilityLabel isEqualToString:@"settings"])
    {
        
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[GameAndScoreDetails sharedGameDataStore] resetGame];
    if ([sender isEqual:self.multiplayerClicked])
    {
//        MultiplayerViewController *vc = [segue destinationViewController];
        [GameAndScoreDetails sharedGameDataStore].host = self.hostSwitch.selectedSegmentIndex;
    }

    
}

@end

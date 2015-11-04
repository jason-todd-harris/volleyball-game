//
//  GameViewController.h
//  volleyball
//

//  Copyright (c) 2015 Jason Harris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "PLPartyTime.h"


@protocol MultiplayerViewControllerDelegate

@required
-(void)dataWasReceived:(NSData *)data;


@end


@interface MultiplayerViewController : UIViewController <PLPartyTimeDelegate>

@property (nonatomic, strong) PLPartyTime *partyTime;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, weak) id<MultiplayerViewControllerDelegate> delegate;









@end



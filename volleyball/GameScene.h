//
//  GameScene.h
//  volleyball
//

//  Copyright (c) 2015 Jason Harris. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PLPartyTime.h"
#import "MultiplayerViewController.h"

@interface GameScene : SKScene
@property (nonatomic, strong) PLPartyTime *partyTime;
@property (nonatomic, strong) MultiplayerViewController *multiPlayerVC;



@end

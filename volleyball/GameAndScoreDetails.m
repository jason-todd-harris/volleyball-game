//
//  gameAndScoreDetails.m
//  volleyball
//
//  Created by JASON HARRIS on 11/4/15.
//  Copyright © 2015 Jason Harris. All rights reserved.
//

#import "GameAndScoreDetails.h"



@interface GameAndScoreDetails ()

@property (nonatomic, assign) NSUInteger leftPlayerScore;
@property (nonatomic, assign) NSUInteger rightPlayerScore;
@property (nonatomic, assign) ballServer theBallServer;

@end

@implementation GameAndScoreDetails


+ (instancetype)sharedGameDataStore {
    static GameAndScoreDetails *_sharedGameDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedGameDataStore = [[GameAndScoreDetails alloc] init];
    });
    
    return _sharedGameDataStore;
}

-(instancetype)init
{
    self = [self initWithLeftScore:0
                        rightScore:0
                    leftPlayerHits:0
                   rightPlayerHits:0
                      pointsPlayed:0];
    return self;
}


-(instancetype)initWithLeftScore:(NSUInteger)leftScore
                      rightScore:(NSUInteger)rightScore
                  leftPlayerHits:(NSUInteger)leftPlayerHits
                 rightPlayerHits:(NSUInteger)rightPlayerHits
                    pointsPlayed:(NSUInteger)pointsPlayed
{
    self = [super init];
    if (self) {
        _leftPlayerScore = 0;
        _rightPlayerScore = 0;
        _leftPlayerHits = 0;
        _rightPlayerHits = 0;
        _pointsPlayed = 0;
        _host = 2;
        _theBallServer = LeftPlayerServe;
    }
    return self;
}

-(void)resetGame
{
    self.leftPlayerScore = 0;
    self.rightPlayerScore = 0;
    self.leftPlayerHits = 0;
    self.rightPlayerHits = 0;
    self.pointsPlayed = 0;
    self.theBallServer = LeftPlayerServe;
    self.host = 2;
}


-(NSUInteger)leftPlayerHitTheBall
{
    self.rightPlayerHits = 0;
    self.leftPlayerHits ++;
    return self.leftPlayerHits;
}

-(NSUInteger)rightPlayerHitTheBall
{
    self.leftPlayerHits = 0;
    self.rightPlayerHits ++;
    return self.rightPlayerHits;
}

-(NSUInteger)leftPlayerScored
{
    self.leftPlayerScore ++;
    self.theBallServer = LeftPlayerServe;
    return self.leftPlayerScore;
}

-(NSUInteger)rightPlayerScored
{
    self.rightPlayerScore ++;
    self.theBallServer = RightPlayerServe;
    return self.rightPlayerScore;
}


@end

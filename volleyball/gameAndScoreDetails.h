//
//  GameAndScoreDetails.h
//  volleyball
//
//  Created by JASON HARRIS on 11/4/15.
//  Copyright © 2015 Jason Harris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameAndScoreDetails : NSObject

typedef NS_ENUM (NSUInteger, ballServer) {
    LeftPlayerServe = 0,
    RightPlayerServe = 1
} NS_ENUM_AVAILABLE (10_10, 7_0);


@property (nonatomic, assign) NSUInteger leftPlayerScore;
@property (nonatomic, assign) NSUInteger rightPlayerScore;
@property (nonatomic, assign) NSUInteger leftPlayerHits;
@property (nonatomic, assign) NSUInteger rightPlayerHits;
@property (nonatomic, assign) NSUInteger pointsPlayed;
@property (nonatomic, assign) NSUInteger host;
@property (nonatomic, assign) NSUInteger server;
@property (nonatomic, readonly) ballServer theBallServer;
@property (nonatomic, assign) bool computerPlayer;


// constants for who has the serve





+ (instancetype)sharedGameDataStore;

-(instancetype)init;

-(instancetype)initWithLeftScore:(NSUInteger)leftScore
                      rightScore:(NSUInteger)rightScore
                  leftPlayerHits:(NSUInteger)leftPlayerHits
                 rightPlayerHits:(NSUInteger)rightPlayerHits
                    pointsPlayed:(NSUInteger)pointsPlayed;

-(void)resetGame;

-(NSUInteger)leftPlayerHitTheBall;

-(NSUInteger)rightPlayerHitTheBall;

-(NSUInteger)leftPlayerScored;

-(NSUInteger)rightPlayerScored;





@end

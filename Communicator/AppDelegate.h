//
//  AppDelegate.h
//  Communicator
//
//  Created by mac on 19/03/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    AVAudioPlayer* audioPlayer;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) UIView *notifView;
@property(nonatomic,strong)NSDictionary *feedcomCommunicationCounterValue;
@property(nonatomic)BOOL tappedOnNotification;
@end


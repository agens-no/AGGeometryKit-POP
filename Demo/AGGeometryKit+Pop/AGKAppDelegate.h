//
//  AGKAppDelegate.h
//  AGGeometryKit+Pop
//
//  Created by Håvard Fossli on 08.05.14.
//  Copyright (c) 2014 Agens AS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGKAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UITabBarController *tabBarController;

@end

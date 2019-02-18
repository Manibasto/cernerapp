//
//  ViewController.h
//  SampleObjc
//
//  Created by Anilkumar on 31/01/19.
//  Copyright © 2019 Anilkumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
-(void)getAccessToken:(NSString*)clientKey Code:(NSString*)code;
-(void)showAlert:(NSString*)Message;
@end

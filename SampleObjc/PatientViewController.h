//
//  PatientViewController.h
//  SampleObjc
//
//  Created by Anilkumar on 07/02/19.
//  Copyright © 2019 Anilkumar. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PatientViewController : UIViewController
-(void)getPatientDetails:(NSString*)strtoken;
@property (weak,nonatomic) NSString *strAccessToken;
@end

NS_ASSUME_NONNULL_END

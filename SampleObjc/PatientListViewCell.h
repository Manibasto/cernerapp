//
//  PatientListViewCell.h
//  SampleObjc
//
//  Created by Anilkumar on 07/02/19.
//  Copyright © 2019 Anilkumar. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PatientListViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *otPatientGender;
@property (weak, nonatomic) IBOutlet UILabel *otPatientName;
@property (weak, nonatomic) IBOutlet UILabel *otPatientAge;

@end

NS_ASSUME_NONNULL_END

//
//  PatientDetailsTableViewCell.h
//  SampleObjc
//
//  Created by Anilkumar on 07/02/19.
//  Copyright © 2019 Anilkumar. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PatientDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *otDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *otResultLabel;

@end

NS_ASSUME_NONNULL_END

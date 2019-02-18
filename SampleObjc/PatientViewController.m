//
//  PatientViewController.m
//  SampleObjc
//
//  Created by Anilkumar on 07/02/19.
//  Copyright © 2019 Anilkumar. All rights reserved.
//

#import "PatientViewController.h"
#import "PatientListViewCell.h"
#import "DetailsViewController.h"

@interface PatientViewController ()<UIPopoverPresentationControllerDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSArray* patientResource;
    NSMutableArray* patientID;
    NSNumber* patientCount;
   
    __weak IBOutlet UITableView *patientListTableView;
}
@end

@implementation PatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    patientID = [[NSMutableArray alloc] init];
    NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"token"];
    [self getPatientDetails:str];
    // Do any additional setup after loading the view.
}


//Function
-(void)getPatientDetails:(NSString*)strtoken{
    NSString* urlString = [NSString stringWithFormat:@"http://aitechdemos.com/sites/sampleapp/webservice/getpatientlist.php?accesstoken=%@",strtoken];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse* response, NSError *error) {
        //NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSLog(@"%@",[jsonDict objectForKey:@"success"]);
        BOOL success = [jsonDict objectForKey:@"success"];
        if(jsonDict!=nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                self->patientResource = [jsonDict objectForKey:@"entry"];
                self->patientCount = [NSNumber numberWithUnsignedInteger:self->patientResource.count];
                [self->patientListTableView reloadData];
                [self->patientListTableView layoutIfNeeded];
            });
        }
        else{
            NSString *msg = @"Invalid Data";
            [self showAlert:msg Mode:@"Error"];
        }
    }] resume];
};
//Tableview:
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return patientResource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"patient";
    PatientListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *patientDic = [patientResource[indexPath.row] objectForKey:@"resource"];
    NSString *patientId = [patientDic objectForKey:@"id"];
    [patientID insertObject:patientId atIndex:indexPath.row];
    NSDate *patientDOB = [patientDic objectForKey:@"birthDate"];
    NSString *dateStr = patientDOB;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]components:NSCalendarUnitYear fromDate:date toDate:now options:0];
    NSInteger age = [ageComponents year];
    NSString* patientAge = [NSString stringWithFormat:@"%li", (long)age];
    NSString *patientGender = [patientDic objectForKey:@"gender"];
    NSArray *patientNameArray = [patientDic objectForKey:@"name"];
    NSArray *PatientFirstName = [patientNameArray[0] objectForKey:@"family"];
    NSArray *PatientLastName = [patientNameArray[0] objectForKey:@"given"];
    NSString *patientName = [NSString stringWithFormat:@"%@ %@", PatientFirstName[0], PatientLastName[0]];
    cell.otPatientName.text = patientName;
    cell.otPatientAge.text = patientAge;
    if([patientGender isEqualToString:@"male"]){
        cell.otPatientGender.text = @"M";
    }else{
        cell.otPatientGender.text = @"F";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSUserDefaults standardUserDefaults]setValue:patientID[indexPath.row] forKey:@"patientID"];
        DetailsViewController *popup = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
        popup.preferredContentSize = CGSizeMake(300, 300);
        popup.modalPresentationStyle = UIModalPresentationPopover;
        popup.popoverPresentationController.delegate = self;
        popup.popoverPresentationController.sourceView = self.view;
        popup.popoverPresentationController.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds), 0, 0);
        popup.popoverPresentationController.backgroundColor = UIColor.clearColor;
        [self presentViewController:popup animated:NO completion:nil];
    });
}
- (IBAction)tapBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showAlert:(NSString*)Message Mode:(NSString*)strmode{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:strmode message:Message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:OK];
        [self presentViewController:alert animated:YES completion:nil];
    });
}
@end

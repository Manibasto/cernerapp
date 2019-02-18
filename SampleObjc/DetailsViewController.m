//
//  DetailsViewController.m
//  SampleObjc
//
//  Created by Anilkumar on 07/02/19.
//  Copyright © 2019 Anilkumar. All rights reserved.
//

#import "DetailsViewController.h"
#import "PatientDetailsTableViewCell.h"
@interface DetailsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *DetailsLabel;
    NSMutableArray *ResultLabel;
}
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DetailsLabel = [[NSMutableArray alloc] init];
    ResultLabel = [[NSMutableArray alloc] init];
    NSString * patientID = [[NSUserDefaults standardUserDefaults]valueForKey:@"patientID"];
    NSString * Token = [[NSUserDefaults standardUserDefaults]valueForKey:@"token"];
    [self getParticularPatientDetails:patientID Code:Token];
    // Do any additional setup after loading the view.
}

-(void)getParticularPatientDetails:(NSString*)strPatientID Code:(NSString*)strToken{
        NSString* urlString = [NSString stringWithFormat:@"http://aitechdemos.com/sites/sampleapp/webservice/getpatientbyid.php?patientid=%@&accesstoken=%@",strPatientID,strToken];
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
                    NSString *strResourceType = [jsonDict objectForKey:@"resourceType"];
                    [self->DetailsLabel insertObject:@"ResourceType" atIndex:0];
                    [self->ResultLabel insertObject:strResourceType atIndex:0];
                    NSString *strpatientID = [jsonDict objectForKey:@"id"];
                    [self->DetailsLabel insertObject:@"PatientId" atIndex:1];
                    [self->ResultLabel insertObject:strpatientID atIndex:1];
                    NSArray *strNameArray = [jsonDict objectForKey:@"name"];
                    NSArray *PatientFirstName = [strNameArray[0] objectForKey:@"family"];
                    NSArray *PatientLastName = [strNameArray[0] objectForKey:@"given"];
                    NSString *patientName = [NSString stringWithFormat:@"%@ %@", PatientFirstName[0], PatientLastName[0]];
                    [self->DetailsLabel insertObject:@"Name" atIndex:2];
                    [self->ResultLabel insertObject:patientName atIndex:2];
                    NSString *strGender = [jsonDict objectForKey:@"gender"];
                    [self->DetailsLabel insertObject:@"Gender" atIndex:3];
                    [self->ResultLabel insertObject:strGender atIndex:3];
                    NSString *strDob = [jsonDict objectForKey:@"birthDate"];
                    [self->DetailsLabel insertObject:@"Date_Of_Birth" atIndex:4];
                    [self->ResultLabel insertObject:strDob atIndex:4];
                    NSArray *strEmailArray = [jsonDict objectForKey:@"telecom"];
                    if(strEmailArray.count !=0){
                        NSString *strEmail = [strEmailArray[0] objectForKey:@"value"];
                        [self->DetailsLabel insertObject:@"Contact" atIndex:5];
                        [self->ResultLabel insertObject:strEmail atIndex:5];
                    }
                    else{
                        [self->DetailsLabel insertObject:@"Contact" atIndex:5];
                        [self->ResultLabel insertObject:@"" atIndex:5];
                    }
                    [self->_detailsTableView reloadData];
                    [self->_detailsTableView layoutIfNeeded];
                    
                });
            }
            else{
                NSString *msg = @"Invalid";
                [self showAlert:msg Mode:@"Error"];
            }
        }] resume];
}
//Tableview:
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return DetailsLabel.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"details";
    PatientDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.otDetailsLabel.text = self->DetailsLabel[indexPath.row];
    cell.otResultLabel.text = self->ResultLabel[indexPath.row];
    return cell;
}
- (IBAction)tapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)showAlert:(NSString*)Message Mode:(NSString*)strmode{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:strmode message:Message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:OK];
        [self presentViewController:alert animated:YES completion:nil];
    });
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

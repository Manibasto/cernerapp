//
//  ViewController.m
//  SampleObjc
//
//  Created by Anilkumar on 31/01/19.
//  Copyright © 2019 Anilkumar. All rights reserved.
//

#import "ViewController.h"
#import "PatientViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *client_id_text;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (IBAction)tapLogin:(UIButton *)sender {
    NSString* client_ID = _client_id_text.text;
    NSString* urlString = [NSString stringWithFormat:@"http://aitechdemos.com/sites/sampleapp/webservice/getcode.php?client_id=%@",client_ID];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse* response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSLog(@"%@",[jsonDict objectForKey:@"success"]);
        BOOL success = [jsonDict objectForKey:@"success"];
        if(success){
            NSString* client_id = [jsonDict objectForKey:@"clientid"];
            NSString* code = [jsonDict objectForKey:@"code"];
            [self getAccessToken:client_id Code:code];
        }
        else{
            NSString *msg = @"Invalid ClientID";
            [self showAlert:msg Mode:@"Error"];
        }
    }] resume];
}

-(void)getAccessToken:(NSString*)clientKey Code:(NSString*)code{
    NSError *err;
    NSString* urlString = [NSString stringWithFormat:@"http://aitechdemos.com/sites/sampleapp/webservice/getaccessToken.php?client_id=%@&code=%@",clientKey,code];
    NSString *jsonUrlString = [NSString stringWithString:urlString];
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *req=[NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&err];
    NSDictionary *json=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (json == nil){
        NSString * msg = @"Invalid token";
        [self showAlert:msg Mode:@"Error"];
    }
    else{
        NSString* token = [json objectForKey:@"access_token"];
        dispatch_async(dispatch_get_main_queue(), ^{
            PatientViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PatientViewController"];
            [[NSUserDefaults standardUserDefaults]setValue:token forKey:@"token"];
            [self.navigationController pushViewController:vc animated:YES];
        });
    }
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


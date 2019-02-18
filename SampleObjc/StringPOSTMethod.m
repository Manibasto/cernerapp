//
//  StringPOSTMethod.m
//  APISample
//
//  Created by Nandakumar Somasundaram on 02/03/16.
//  Copyright © 2016 Periyasamy R. All rights reserved.
//

#import "StringPOSTMethod.h"

@implementation StringPOSTMethod

+ (void)sendGetMethod:(NSString *)url key:(NSString *)key withCompletionHandler:(completionBlock)handler {
    NSLog(@"url %@",url);
    NSLog(@"-------> key %@",key);
    
    NSString* encodedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodedUrl]];
    
    NSURLSessionTask *getMethodtask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"sendGetMethod - sendAsynchronousRequest - Completion Block");
            if (error)
            {
                //[k_AppDelegate showAlertwithTitle:LocalizedString(@"Sorry!") message:error.localizedDescription buttonTitle1:LocalizedString(@"OK") buttonTitle2:@""];
            }
            else if (data == nil)
            {
                // [k_AppDelegate showAlertwithTitle:LocalizedString(@"Error!") message:LocalizedString(@"The specified server could not be found.") buttonTitle1:LocalizedString(@"OK") buttonTitle2:@""];
            }
            else
            {
                NSDictionary *encodeDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                
                if (![encodeDictionary isEqual:[NSNull null]] && encodeDictionary != nil)
                {
                    if(handler)
                    {
                        handler(encodeDictionary, nil);
                    }
                    else if([[encodeDictionary objectForKey:@"status"] integerValue] != 1)
                    {
                        //[k_AppDelegate showAlertwithTitle:LocalizedString(@"AlertTitle") message:[encodeDictionary objectForKey:@"message"] buttonTitle1:LocalizedString(@"OK") buttonTitle2:@""];
                    }
                }
                else
                {
                    //[k_AppDelegate showAlertwithTitle:LocalizedString(@"Error!") message:LocalizedString(@"The specified server could not be found.") buttonTitle1:LocalizedString(@"OK") buttonTitle2:@""];
                }
            }
        });
    }];
    [getMethodtask resume];
}

+ (void)downloadDataFromServer:(NSString *)baseURL bodyData:(NSDictionary *)body method:(NSString *)methodName postString:(NSString *)string withCompletionHandler:(completionBlock)handler;
{
    NSString *getFullServer = [NSString stringWithFormat:@"%@",baseURL];
    //Pass the parameters and Set the URL
    NSURL *urlString = [NSURL URLWithString:getFullServer];
    NSString *post = [NSString stringWithFormat:@"%@",string];
    // Convert NSString to NSData format
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    // Create the URL Request and set the neccesary parameters
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlString];
    [request setHTTPMethod:methodName];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error)
            {
                
            } else if (data == nil)
            {
                
            } else {
                
                NSDictionary *encodeDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                
                if (![encodeDictionary isEqual:[NSNull null]] && encodeDictionary != nil) {
                    if(handler)
                    {
                        handler(encodeDictionary, nil);
                    }
                    else if ([[encodeDictionary objectForKey:@"status"] integerValue] != 1)
                    {
                    }
                }
                else
                {
                    
                }
                
            }
        });
    }];
    [downloadTask resume];
}
@end

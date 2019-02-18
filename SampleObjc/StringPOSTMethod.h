//
//  StringPOSTMethod.h
//  APISample
//
//  Created by Nandakumar Somasundaram on 02/03/16.
//  Copyright © 2016 Periyasamy R. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completionBlock)(NSDictionary *resultDictionary, NSError *error);
@interface StringPOSTMethod : NSObject
+ (void)sendGetMethod:(NSString *)url key:(NSString *)key withCompletionHandler:(completionBlock)handler;
+ (void)downloadDataFromServer:(NSString *)baseURL bodyData:(NSDictionary *)body method:(NSString *)methodName postString:(NSString *)string withCompletionHandler:(completionBlock)handler;
@end

//
//  WebServiceBase.h
//  APICenter
//
//  Created by 刘少昌 on 2018/6/11.
//  Copyright © 2018年 刘少昌. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RequestMethod) {
    GET,
    POST,
    PUT
};

@interface WebServiceBase : NSObject

@property (nonatomic,copy) NSString *baseUrl;

+ (instancetype)sharedInstance;

- (void)requestWithMehod:(RequestMethod)method urlPath:(NSString *)urlPath parameters:(id)parameters finished:(void(^)(id responseObject, NSError *error))finished;

@end

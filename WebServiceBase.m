//
//  WebServiceBase.m
//  APICenter
//
//  Created by 刘少昌 on 2018/6/11.
//  Copyright © 2018年 刘少昌. All rights reserved.
//

// 该类中不做任何解析处理

#import "WebServiceBase.h"
#import "AFNetworking.h"

@interface WebServiceBase ()

@property (nonatomic,strong) AFHTTPSessionManager *manager;

@end

@implementation WebServiceBase

+ (instancetype)sharedInstance {
    
    static WebServiceBase *serviceBase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceBase = [[WebServiceBase alloc] init];
    });
    return serviceBase;
}

- (void)requestWithMehod:(RequestMethod)method urlPath:(NSString *)urlPath parameters:(id)parameters finished:(void(^)(id responseObject, NSError *error))finished {
    switch (method) {
            case GET:
                [self GET:urlPath parameters:parameters finished:finished];
            break;
            case POST:
                [self POST:urlPath parameters:parameters finished:finished];
            break;
            case PUT:
                [self PUT:urlPath parameters:parameters finished:finished];
            break;
        default:
            break;
    }
}

#pragma mark - 请求

- (NSString *)absoluteURLString:(NSString *)URLPathString {
    return [self.baseUrl stringByAppendingString:URLPathString];
}

- (void)GET:(NSString *)URLPathString
 parameters:(id)parameters
    finished:(void(^)(id responseObject, NSError *error))finished {
    
    [self.manager GET:[self absoluteURLString:URLPathString] parameters:parameters progress:^(NSProgress *  downloadProgress) {
    } success:^(NSURLSessionDataTask *task, id   responseObject) {
        finished(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finished(nil, error);
    }];
    
}

- (void)POST:(NSString *)URLPathString
  parameters:(id)parameters
     finished:(void(^)(id responseObject, NSError *error))finished {
    
    [self.manager POST:[self absoluteURLString:URLPathString] parameters:parameters progress:^(NSProgress *  downloadProgress) {
    } success:^(NSURLSessionDataTask *task, id   responseObject) {
        finished(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finished(nil, error);
    }];
}

- (void)PUT:(NSString *)URLPathString
 parameters:(id)parameters
    finished:(void(^)(id responseObject, NSError *error))finished {
    [self.manager PUT:[self absoluteURLString:URLPathString] parameters:parameters success:^(NSURLSessionDataTask *task, id   responseObject) {
        finished(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finished(nil, error);
    }];
}


#pragma mark - Getter
- (AFHTTPSessionManager *)manager {
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html", @"text/plain", @"text/json", @"text/javascript", @"application/json"]];
        _manager.requestSerializer.timeoutInterval = 15;
    }
    return _manager;
}

@end

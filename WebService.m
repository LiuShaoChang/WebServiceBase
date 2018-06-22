//
//  WebService.m
//  APICenter
//
//  Created by 刘少昌 on 2018/6/11.
//  Copyright © 2018年 刘少昌. All rights reserved.
//

// 在该基类中做解析处理，错误处理等，下面的常量可以抽离出去，统一定义，此处只是示范

#import "WebService.h"

static NSString *const kBaseUrl = @"https://example.net";
static NSString *const kNotificationSessionExpired = @"example";
static NSInteger const kWebApiErrorSessionExpired = 9099;
static NSInteger const kCodeSessionExpired = 99;
static NSInteger const kCodeNotLoggedIn = 302;
static NSInteger const kCodeSuccess = 0;

@implementation WebService

- (void)GET:(NSString *)URLPathString parameters:(id)parameters finished:(void(^)(id responseObject, NSError *error))finished {
    [self requestWithMethod:GET urlPath:URLPathString parameters:parameters finished:finished];
}

- (void)POST:(NSString *)URLPathString parameters:(id)parameters finished:(void(^)(id responseObject, NSError *error))finished {
    [self requestWithMethod:POST urlPath:URLPathString parameters:parameters finished:finished];
}

- (void)PUT:(NSString *)URLPathString parameters:(id)parameters finished:(void(^)(id responseObject, NSError *error))finished {
    [self requestWithMethod:PUT urlPath:URLPathString parameters:parameters finished:finished];
}

- (void)requestWithMethod:(RequestMethod)method urlPath:(NSString *)path parameters:(id)parameters finished:(void(^)(id responseObject, NSError *error))finished {
    
    [WebServiceBase sharedInstance].baseUrl = kBaseUrl;
    [[WebServiceBase sharedInstance] requestWithMehod:method urlPath:path parameters:parameters finished:^(id responseObject, NSError *error) {
        if (error) {
            finished(nil,error);
        }else {
            NSError *error = [self getServiceErrorFromResponse:responseObject];
            if (error) {
                finished(nil,error);
            }else {
                finished(responseObject,nil);
            }
        }
    }];
    
}

#pragma mark - 解析
- (NSInteger)getReturnCodeFromResponse:(id)responseObject {
    NSNumber *returnCode = [self getObjectFromResponse:responseObject key:@"retcode"];
    if (returnCode != nil && ([returnCode isKindOfClass:[NSNumber class]] || [returnCode isKindOfClass:[NSString class]])) {
        NSInteger code = [returnCode integerValue];
        if (code == kCodeSessionExpired || code == kCodeNotLoggedIn) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSessionExpired object:nil];
        }
        return code;
    }
    return NSNotFound;
}

- (NSString *)getReturnMessageFromResponse:(id)responseObject {
    NSString *message = [self getObjectFromResponse:responseObject key:@"msg"];
    if (message != nil) {
        return message;
    }
    else{
        return [self getObjectFromResponse:responseObject key:@"reason"];
    }
}

- (NSDictionary *)getDictionaryFromResponse:(id)responseObject {
    if (responseObject != nil && [responseObject isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)responseObject;
    }
    return nil;
}

- (NSDictionary *)getDictionaryFromResponse:(id)responseObject key:(NSString *)key {
    NSDictionary *dictionary = [self getDictionaryFromResponse:responseObject];
    if (dictionary != nil){
        if (![[dictionary objectForKey:key] isKindOfClass:[NSNull class]]) {
            return [dictionary objectForKey:key];
        }
    }
    return nil;
}

- (NSArray *)getArrayFromResponse:(id)responseObject {
    if (responseObject != nil && [responseObject isKindOfClass:[NSArray class]]) {
        return (NSArray *)responseObject;
    }
    return nil;
}

- (NSArray *)getArrayFromResponse:(id)responseObject key:(NSString *)key {
    NSDictionary *dictionary = [self getDictionaryFromResponse:responseObject];
    if (dictionary != nil){
        NSArray *array = [dictionary objectForKey:key];
        if (array != nil && [array isKindOfClass:[NSArray class]]) {
            return array;
        }
    }
    return nil;
}

- (id)getObjectFromResponse:(id)responseObject key:(NSString *)key {
    NSDictionary *dictionary = [self getDictionaryFromResponse:responseObject];
    if (dictionary != nil && [dictionary isKindOfClass:[NSDictionary class]]){
        return [dictionary objectForKey:key];
    }
    return nil;
}

#pragma mark - 错误处理
- (NSError *)getServiceErrorFromResponse:(id)responseObject {
    NSInteger returnCode = [self getReturnCodeFromResponse:responseObject];
    if (returnCode == kCodeSuccess || returnCode == NSNotFound) {
        return nil;
    }
    else {
        NSString *returnMessage = [self getReturnMessageFromResponse:responseObject];
        if (returnMessage != nil) {
            return [NSError errorWithDomain:kBaseUrl code:returnCode userInfo:@{NSLocalizedDescriptionKey:returnMessage}];
        }
        else{
            return [self getParsingError];
        }
    }
}

- (NSError *)getParsingError {
    return [NSError errorWithDomain:kBaseUrl code:NSURLErrorCannotParseResponse userInfo:@{NSLocalizedDescriptionKey:@"数据无法解析"}];
}

- (NSError *)getSessionExpiredError {
    return [NSError errorWithDomain:kBaseUrl code:kWebApiErrorSessionExpired userInfo:@{NSLocalizedDescriptionKey:@"需要重新登录"}];
}




@end

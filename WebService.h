//
//  WebService.h
//  APICenter
//
//  Created by 刘少昌 on 2018/6/11.
//  Copyright © 2018年 刘少昌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceBase.h"

@interface WebService : NSObject


- (void)GET:(NSString *)URLPathString parameters:(id)parameters finished:(void(^)(id responseObject, NSError *error))finished;
- (void)POST:(NSString *)URLPathString parameters:(id)parameters finished:(void(^)(id responseObject, NSError *error))finished;
- (void)PUT:(NSString *)URLPathString parameters:(id)parameters finished:(void(^)(id responseObject, NSError *error))finished;

#pragma mark - 解析
- (NSInteger)getReturnCodeFromResponse:(id _Nullable)responseObject;
- (NSString *_Nullable)getReturnMessageFromResponse:(id _Nullable)responseObject;
- (NSDictionary *_Nullable)getDictionaryFromResponse:(id _Nullable)responseObject; //一般用于取Json顶级字典
- (NSDictionary *_Nullable)getDictionaryFromResponse:(id _Nullable)responseObject key:(NSString * )key; //一般用于取Json第二级的字典
- (NSArray *_Nullable)getArrayFromResponse:(id _Nullable)responseObject; //一般用于取Json顶级数组
- (NSArray *_Nullable)getArrayFromResponse:(id _Nullable)responseObject key:(NSString * )key; //一般用于取Json第二级数组
- (id _Nullable)getObjectFromResponse:(id _Nullable)responseObject key:(NSString * )key; //一般用于取Json顶级字段


#pragma mark - 错误处理
- (NSError * _Nullable)getServiceErrorFromResponse:(id _Nullable)responseObject;
- (NSError *)getParsingError;
- (NSError *)getSessionExpiredError;


@end

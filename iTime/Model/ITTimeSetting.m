//
//  ITTimeSetting.m
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/5.
//

#import "ITTimeSetting.h"

@implementation ITTimeSetting

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _tid = [dict[@"id"] integerValue];
        _title = dict[@"title"];
        _style= [dict[@"style"] integerValue];
        _value = [dict[@"value"] integerValue];
    }
    return self;
}

- (NSDictionary *)toDict {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"id"] = @(self.tid);
    dict[@"title"] = self.title;
    dict[@"style"] = @(self.style);
    dict[@"value"] = @(self.value);
    return dict;

}

+ (NSArray *)defaultSettings {
    return @[@{@"id":@1,@"title":@"秒级校准(s)",@"style":@2,@"value":@1},
             @{@"id":@2,@"title":@"毫秒级校准(ms)",@"style":@2,@"value":@100},
             @{@"id":@3,@"title":@"显示毫秒",@"style":@1,@"value":@1},
             @{@"id":@4,@"title":@"毫秒显红",@"style":@1,@"value":@0},
             @{@"id":@5,@"title":@"倒计时模式",@"style":@1,@"value":@0},
             @{@"id":@6,@"title":@"倒计时音效",@"style":@0,@"value":@0},
             @{@"id":@7,@"title":@"画中画更换样式",@"style":@0,@"value":@1},
    ];
}

+ (NSArray *)defaultSoundSettings {
    return @[@{@"id":@1,@"title":@"最后三秒报数",@"style":@1,@"value":@0},
             @{@"id":@2,@"title":@"准点声音提示",@"style":@1,@"value":@0}];
}

@end

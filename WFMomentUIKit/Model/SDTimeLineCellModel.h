//
//  SDTimeLineCellModel.h
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 459274049
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import <Foundation/Foundation.h>
#import <WFMomentClient/WFMomentClient.h>

@class SDTimeLineCellLikeItemModel, SDTimeLineCellCommentItemModel;

@interface SDTimeLineCellModel : NSObject

@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *msgContent;
@property (nonatomic, strong) NSArray *picNamesArray;

@property (nonatomic, assign, getter = isLiked) BOOL liked;

@property (nonatomic, strong) NSArray<SDTimeLineCellLikeItemModel *> *likeItemsArray;
@property (nonatomic, strong) NSArray<SDTimeLineCellCommentItemModel *> *commentItemsArray;

@property (nonatomic, assign) BOOL isOpening;

@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;

@property(nonatomic, strong) WFMFeed *feed;
@end


@interface SDTimeLineCellLikeItemModel : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSAttributedString *attributedContent;
@property (nonatomic, strong) WFMComment *comment;
@end


@interface SDTimeLineCellCommentItemModel : NSObject

@property (nonatomic, copy) NSString *commentString;

@property (nonatomic, copy) NSString *firstUserName;
@property (nonatomic, copy) NSString *firstUserId;

@property (nonatomic, copy) NSString *secondUserName;
@property (nonatomic, copy) NSString *secondUserId;

@property (nonatomic, copy) NSAttributedString *attributedContent;
@property (nonatomic, strong) WFMComment *comment;

@end

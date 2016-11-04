//
//  WHCWeiboModel.m
//  ModelBenchmark
//
//  Created by WHC on 16/11/3.
//  Copyright © 2016年 ibireme. All rights reserved.
//

#import "WHCWeiboModel.h"
#import "NSObject+WHC_Model.h"
//
//  WHCWeiboModel.m
//  ModelBenchmark
//
//  Created by ibireme on 15/9/18.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "WHCWeiboModel.h"
#import "DateFormatter.h"

@implementation WHCWeiboPictureMetadata
WHC_CodingImplementation
+ (NSDictionary <NSString * , NSString *>*)whc_ModelReplacePropertyMapper {
    return @{@"cut_type": @"cutType"};
}

@end

@implementation WHCWeiboPicture
WHC_CodingImplementation
+ (NSDictionary <NSString *, Class>*)whc_ModelReplacePropertyClassMapper {
    return @{@"thumbnail": [WHCWeiboPictureMetadata class],
             @"bmiddle": [WHCWeiboPictureMetadata class],
             @"middlePlus": [WHCWeiboPictureMetadata class],
             @"large": [WHCWeiboPictureMetadata class],
             @"original": [WHCWeiboPictureMetadata class],
             @"largest": [WHCWeiboPictureMetadata class]};
}

+ (NSDictionary <NSString * , NSString *> *)whc_ModelReplacePropertyMapper {
    return @{
             @"pic_id" : @"picID",
             @"keep_size" : @"keepSize",
             @"photo_tag" : @"photoTag",
             @"object_id" : @"objectID",
             @"middleplus" : @"middlePlus"
             };
}

@end

@implementation WHCWeiboURL
WHC_CodingImplementation
+ (NSDictionary <NSString * , NSString *>*)whc_ModelReplacePropertyMapper {
    return @{
             @"ori_url" : @"oriURL",
             @"url_title" : @"urlTitle",
             @"url_type_pic" : @"urlTypePic",
             @"url_type" : @"urlType",
             @"short_url" : @"shortURL",
             @"actionlog" : @"actionLog",
             @"page_id" : @"pageID",
             @"storage_type" : @"storageType"
             };
}

@end

@implementation WHCWeiboUser
WHC_CodingImplementation
+ (NSDictionary <NSString * , NSString *>*)whc_ModelReplacePropertyMapper {
    return @{
             @"id" : @"userID",
             @"idstr" : @"idString",
             @"gender" : @"genderString",
             @"bi_followers_count" : @"biFollowersCount",
             @"profile_image_url" : @"profileImageURL",
             @"class" : @"uclass",
             @"verified_contact_email" : @"verifiedContactEmail",
             @"statuses_count" : @"statusesCount",
             @"geo_enabled" : @"geoEnabled",
             @"follow_me" : @"followMe",
             @"cover_image_phone" : @"coverImagePhone",
             @"description" : @"desc",
             @"followers_count" : @"followersCount",
             @"verified_contact_mobile" : @"verifiedContactMobile",
             @"avatar_large" : @"avatarLarge",
             @"verified_trade" : @"verifiedTrade",
             @"profile_url" : @"profileURL",
             @"cover_image" : @"coverImage",
             @"online_status"  : @"onlineStatus",
             @"badge_top" : @"badgeTop",
             @"verified_contact_name" : @"verifiedContactName",
             @"screen_name" : @"screenName",
             @"verified_source_url" : @"verifiedSourceURL",
             @"pagefriends_count" : @"pagefriendsCount",
             @"vverified_reason" : @"erifiedReason",
             @"friends_count" : @"friendsCount",
             @"block_app" : @"blockApp",
             @"has_ability_tag" : @"hasAbilityTag",
             @"avatar_hd" : @"avatarHD",
             @"credit_score" : @"creditScore",
             @"created_at" : @"createdAt",
             @"block_word" : @"blockWord",
             @"allow_all_act_msg" : @"allowAllActMsg",
             @"verified_state" : @"verifiedState",
             @"verified_reason_modified" : @"verifiedReasonModified",
             @"allow_all_comment" : @"allowAllComment",
             @"verified_level" : @"verifiedLevel",
             @"verified_reason_url" : @"verifiedReasonURL",
             @"favourites_count" : @"favouritesCount",
             @"verified_type" : @"verifiedType",
             @"verified_source" : @"verifiedSource",
             @"user_ability" : @"userAbility"};
}

@end

@implementation WHCWeiboStatus

WHC_CodingImplementation

+ (NSDictionary <NSString *, Class>*)whc_ModelReplacePropertyClassMapper {
    return @{@"user": [WHCWeiboUser class]};
}
+ (NSDictionary <NSString *, NSString*>*)whc_ModelReplacePropertyMapper {
    return @{
             @"id" : @"statusID",
             @"created_at" : @"createdAt",
             @"attitudes_status" : @"attitudesStatus",
             @"in_reply_to_screen_name" : @"inReplyToScreenName",
             @"source_type" : @"sourceType",
             @"comments_count" : @"commentsCount",
             @"recom_state" : @"recomState",
             @"source_allowclick" : @"sourceAllowClick",
             @"biz_feature" : @"bizFeature",
             @"mblogtypename" : @"mblogTypeName",
             @"url_struct" : @"urlStruct",
             @"mblogtype" : @"mblogType",
             @"in_reply_to_status_id" : @"inReplyToStatusId",
             @"pic_ids" : @"picIds",
             @"reposts_count" : @"repostsCount",
             @"attitudes_count" : @"attitudesCount",
             @"darwin_tags" : @"darwinTags",
             @"userType" : @"userType",
             @"pic_infos" : @"picInfos",
             @"in_reply_to_user_id" : @"inReplyToUserId"
             };
}
+ (NSDictionary <NSString *, Class>*)whc_ModelReplaceContainerElementClassMapper {
    return @{@"picIds" : [NSString class],
             @"picInfos" : [WHCWeiboPicture class],
             @"urlStruct" : [WHCWeiboURL class]};
}
@end


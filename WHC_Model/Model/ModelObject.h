//
//  Model.h
//  WHC_Model
//
//  Created by WHC on 16/11/1.
//  Copyright © 2016年 WHC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Head :NSObject
@property (nonatomic , copy) NSString              * responseTime;
@property (nonatomic , copy) NSString              * receiveTime;
@property (nonatomic , copy) NSString              * resultMsg;
@property (nonatomic , assign) NSInteger              resultCode;
@property (nonatomic , copy) NSString              * requestTime;
@property (nonatomic , copy) NSString              * sessionId;

@end

@interface ChangeRule :NSObject
@property (nonatomic , copy) NSString              * ruleRestriction;
@property (nonatomic , copy) NSString              * ruleNote;
@property (nonatomic , copy) NSString              * ruleRemarks;
@property (nonatomic , copy) NSString              * ruleRemarks_En;
@property (nonatomic , copy) NSString              * ruleNote_En;

@end

@interface FeeInfoList :NSObject
@property (nonatomic , copy) NSString              * feeType;
@property (nonatomic , assign) CGFloat              fee;

@end

@interface EndorseRule :NSObject
@property (nonatomic , copy) NSString              * ruleRestriction;
@property (nonatomic , copy) NSString              * ruleNote;
@property (nonatomic , copy) NSString              * ruleRemarks;
@property (nonatomic , copy) NSString              * ruleRemarks_En;
@property (nonatomic , copy) NSString              * ruleNote_En;

@end

@interface RefundRule :NSObject
@property (nonatomic , copy) NSString              * ruleRestriction;
@property (nonatomic , copy) NSString              * ruleNote;
@property (nonatomic , copy) NSString              * ruleRemarks;
@property (nonatomic , copy) NSString              * ruleRemarks_En;
@property (nonatomic , copy) NSString              * ruleNote_En;

@end

@interface PolicyRuleList :NSObject
@property (nonatomic , copy) NSString              * travelerCategory;
@property (nonatomic , assign) BOOL              canUpgrade;
@property (nonatomic , assign) NSInteger              index;
@property (nonatomic , strong) ChangeRule              * changeRule;
@property (nonatomic , copy) NSString              * refundFeeFormulaID;
@property (nonatomic , copy) NSString              * isPackageProduct;
@property (nonatomic , strong) NSArray<FeeInfoList *>              * FeeInfoList;
@property (nonatomic , strong) EndorseRule              * endorseRule;
@property (nonatomic , strong) RefundRule              * refundRule;
@property (nonatomic , copy) NSString              * ticketType;

@end

@interface StandardPriceList :NSObject
@property (nonatomic , assign) CGFloat              price;
@property (nonatomic , copy) NSString              * cabinClass;

@end

@interface PriceInfo_Child :NSObject
@property (nonatomic , assign) NSInteger              travelerCategory;
@property (nonatomic , assign) CGFloat              rate;
@property (nonatomic , assign) CGFloat              printPrice;
@property (nonatomic , assign) CGFloat              hZPrice;
@property (nonatomic , assign) CGFloat              discount;
@property (nonatomic , assign) CGFloat              fDPrice;
@property (nonatomic , assign) CGFloat              costPrice;
@property (nonatomic , assign) CGFloat              price;
@property (nonatomic , assign) CGFloat              salePrice;
@property (nonatomic , assign) CGFloat              commission;
@property (nonatomic , assign) CGFloat              subsidy;

@end

@interface AirLineShowEntity :NSObject
@property (nonatomic , assign) CGFloat              price;
@property (nonatomic , copy) NSString              * subClass;

@end

@interface PriceInfo_Adult :NSObject
@property (nonatomic , assign) NSInteger              travelerCategory;
@property (nonatomic , assign) CGFloat              rate;
@property (nonatomic , assign) CGFloat              printPrice;
@property (nonatomic , assign) CGFloat              hZPrice;
@property (nonatomic , assign) CGFloat              discount;
@property (nonatomic , assign) CGFloat              fDPrice;
@property (nonatomic , assign) CGFloat              costPrice;
@property (nonatomic , assign) CGFloat              price;
@property (nonatomic , assign) CGFloat              salePrice;
@property (nonatomic , assign) CGFloat              commission;
@property (nonatomic , assign) CGFloat              subsidy;

@end

@interface LowestPriceCabin :NSObject
@property (nonatomic , copy) NSString              * bookingClass;
@property (nonatomic , assign) BOOL              applyChild;
@property (nonatomic , assign) BOOL              isSupportChildPolicy;
@property (nonatomic , copy) NSString              * cabinClass;
@property (nonatomic , assign) NSInteger              productSource;
@property (nonatomic , copy) NSString              * productType;
@property (nonatomic , copy) NSString              * realSubclass;
@property (nonatomic , copy) NSString              * policyCategory;
@property (nonatomic , assign) NSInteger              billType;
@property (nonatomic , strong) NSArray<NSNumber *>              * PolicyRuleIndexList;
@property (nonatomic , assign) NSInteger              seatCount;
@property (nonatomic , strong) PriceInfo_Child              * priceInfo_Child;
@property (nonatomic , copy) NSString              * priceInfo_Infant;
@property (nonatomic , copy) NSString              * ticketDeadline;
@property (nonatomic , copy) NSString              * policyID;
@property (nonatomic , copy) NSString              * productAttribute;
@property (nonatomic , copy) NSString              * pID;
@property (nonatomic , assign) BOOL              isSupportBabyPolicy;
@property (nonatomic , strong) AirLineShowEntity              * airLineShowEntity;
@property (nonatomic , copy) NSString              * productID;
@property (nonatomic , copy) NSString              * saleType;
@property (nonatomic , strong) PriceInfo_Adult              * priceInfo_Adult;

@end


@interface CabinInfoList :NSObject
@property (nonatomic , copy) NSString              * bookingClass;
@property (nonatomic , assign) BOOL              applyChild;
@property (nonatomic , assign) BOOL              isSupportChildPolicy;
@property (nonatomic , copy) NSString              * cabinClass;
@property (nonatomic , assign) NSInteger              productSource;
@property (nonatomic , copy) NSString              * productType;
@property (nonatomic , copy) NSString              * realSubclass;
@property (nonatomic , copy) NSString              * policyCategory;
@property (nonatomic , assign) NSInteger              billType;
@property (nonatomic , strong) NSArray<NSNumber *>              * PolicyRuleIndexList;
@property (nonatomic , assign) NSInteger              seatCount;
@property (nonatomic , strong) PriceInfo_Child              * priceInfo_Child;
@property (nonatomic , copy) NSString              * priceInfo_Infant;
@property (nonatomic , copy) NSString              * ticketDeadline;
@property (nonatomic , copy) NSString              * policyID;
@property (nonatomic , copy) NSString              * productAttribute;
@property (nonatomic , copy) NSString              * pID;
@property (nonatomic , assign) BOOL              isSupportBabyPolicy;
@property (nonatomic , strong) AirLineShowEntity              * airLineShowEntity;
@property (nonatomic , copy) NSString              * productID;
@property (nonatomic , copy) NSString              * saleType;
@property (nonatomic , strong) PriceInfo_Adult              * priceInfo_Adult;

@end

@interface PunctualityRateDetail :NSObject
@property (nonatomic , assign) CGFloat              delayOver90;
@property (nonatomic , assign) CGFloat              cancel;
@property (nonatomic , assign) CGFloat              onTime;
@property (nonatomic , assign) CGFloat              delay30To60;
@property (nonatomic , assign) CGFloat              delay60To90;

@end

@interface FlightInfoList :NSObject
@property (nonatomic , copy) NSString              * deptAirportCode;
@property (nonatomic , strong) NSArray<StandardPriceList *>              * StandardPriceList;
@property (nonatomic , assign) BOOL              isFlyMan;
@property (nonatomic , strong) LowestPriceCabin              * lowestPriceCabin;
@property (nonatomic , copy) NSString              * arrvCityCode;
@property (nonatomic , strong) NSArray<CabinInfoList *>              * CabinInfoList;
@property (nonatomic , copy) NSString              * arrvAirportName;
@property (nonatomic , copy) NSString              * arrvAirportCode;
@property (nonatomic , copy) NSString              * flightStopList;
@property (nonatomic , assign) NSInteger              dataSource;
@property (nonatomic , copy) NSString              * mealType;
@property (nonatomic , assign) CGFloat              punctualityRate;
@property (nonatomic , copy) NSString              * craftType;
@property (nonatomic , copy) NSString              * deptCityCode;
@property (nonatomic , copy) NSString              * sharedFlight;
@property (nonatomic , copy) NSString              * arrvCityName;
@property (nonatomic , assign) CGFloat              buildFee;
@property (nonatomic , copy) NSString              * arrvDateTime;
@property (nonatomic , assign) CGFloat              fuelFee;
@property (nonatomic , assign) NSInteger              segmentIndex;
@property (nonatomic , copy) NSString              * carrierName;
@property (nonatomic , copy) NSString              * flightNumber;
@property (nonatomic , copy) NSString              * arrvTerminalID;
@property (nonatomic , copy) NSString              * carrierCode;
@property (nonatomic , copy) NSString              * deptTerminalID;
@property (nonatomic , assign) BOOL              isShareFlight;
@property (nonatomic , copy) NSString              * deptCityName;
@property (nonatomic , strong) PunctualityRateDetail              * punctualityRateDetail;
@property (nonatomic , copy) NSString              * deptDateTime;
@property (nonatomic , copy) NSString              * deptAirportName;
@property (nonatomic , assign) NSInteger              nextDays;

@end

@interface FlightListGroupList :NSObject
@property (nonatomic , strong) NSArray<FlightInfoList *>              * FlightInfoList;
@property (nonatomic , assign) NSInteger              origDestSeqID;

@end

@interface ResponseBody :NSObject
@property (nonatomic , strong) NSArray<PolicyRuleList *>              * PolicyRuleList;
@property (nonatomic , strong) NSArray<FlightListGroupList *>              * FlightListGroupList;
@property (nonatomic , assign) BOOL              isCompleted;

@end

@interface ModelObject :NSObject
@property (nonatomic , strong) Head              * head;
@property (nonatomic , strong) ResponseBody              * responseBody;

@end


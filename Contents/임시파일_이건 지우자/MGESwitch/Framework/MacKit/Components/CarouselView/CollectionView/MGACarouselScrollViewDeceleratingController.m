//
//  MGACarouselScrollViewDeceleratingController.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

@import GraphicsKit;
#import <QuartzCore/QuartzCore.h>
#import "MGACarouselScrollViewDeceleratingController.h"
#import "NSScrollView+Extension.h"
#import "MGACarouselScrollView.h"

static CFTimeInterval tickInterval = 1.0 / 60.0;

@interface MGACarouselScrollViewDeceleratingController ()
@property (nonatomic, assign, readwrite) CGFloat distance;
@property (nonatomic, assign, readwrite) NSTimeInterval duration;
@property (nonatomic, assign, readwrite) NSTimeInterval targetDuration;
@property (nonatomic, strong, nullable) NSTimer *timer;  // NSTimer 일때 Target을 weak로 잡자.
@property (nonatomic, assign) CFTimeInterval startTime;

@property (nonatomic, assign) CGPoint startOffset;
@property (nonatomic, assign) CGPoint endOffset;
@property (nonatomic, assign) CGPoint maxOffset;
@property (nonatomic, assign) BOOL horizontalScroll;
@property (nonatomic, assign) BOOL offsetIncrement;

@property (nonatomic, strong, nullable) MGEDisplayLink *displayLink;

// startVelocity, targetDistance, targetDuration 이 정해졌을 때
// 0.0 ~ targetDuration 까지 진행하는 동안(독립변수) 0.0 ~ targetDistance 에 대응하는 함수를 만들기 위한
// raw 함수 구성을 위한 pow를 의미한다. xᴷ = y 함수를 변형하여 조직할 것이다. 0.0~1.0의 범위를
// 반대로 접근하여 구성한다.(기울기를 유지하기 위해)
@property (nonatomic, assign) CGFloat rawProgressPow;
@end

@implementation MGACarouselScrollViewDeceleratingController

- (void)dealloc {
    [self invalidate];
}

- (void)setStartVelocity:(CGFloat)startVelocity {
    startVelocity = ABS(startVelocity);
    if (_startVelocity != startVelocity) {
        _startVelocity = startVelocity;
        _distance = distanceForVelocity(_startVelocity);
        _duration = durationForVelocity(_startVelocity);
        self.targetDistance = _distance;
    }
}

- (void)setTargetDistance:(CGFloat)targetDistance {
    if (_targetDistance != targetDistance) {
        _targetDistance = targetDistance;
        if (targetDistance == _distance) {
            _targetDuration = _duration;
        } else {
            _targetDuration = (targetDistance * _duration)/_distance;
            _targetDuration = MIN(_targetDuration, 2.0 *_duration);
        }
    }
}

- (void)beginScrollWithStartOffset:(CGPoint)startOffset endOffset:(CGPoint)endOffset {
    if (_scrollView == nil) { NSCAssert(FALSE, @"_scrollView를 설정하라."); }
    BOOL success = [self setupFunction];
    _startOffset = startOffset;
    _endOffset = endOffset;
    _maxOffset = self.scrollView.mgrMaxOffset;
    if (ABS(startOffset.x - endOffset.x) > ABS(startOffset.y - endOffset.y)) {
        _horizontalScroll = YES;
        _offsetIncrement = ((endOffset.x - startOffset.x) >= 0.0) ? YES : NO;

    } else {
        _horizontalScroll = NO;
        _offsetIncrement = ((endOffset.y - startOffset.y) >= 0.0) ? YES : NO;
    }
    
    [self invalidate];
    if (success == NO) { // 너무 짧아서 그냥 바로 끝내라는 뜻.
        [self.scrollView setMgrContentOffset:self.endOffset];
        [self.scrollView.scrollViewDelegate scrollViewDidScroll:self.scrollView];
        [self.scrollView.scrollViewDelegate scrollViewDidEndScrolling:self.scrollView rollingStop:YES];
        if (self.completionBlock != nil) {
            self.completionBlock();
        }
        return;
    }
    _startTime = CACurrentMediaTime();
    __weak __typeof(self)weakSelf = self;
    _timer = [NSTimer timerWithTimeInterval:(1.0 / 60.0)
                                     target:weakSelf
                                   selector:@selector(displayTick:)
                                   userInfo:nil
                                    repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self displayTick:_timer]; // 최초에 때려줘야 낫다.
}

- (void)displayTick:(NSTimer *)sender {
    NSTimeInterval currentTime = CACurrentMediaTime();
    CGFloat duration = MIN(_targetDuration, currentTime - _startTime); // 0 ~ _targetDuration
    CGFloat distance = [self distanceForCurrentDuration:duration]; // 현재까지의 누적 거리...
    if (_offsetIncrement == NO) {
        distance = -distance;
    }
    
    CGPoint currentOffset = CGPointZero;
    if (self.overFlow == NO) {
        if (duration >= _targetDuration) {
            currentOffset = self.endOffset;
            [self.scrollView setMgrContentOffset:currentOffset];
            [self.scrollView.scrollViewDelegate scrollViewDidScroll:self.scrollView];
            [self.scrollView.scrollViewDelegate scrollViewDidEndScrolling:self.scrollView rollingStop:YES];
            [self invalidate];
            if (self.completionBlock != nil) {
                self.completionBlock();
            }
        } else {
            if (self.horizontalScroll == YES) {
                currentOffset = CGPointMake(self.startOffset.x + distance, self.startOffset.y);
            } else {
                currentOffset = CGPointMake(self.startOffset.x, self.startOffset.y + distance);
            }
            [self.scrollView setMgrContentOffset:currentOffset];
            //! current Index 갱신.
            [self.scrollView.scrollViewDelegate scrollViewDidScroll:self.scrollView];
        }
    } else { // self.overFlow == YES
        if (self.horizontalScroll == YES) {
            currentOffset = CGPointMake(self.startOffset.x + distance, self.startOffset.y);
        } else {
            currentOffset = CGPointMake(self.startOffset.x, self.startOffset.y + distance);
        }
        
        BOOL finish = NO; // 바운더리에 맞추고 정리하자.
        CGPoint finalOffset = CGPointZero;
        CGPoint newEndOffset = CGPointZero;
        if (_offsetIncrement == NO) {
            finalOffset = CGPointZero;
            if (self.horizontalScroll == YES) {
                if (currentOffset.x <= 0.0) {
                    currentOffset.x = 0.0;
                    if (self.startOffset.x <= 0.0) {
                        currentOffset.x = self.startOffset.x;
                    }
                    finish = YES;
                    newEndOffset.x = -pow(ABS(_endOffset.x/10.0), 825.0/1000.0);
                }
            } else {
                if (currentOffset.y <= 0.0) {
                    currentOffset.y = 0.0;
                    if (self.startOffset.y <= 0.0) {
                        currentOffset.y = self.startOffset.y;
                    }
                    finish = YES;
                    newEndOffset.y = -pow(ABS(_endOffset.y/10.0), 825.0/1000.0);
                }
            }
        } else {
            if (self.horizontalScroll == YES) {
                if (currentOffset.x >= self.maxOffset.x) {
                    currentOffset.x = self.maxOffset.x;
                    finalOffset.x = self.maxOffset.x;
                    if (self.startOffset.x >= self.maxOffset.x) {
                        currentOffset.x = self.startOffset.x;
                    }
                    
                    finish = YES;
                    newEndOffset.x = pow(ABS((_endOffset.x-self.maxOffset.x)/10.0), 825.0/1000.0);
                    newEndOffset.x = newEndOffset.x + self.maxOffset.x;
                }
            } else {
                if (currentOffset.y >= self.maxOffset.y) {
                    currentOffset.y = self.maxOffset.y;
                    finalOffset.y = self.maxOffset.y;
                    if (self.startOffset.y >= self.maxOffset.y) {
                        currentOffset.y = self.startOffset.y;
                    }
                    finish = YES;
                    newEndOffset.y = pow(ABS((_endOffset.y-self.maxOffset.y)/10.0), 825.0/1000.0);
                    newEndOffset.y = newEndOffset.y + self.maxOffset.y;
                }
            }
        }
        
        [self.scrollView setMgrContentOffset:currentOffset];
        //! current Index 갱신.
        [self.scrollView.scrollViewDelegate scrollViewDidScroll:self.scrollView];
        if (finish == YES) {
            [self invalidate];
            if ((self.horizontalScroll == YES && self.scrollView.horizontalScrollElasticity == NSScrollElasticityNone) ||
                (self.horizontalScroll == NO && self.scrollView.verticalScrollElasticity == NSScrollElasticityNone)) {
                if (self.completionBlock != nil) {
                    self.completionBlock();
                }
                return;
            }
            __weak __typeof(self) weakSelf = self;
            _displayLink = [MGEDisplayLink displayLinkWithDuration:0.1
                                                easingFunctionType:MGEEasingFunctionTypeEaseOutSine
                                                     progressBlock:^(CGFloat progress) {
                CGPoint offset = MGELerpPoint(progress, currentOffset, newEndOffset);
                [weakSelf.scrollView setMgrContentOffset:offset];
            } completionBlock:^{
                weakSelf.displayLink =
                    [MGEDisplayLink displayLinkWithDuration:0.4
                                         easingFunctionType:MGEEasingFunctionTypeEaseInSine
                                              progressBlock:^(CGFloat progress) {
                    CGPoint offset = MGELerpPoint(progress, newEndOffset, finalOffset);
                    [weakSelf.scrollView setMgrContentOffset:offset];
                } completionBlock:^{
                    [weakSelf.scrollView.scrollViewDelegate scrollViewDidEndScrolling:weakSelf.scrollView
                                                                          rollingStop:YES];
                    if (weakSelf.completionBlock != nil) {
                        weakSelf.completionBlock();
                    }
                }];
                [weakSelf.displayLink startAnimationWithStartProgress:1.0/6.0];
            }];
            [self.displayLink startAnimationWithStartProgress:1.0/6.0];
        }
    }
}

- (void)invalidate {
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (self.displayLink != nil) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (BOOL)setupFunction {
    CGFloat x = tickInterval;
    x = x / _targetDuration;
    x = 1.0 - x;
    CGFloat y = _startVelocity;
    y = y / _targetDistance;
    y = 1.0 - y;
    // xᴷ = y <==> (logy / logx) = K
    if (x <= 0.0 || y <= 0.0) { // decelerationDistance 가 1 이면 바로 멈춰야할 경우가 생길 수 있다. 양수가 아니면 log 값이 nan이 될 수 있음.
        return NO;
    }
    _rawProgressPow = log10(y) / log10(x);
    return YES;
    //
    // _rawProgressPow를 구하는 것.
}

- (double)distanceForCurrentDuration:(double)duration {
    duration = duration / _targetDuration;
    duration = 1.0 - duration;
    CGFloat distance = pow(duration, _rawProgressPow);
    distance = 1.0 - distance;
    distance = distance * _targetDistance;
    return distance;
}



#pragma mark - Helper
/*
myValue 539.000000 || 146339.480990
myValue 9712.000000 || 146341.083565
1.602575

myValue -5.000000 || 146713.519474
myValue -79.000000 || 146713.969390
0.449916
*/
double distanceForVelocity(double v) {
    return v * 18.018552875695733;
    //
    // 실제로 그래프를 그려보니 거의 애플은 거의 직선으로 만들었다.
    /* 구형 식
    CGFloat a = 5979.0/1439130.0; // a : 0.004155
    CGFloat b = (79.0 - (25.0 * a)) / 5.0; // b : 15.779227
    return (a * pow(v, 2.0)) + (b * v);
    */
}

double durationForVelocity(double v) {
    double K = log10(539.0/89.0) / log10(1.602575/1.083339);
    double C = 1.083339 / pow(89.0, 1.0/K);
    // c * ᴷ√v = sec
    return C * pow(v, 1.0/K);
    //
    // 실제로 그래프를 그려보고 현재 식으로 바꿨다.
    // c * ᴷ√v = sec : 연립해서 만들자.
    // c * ᴷ√539 = 1.602575
    // c * ᴷ√5 = 0.449916
    // (1.602575/0.449916)ᴷ = (539.0/5.0)
    // log...(539.0/5.0) = K
    // (log(539.0/5.0)) / (log(1.602575/0.449916)) = K
    // C = 0.449916 / ᴷ√5
    /* 구형식
    double K = log10(539.0/5.0) / log10(1.602575/0.449916);
    double C = 0.449916 / pow(5.0, 1.0/K);
    // c * ᴷ√v = sec
    return C * pow(v, 1.0/K);
     */
}

/*
// distanceForVelocity() 함수의 역함수
__unused double velocityForDistance(double d) {
    CGFloat a = 5979.0/1439130.0;
    CGFloat b = (79.0 - (25.0 * a)) / 5.0;
    return (-b + sqrt( b * b + 4 * a * d)) / (2*a);
}

 __unused double durationForDistance(double d) {
    CGFloat velocity = velocityForDistance(d);
    return durationForVelocity(velocity);
}


 __unused double velocityForDuration(double d) {
    double K = log10(539.0/5.0) / log10(1.602575/0.449916);
    double C = 0.449916 / pow(5.0, 1.0/K);
    return pow( (d/C) , K);
}
*/
@end

// lock wood 알고리즘
// _scrollDuration = fabs(distance) / fabs(0.5 * _startVelocity);


//int main(int argc, const char * argv[]) {
//    @autoreleasepool {
////        NSLog(@"velocity %ld / %f", i, velocity(539.0));
//        for (NSInteger i = 539; i >= 4; i--) {
//            double distance = distanceForVelocity((double)i);
//            double lockWoodDuration = ABS(distance) / ABS(0.5 * i);
//
//            // 1.602575 : 36.037106 = ???? : lockWoodDuration
//            lockWoodDuration = lockWoodDuration * 1.602575/36.037106;
//
//            printf("%ld :velocity => %f, duration => %f, LockWood_Duration => %f \n", i, distance, durationForvelocity((double)i), lockWoodDuration);
//        }
//
////        for (NSInteger i = 539; i >= 4; i--) {
////            NSLog(@"durationForvelocity %ld / %f", i, durationForvelocity((double)i));
////        }
//    }
//    return 0;
//}
//

//#  Velocity
//   18.018552875695733 이걸 곱하는게 나을 수도 있다.
//
//http://ocw.sogang.ac.kr/rfile/2017/World%20of%20Physics/03_마찰_20171220162021.pdf
//
//Kinetic Energy : (1/2) * mv2 = 마찰력 * 제동거리
//
//제동거리는 속도의 제곱에 비례한다.
//자동차 제동거리 = 0.005 * (Velocity)² + 0.2 * Velocity
//Velocity 539.000000 --> 9712.0
//Velocity 5.000000 --> 79.0
//
//제동시간은 속도에 비례한다. <- 맞는 것 같다.
//Velocity 539.0 --> 1.602575
//Velocity 5.0 --> 0.449916
//duration = ( 1.152659 / 534.0) * (Velocity - 5.0) + 0.449916
//
//myValue 539.0 // 9712.0 // 1.602575
//myValue 5.0   // 79.0   // 0.449916
//
//
/** 애플 스크롤 조사.
start Velocity : 4
total Distance : 56
total Duration : 0.416674
------------------------------------------
start Velocity : 5
total Distance : 79
total Duration : 0.450231
------------------------------------------
start Velocity : 6
total Distance : 102
total Duration : 0.50002
------------------------------------------
start Velocity : 7
total Distance : 125
total Duration : 0.566694
------------------------------------------
start Velocity : 8
total Distance : 152
total Duration : 0.600057
------------------------------------------
start Velocity : 9
total Distance : 179
total Duration : 0.633386
------------------------------------------
start Velocity : 10
total Distance : 180
total Duration : 0.636081
------------------------------------------
start Velocity : 11
total Distance : 215
total Duration : 0.66703
------------------------------------------

...

------------------------------------------
start Velocity : 14
total Distance : 282
total Duration : 0.716696
------------------------------------------
...
------------------------------------------
start Velocity : 16
total Distance : 320
total Duration : 0.719331
------------------------------------------
...
------------------------------------------
start Velocity : 28
total Distance : 589
total Duration : 0.850106
------------------------------------------
...
------------------------------------------
start Velocity : 50
total Distance : 1089
total Duration : 0.966694
------------------------------------------
...
------------------------------------------
start Velocity : 89
total Distance : 1831
total Duration : 1.083339
------------------------------------------
...
------------------------------------------
start Velocity : 120
total Distance : 2274
total Duration : 1.133373
------------------------------------------
...
------------------------------------------
start Velocity : 200
total Distance : 3481
total Duration : 1.263612
------------------------------------------
...
------------------------------------------
start Velocity : 346
total Distance : 5907
total Duration : 1.402195
------------------------------------------
...
------------------------------------------
start Velocity : 450
total Distance : 7829
total Duration : 1.533482
------------------------------------------
start Velocity : 487
total Distance : 8736
total Duration : 1.586118
------------------------------------------
start Velocity : 495
total Distance : 8976
total Duration : 1.568621
------------------------------------------
start Velocity : 532
total Distance : 9639
total Duration : 1.604691
------------------------------------------
start Velocity : 539
total Distance : 9712
total Duration : 1.602575
------------------------------------------
*/

/** 내가 만든 알고리즘. 신형.
 double distanceForVelocity(double v);
 double durationForVelocity(double v);

 539 :velocity => 9712.000000, duration => 1.602575
 538 :velocity => 9693.981447, duration => 1.601928
 537 :velocity => 9675.962894, duration => 1.601280
 536 :velocity => 9657.944341, duration => 1.600632
 535 :velocity => 9639.925788, duration => 1.599982
 534 :velocity => 9621.907236, duration => 1.599331
 533 :velocity => 9603.888683, duration => 1.598680
 532 :velocity => 9585.870130, duration => 1.598027
 531 :velocity => 9567.851577, duration => 1.597374
 530 :velocity => 9549.833024, duration => 1.596719
 529 :velocity => 9531.814471, duration => 1.596064
 528 :velocity => 9513.795918, duration => 1.595407
 527 :velocity => 9495.777365, duration => 1.594750
 526 :velocity => 9477.758813, duration => 1.594091
 525 :velocity => 9459.740260, duration => 1.593432
 524 :velocity => 9441.721707, duration => 1.592772
 523 :velocity => 9423.703154, duration => 1.592110
 522 :velocity => 9405.684601, duration => 1.591448
 521 :velocity => 9387.666048, duration => 1.590785
 520 :velocity => 9369.647495, duration => 1.590120
 519 :velocity => 9351.628942, duration => 1.589455
 518 :velocity => 9333.610390, duration => 1.588789
 517 :velocity => 9315.591837, duration => 1.588121
 516 :velocity => 9297.573284, duration => 1.587453
 515 :velocity => 9279.554731, duration => 1.586784
 514 :velocity => 9261.536178, duration => 1.586113
 513 :velocity => 9243.517625, duration => 1.585442
 512 :velocity => 9225.499072, duration => 1.584770
 511 :velocity => 9207.480519, duration => 1.584096
 510 :velocity => 9189.461967, duration => 1.583422
 509 :velocity => 9171.443414, duration => 1.582746
 508 :velocity => 9153.424861, duration => 1.582070
 507 :velocity => 9135.406308, duration => 1.581392
 506 :velocity => 9117.387755, duration => 1.580713
 505 :velocity => 9099.369202, duration => 1.580034
 504 :velocity => 9081.350649, duration => 1.579353
 503 :velocity => 9063.332096, duration => 1.578671
 502 :velocity => 9045.313544, duration => 1.577988
 501 :velocity => 9027.294991, duration => 1.577304
 500 :velocity => 9009.276438, duration => 1.576619
 499 :velocity => 8991.257885, duration => 1.575933
 498 :velocity => 8973.239332, duration => 1.575246
 497 :velocity => 8955.220779, duration => 1.574558
 496 :velocity => 8937.202226, duration => 1.573869
 495 :velocity => 8919.183673, duration => 1.573178
 494 :velocity => 8901.165121, duration => 1.572487
 493 :velocity => 8883.146568, duration => 1.571794
 492 :velocity => 8865.128015, duration => 1.571101
 491 :velocity => 8847.109462, duration => 1.570406
 490 :velocity => 8829.090909, duration => 1.569710
 489 :velocity => 8811.072356, duration => 1.569013
 488 :velocity => 8793.053803, duration => 1.568315
 487 :velocity => 8775.035250, duration => 1.567615
 486 :velocity => 8757.016698, duration => 1.566915
 485 :velocity => 8738.998145, duration => 1.566214
 484 :velocity => 8720.979592, duration => 1.565511
 483 :velocity => 8702.961039, duration => 1.564807
 482 :velocity => 8684.942486, duration => 1.564102
 481 :velocity => 8666.923933, duration => 1.563396
 480 :velocity => 8648.905380, duration => 1.562689
 479 :velocity => 8630.886827, duration => 1.561981
 478 :velocity => 8612.868275, duration => 1.561271
 477 :velocity => 8594.849722, duration => 1.560560
 476 :velocity => 8576.831169, duration => 1.559849
 475 :velocity => 8558.812616, duration => 1.559136
 474 :velocity => 8540.794063, duration => 1.558421
 473 :velocity => 8522.775510, duration => 1.557706
 472 :velocity => 8504.756957, duration => 1.556989
 471 :velocity => 8486.738404, duration => 1.556272
 470 :velocity => 8468.719852, duration => 1.555553
 469 :velocity => 8450.701299, duration => 1.554833
 468 :velocity => 8432.682746, duration => 1.554111
 467 :velocity => 8414.664193, duration => 1.553389
 466 :velocity => 8396.645640, duration => 1.552665
 465 :velocity => 8378.627087, duration => 1.551940
 464 :velocity => 8360.608534, duration => 1.551214
 463 :velocity => 8342.589981, duration => 1.550486
 462 :velocity => 8324.571429, duration => 1.549758
 461 :velocity => 8306.552876, duration => 1.549028
 460 :velocity => 8288.534323, duration => 1.548297
 459 :velocity => 8270.515770, duration => 1.547564
 458 :velocity => 8252.497217, duration => 1.546831
 457 :velocity => 8234.478664, duration => 1.546096
 456 :velocity => 8216.460111, duration => 1.545360
 455 :velocity => 8198.441558, duration => 1.544622
 454 :velocity => 8180.423006, duration => 1.543884
 453 :velocity => 8162.404453, duration => 1.543144
 452 :velocity => 8144.385900, duration => 1.542402
 451 :velocity => 8126.367347, duration => 1.541660
 450 :velocity => 8108.348794, duration => 1.540916
 449 :velocity => 8090.330241, duration => 1.540171
 448 :velocity => 8072.311688, duration => 1.539425
 447 :velocity => 8054.293135, duration => 1.538677
 446 :velocity => 8036.274583, duration => 1.537928
 445 :velocity => 8018.256030, duration => 1.537177
 444 :velocity => 8000.237477, duration => 1.536426
 443 :velocity => 7982.218924, duration => 1.535673
 442 :velocity => 7964.200371, duration => 1.534919
 441 :velocity => 7946.181818, duration => 1.534163
 440 :velocity => 7928.163265, duration => 1.533406
 439 :velocity => 7910.144712, duration => 1.532648
 438 :velocity => 7892.126160, duration => 1.531888
 437 :velocity => 7874.107607, duration => 1.531127
 436 :velocity => 7856.089054, duration => 1.530364
 435 :velocity => 7838.070501, duration => 1.529601
 434 :velocity => 7820.051948, duration => 1.528835
 433 :velocity => 7802.033395, duration => 1.528069
 432 :velocity => 7784.014842, duration => 1.527301
 431 :velocity => 7765.996289, duration => 1.526532
 430 :velocity => 7747.977737, duration => 1.525761
 429 :velocity => 7729.959184, duration => 1.524989
 428 :velocity => 7711.940631, duration => 1.524215
 427 :velocity => 7693.922078, duration => 1.523440
 426 :velocity => 7675.903525, duration => 1.522664
 425 :velocity => 7657.884972, duration => 1.521886
 424 :velocity => 7639.866419, duration => 1.521107
 423 :velocity => 7621.847866, duration => 1.520326
 422 :velocity => 7603.829314, duration => 1.519544
 421 :velocity => 7585.810761, duration => 1.518761
 420 :velocity => 7567.792208, duration => 1.517976
 419 :velocity => 7549.773655, duration => 1.517189
 418 :velocity => 7531.755102, duration => 1.516401
 417 :velocity => 7513.736549, duration => 1.515612
 416 :velocity => 7495.717996, duration => 1.514821
 415 :velocity => 7477.699443, duration => 1.514028
 414 :velocity => 7459.680891, duration => 1.513235
 413 :velocity => 7441.662338, duration => 1.512439
 412 :velocity => 7423.643785, duration => 1.511642
 411 :velocity => 7405.625232, duration => 1.510844
 410 :velocity => 7387.606679, duration => 1.510044
 409 :velocity => 7369.588126, duration => 1.509242
 408 :velocity => 7351.569573, duration => 1.508439
 407 :velocity => 7333.551020, duration => 1.507635
 406 :velocity => 7315.532468, duration => 1.506829
 405 :velocity => 7297.513915, duration => 1.506021
 404 :velocity => 7279.495362, duration => 1.505212
 403 :velocity => 7261.476809, duration => 1.504401
 402 :velocity => 7243.458256, duration => 1.503589
 401 :velocity => 7225.439703, duration => 1.502775
 400 :velocity => 7207.421150, duration => 1.501959
 399 :velocity => 7189.402597, duration => 1.501142
 398 :velocity => 7171.384045, duration => 1.500323
 397 :velocity => 7153.365492, duration => 1.499503
 396 :velocity => 7135.346939, duration => 1.498681
 395 :velocity => 7117.328386, duration => 1.497857
 394 :velocity => 7099.309833, duration => 1.497032
 393 :velocity => 7081.291280, duration => 1.496205
 392 :velocity => 7063.272727, duration => 1.495377
 391 :velocity => 7045.254174, duration => 1.494547
 390 :velocity => 7027.235622, duration => 1.493715
 389 :velocity => 7009.217069, duration => 1.492881
 388 :velocity => 6991.198516, duration => 1.492046
 387 :velocity => 6973.179963, duration => 1.491209
 386 :velocity => 6955.161410, duration => 1.490371
 385 :velocity => 6937.142857, duration => 1.489530
 384 :velocity => 6919.124304, duration => 1.488688
 383 :velocity => 6901.105751, duration => 1.487845
 382 :velocity => 6883.087199, duration => 1.486999
 381 :velocity => 6865.068646, duration => 1.486152
 380 :velocity => 6847.050093, duration => 1.485303
 379 :velocity => 6829.031540, duration => 1.484453
 378 :velocity => 6811.012987, duration => 1.483600
 377 :velocity => 6792.994434, duration => 1.482746
 376 :velocity => 6774.975881, duration => 1.481890
 375 :velocity => 6756.957328, duration => 1.481032
 374 :velocity => 6738.938776, duration => 1.480173
 373 :velocity => 6720.920223, duration => 1.479312
 372 :velocity => 6702.901670, duration => 1.478448
 371 :velocity => 6684.883117, duration => 1.477583
 370 :velocity => 6666.864564, duration => 1.476717
 369 :velocity => 6648.846011, duration => 1.475848
 368 :velocity => 6630.827458, duration => 1.474978
 367 :velocity => 6612.808905, duration => 1.474105
 366 :velocity => 6594.790353, duration => 1.473231
 365 :velocity => 6576.771800, duration => 1.472355
 364 :velocity => 6558.753247, duration => 1.471477
 363 :velocity => 6540.734694, duration => 1.470597
 362 :velocity => 6522.716141, duration => 1.469716
 361 :velocity => 6504.697588, duration => 1.468832
 360 :velocity => 6486.679035, duration => 1.467947
 359 :velocity => 6468.660482, duration => 1.467059
 358 :velocity => 6450.641929, duration => 1.466170
 357 :velocity => 6432.623377, duration => 1.465278
 356 :velocity => 6414.604824, duration => 1.464385
 355 :velocity => 6396.586271, duration => 1.463490
 354 :velocity => 6378.567718, duration => 1.462593
 353 :velocity => 6360.549165, duration => 1.461693
 352 :velocity => 6342.530612, duration => 1.460792
 351 :velocity => 6324.512059, duration => 1.459889
 350 :velocity => 6306.493506, duration => 1.458984
 349 :velocity => 6288.474954, duration => 1.458076
 348 :velocity => 6270.456401, duration => 1.457167
 347 :velocity => 6252.437848, duration => 1.456256
 346 :velocity => 6234.419295, duration => 1.455342
 345 :velocity => 6216.400742, duration => 1.454427
 344 :velocity => 6198.382189, duration => 1.453509
 343 :velocity => 6180.363636, duration => 1.452590
 342 :velocity => 6162.345083, duration => 1.451668
 341 :velocity => 6144.326531, duration => 1.450744
 340 :velocity => 6126.307978, duration => 1.449818
 339 :velocity => 6108.289425, duration => 1.448890
 338 :velocity => 6090.270872, duration => 1.447960
 337 :velocity => 6072.252319, duration => 1.447027
 336 :velocity => 6054.233766, duration => 1.446093
 335 :velocity => 6036.215213, duration => 1.445156
 334 :velocity => 6018.196660, duration => 1.444217
 333 :velocity => 6000.178108, duration => 1.443276
 332 :velocity => 5982.159555, duration => 1.442332
 331 :velocity => 5964.141002, duration => 1.441387
 330 :velocity => 5946.122449, duration => 1.440439
 329 :velocity => 5928.103896, duration => 1.439489
 328 :velocity => 5910.085343, duration => 1.438536
 327 :velocity => 5892.066790, duration => 1.437582
 326 :velocity => 5874.048237, duration => 1.436625
 325 :velocity => 5856.029685, duration => 1.435666
 324 :velocity => 5838.011132, duration => 1.434704
 323 :velocity => 5819.992579, duration => 1.433740
 322 :velocity => 5801.974026, duration => 1.432774
 321 :velocity => 5783.955473, duration => 1.431805
 320 :velocity => 5765.936920, duration => 1.430835
 319 :velocity => 5747.918367, duration => 1.429861
 318 :velocity => 5729.899814, duration => 1.428886
 317 :velocity => 5711.881262, duration => 1.427908
 316 :velocity => 5693.862709, duration => 1.426927
 315 :velocity => 5675.844156, duration => 1.425944
 314 :velocity => 5657.825603, duration => 1.424959
 313 :velocity => 5639.807050, duration => 1.423971
 312 :velocity => 5621.788497, duration => 1.422981
 311 :velocity => 5603.769944, duration => 1.421988
 310 :velocity => 5585.751391, duration => 1.420992
 309 :velocity => 5567.732839, duration => 1.419995
 308 :velocity => 5549.714286, duration => 1.418994
 307 :velocity => 5531.695733, duration => 1.417991
 306 :velocity => 5513.677180, duration => 1.416986
 305 :velocity => 5495.658627, duration => 1.415978
 304 :velocity => 5477.640074, duration => 1.414967
 303 :velocity => 5459.621521, duration => 1.413954
 302 :velocity => 5441.602968, duration => 1.412938
 301 :velocity => 5423.584416, duration => 1.411920
 300 :velocity => 5405.565863, duration => 1.410899
 299 :velocity => 5387.547310, duration => 1.409875
 298 :velocity => 5369.528757, duration => 1.408848
 297 :velocity => 5351.510204, duration => 1.407819
 296 :velocity => 5333.491651, duration => 1.406787
 295 :velocity => 5315.473098, duration => 1.405753
 294 :velocity => 5297.454545, duration => 1.404715
 293 :velocity => 5279.435993, duration => 1.403675
 292 :velocity => 5261.417440, duration => 1.402632
 291 :velocity => 5243.398887, duration => 1.401587
 290 :velocity => 5225.380334, duration => 1.400538
 289 :velocity => 5207.361781, duration => 1.399487
 288 :velocity => 5189.343228, duration => 1.398433
 287 :velocity => 5171.324675, duration => 1.397375
 286 :velocity => 5153.306122, duration => 1.396315
 285 :velocity => 5135.287570, duration => 1.395253
 284 :velocity => 5117.269017, duration => 1.394187
 283 :velocity => 5099.250464, duration => 1.393118
 282 :velocity => 5081.231911, duration => 1.392046
 281 :velocity => 5063.213358, duration => 1.390972
 280 :velocity => 5045.194805, duration => 1.389894
 279 :velocity => 5027.176252, duration => 1.388813
 278 :velocity => 5009.157699, duration => 1.387730
 277 :velocity => 4991.139147, duration => 1.386643
 276 :velocity => 4973.120594, duration => 1.385553
 275 :velocity => 4955.102041, duration => 1.384460
 274 :velocity => 4937.083488, duration => 1.383364
 273 :velocity => 4919.064935, duration => 1.382265
 272 :velocity => 4901.046382, duration => 1.381162
 271 :velocity => 4883.027829, duration => 1.380057
 270 :velocity => 4865.009276, duration => 1.378948
 269 :velocity => 4846.990724, duration => 1.377836
 268 :velocity => 4828.972171, duration => 1.376721
 267 :velocity => 4810.953618, duration => 1.375603
 266 :velocity => 4792.935065, duration => 1.374481
 265 :velocity => 4774.916512, duration => 1.373356
 264 :velocity => 4756.897959, duration => 1.372227
 263 :velocity => 4738.879406, duration => 1.371096
 262 :velocity => 4720.860853, duration => 1.369961
 261 :velocity => 4702.842301, duration => 1.368822
 260 :velocity => 4684.823748, duration => 1.367680
 259 :velocity => 4666.805195, duration => 1.366535
 258 :velocity => 4648.786642, duration => 1.365386
 257 :velocity => 4630.768089, duration => 1.364234
 256 :velocity => 4612.749536, duration => 1.363078
 255 :velocity => 4594.730983, duration => 1.361919
 254 :velocity => 4576.712430, duration => 1.360756
 253 :velocity => 4558.693878, duration => 1.359589
 252 :velocity => 4540.675325, duration => 1.358419
 251 :velocity => 4522.656772, duration => 1.357245
 250 :velocity => 4504.638219, duration => 1.356068
 249 :velocity => 4486.619666, duration => 1.354887
 248 :velocity => 4468.601113, duration => 1.353702
 247 :velocity => 4450.582560, duration => 1.352513
 246 :velocity => 4432.564007, duration => 1.351321
 245 :velocity => 4414.545455, duration => 1.350125
 244 :velocity => 4396.526902, duration => 1.348925
 243 :velocity => 4378.508349, duration => 1.347721
 242 :velocity => 4360.489796, duration => 1.346513
 241 :velocity => 4342.471243, duration => 1.345302
 240 :velocity => 4324.452690, duration => 1.344086
 239 :velocity => 4306.434137, duration => 1.342867
 238 :velocity => 4288.415584, duration => 1.341643
 237 :velocity => 4270.397032, duration => 1.340416
 236 :velocity => 4252.378479, duration => 1.339184
 235 :velocity => 4234.359926, duration => 1.337948
 234 :velocity => 4216.341373, duration => 1.336708
 233 :velocity => 4198.322820, duration => 1.335464
 232 :velocity => 4180.304267, duration => 1.334216
 231 :velocity => 4162.285714, duration => 1.332964
 230 :velocity => 4144.267161, duration => 1.331707
 229 :velocity => 4126.248609, duration => 1.330446
 228 :velocity => 4108.230056, duration => 1.329181
 227 :velocity => 4090.211503, duration => 1.327911
 226 :velocity => 4072.192950, duration => 1.326637
 225 :velocity => 4054.174397, duration => 1.325359
 224 :velocity => 4036.155844, duration => 1.324076
 223 :velocity => 4018.137291, duration => 1.322789
 222 :velocity => 4000.118738, duration => 1.321497
 221 :velocity => 3982.100186, duration => 1.320200
 220 :velocity => 3964.081633, duration => 1.318899
 219 :velocity => 3946.063080, duration => 1.317594
 218 :velocity => 3928.044527, duration => 1.316283
 217 :velocity => 3910.025974, duration => 1.314968
 216 :velocity => 3892.007421, duration => 1.313649
 215 :velocity => 3873.988868, duration => 1.312324
 214 :velocity => 3855.970315, duration => 1.310995
 213 :velocity => 3837.951763, duration => 1.309660
 212 :velocity => 3819.933210, duration => 1.308321
 211 :velocity => 3801.914657, duration => 1.306977
 210 :velocity => 3783.896104, duration => 1.305628
 209 :velocity => 3765.877551, duration => 1.304274
 208 :velocity => 3747.858998, duration => 1.302914
 207 :velocity => 3729.840445, duration => 1.301550
 206 :velocity => 3711.821892, duration => 1.300180
 205 :velocity => 3693.803340, duration => 1.298806
 204 :velocity => 3675.784787, duration => 1.297425
 203 :velocity => 3657.766234, duration => 1.296040
 202 :velocity => 3639.747681, duration => 1.294649
 201 :velocity => 3621.729128, duration => 1.293253
 200 :velocity => 3603.710575, duration => 1.291852
 199 :velocity => 3585.692022, duration => 1.290445
 198 :velocity => 3567.673469, duration => 1.289032
 197 :velocity => 3549.654917, duration => 1.287614
 196 :velocity => 3531.636364, duration => 1.286190
 195 :velocity => 3513.617811, duration => 1.284761
 194 :velocity => 3495.599258, duration => 1.283325
 193 :velocity => 3477.580705, duration => 1.281884
 192 :velocity => 3459.562152, duration => 1.280437
 191 :velocity => 3441.543599, duration => 1.278985
 190 :velocity => 3423.525046, duration => 1.277526
 189 :velocity => 3405.506494, duration => 1.276061
 188 :velocity => 3387.487941, duration => 1.274590
 187 :velocity => 3369.469388, duration => 1.273113
 186 :velocity => 3351.450835, duration => 1.271630
 185 :velocity => 3333.432282, duration => 1.270140
 184 :velocity => 3315.413729, duration => 1.268645
 183 :velocity => 3297.395176, duration => 1.267142
 182 :velocity => 3279.376623, duration => 1.265634
 181 :velocity => 3261.358071, duration => 1.264119
 180 :velocity => 3243.339518, duration => 1.262597
 179 :velocity => 3225.320965, duration => 1.261069
 178 :velocity => 3207.302412, duration => 1.259534
 177 :velocity => 3189.283859, duration => 1.257992
 176 :velocity => 3171.265306, duration => 1.256443
 175 :velocity => 3153.246753, duration => 1.254888
 174 :velocity => 3135.228200, duration => 1.253326
 173 :velocity => 3117.209647, duration => 1.251756
 172 :velocity => 3099.191095, duration => 1.250179
 171 :velocity => 3081.172542, duration => 1.248596
 170 :velocity => 3063.153989, duration => 1.247004
 169 :velocity => 3045.135436, duration => 1.245406
 168 :velocity => 3027.116883, duration => 1.243800
 167 :velocity => 3009.098330, duration => 1.242187
 166 :velocity => 2991.079777, duration => 1.240566
 165 :velocity => 2973.061224, duration => 1.238937
 164 :velocity => 2955.042672, duration => 1.237301
 163 :velocity => 2937.024119, duration => 1.235657
 162 :velocity => 2919.005566, duration => 1.234005
 161 :velocity => 2900.987013, duration => 1.232345
 160 :velocity => 2882.968460, duration => 1.230677
 159 :velocity => 2864.949907, duration => 1.229000
 158 :velocity => 2846.931354, duration => 1.227316
 157 :velocity => 2828.912801, duration => 1.225623
 156 :velocity => 2810.894249, duration => 1.223921
 155 :velocity => 2792.875696, duration => 1.222211
 154 :velocity => 2774.857143, duration => 1.220493
 153 :velocity => 2756.838590, duration => 1.218765
 152 :velocity => 2738.820037, duration => 1.217029
 151 :velocity => 2720.801484, duration => 1.215284
 150 :velocity => 2702.782931, duration => 1.213530
 149 :velocity => 2684.764378, duration => 1.211766
 148 :velocity => 2666.745826, duration => 1.209993
 147 :velocity => 2648.727273, duration => 1.208211
 146 :velocity => 2630.708720, duration => 1.206420
 145 :velocity => 2612.690167, duration => 1.204618
 144 :velocity => 2594.671614, duration => 1.202807
 143 :velocity => 2576.653061, duration => 1.200986
 142 :velocity => 2558.634508, duration => 1.199156
 141 :velocity => 2540.615955, duration => 1.197314
 140 :velocity => 2522.597403, duration => 1.195463
 139 :velocity => 2504.578850, duration => 1.193602
 138 :velocity => 2486.560297, duration => 1.191729
 137 :velocity => 2468.541744, duration => 1.189847
 136 :velocity => 2450.523191, duration => 1.187953
 135 :velocity => 2432.504638, duration => 1.186049
 134 :velocity => 2414.486085, duration => 1.184133
 133 :velocity => 2396.467532, duration => 1.182206
 132 :velocity => 2378.448980, duration => 1.180268
 131 :velocity => 2360.430427, duration => 1.178318
 130 :velocity => 2342.411874, duration => 1.176357
 129 :velocity => 2324.393321, duration => 1.174384
 128 :velocity => 2306.374768, duration => 1.172398
 127 :velocity => 2288.356215, duration => 1.170401
 126 :velocity => 2270.337662, duration => 1.168391
 125 :velocity => 2252.319109, duration => 1.166369
 124 :velocity => 2234.300557, duration => 1.164334
 123 :velocity => 2216.282004, duration => 1.162286
 122 :velocity => 2198.263451, duration => 1.160225
 121 :velocity => 2180.244898, duration => 1.158151
 120 :velocity => 2162.226345, duration => 1.156063
 119 :velocity => 2144.207792, duration => 1.153962
 118 :velocity => 2126.189239, duration => 1.151847
 117 :velocity => 2108.170686, duration => 1.149718
 116 :velocity => 2090.152134, duration => 1.147574
 115 :velocity => 2072.133581, duration => 1.145416
 114 :velocity => 2054.115028, duration => 1.143243
 113 :velocity => 2036.096475, duration => 1.141056
 112 :velocity => 2018.077922, duration => 1.138853
 111 :velocity => 2000.059369, duration => 1.136634
 110 :velocity => 1982.040816, duration => 1.134400
 109 :velocity => 1964.022263, duration => 1.132150
 108 :velocity => 1946.003711, duration => 1.129884
 107 :velocity => 1927.985158, duration => 1.127601
 106 :velocity => 1909.966605, duration => 1.125301
 105 :velocity => 1891.948052, duration => 1.122985
 104 :velocity => 1873.929499, duration => 1.120651
 103 :velocity => 1855.910946, duration => 1.118299
 102 :velocity => 1837.892393, duration => 1.115930
 101 :velocity => 1819.873840, duration => 1.113542
 100 :velocity => 1801.855288, duration => 1.111136
 99 :velocity => 1783.836735, duration => 1.108711
 98 :velocity => 1765.818182, duration => 1.106266
 97 :velocity => 1747.799629, duration => 1.103802
 96 :velocity => 1729.781076, duration => 1.101318
 95 :velocity => 1711.762523, duration => 1.098814
 94 :velocity => 1693.743970, duration => 1.096289
 93 :velocity => 1675.725417, duration => 1.093743
 92 :velocity => 1657.706865, duration => 1.091175
 91 :velocity => 1639.688312, duration => 1.088586
 90 :velocity => 1621.669759, duration => 1.085974
 89 :velocity => 1603.651206, duration => 1.083339
 88 :velocity => 1585.632653, duration => 1.080681
 87 :velocity => 1567.614100, duration => 1.077999
 86 :velocity => 1549.595547, duration => 1.075293
 85 :velocity => 1531.576994, duration => 1.072562
 84 :velocity => 1513.558442, duration => 1.069806
 83 :velocity => 1495.539889, duration => 1.067025
 82 :velocity => 1477.521336, duration => 1.064216
 81 :velocity => 1459.502783, duration => 1.061381
 80 :velocity => 1441.484230, duration => 1.058519
 79 :velocity => 1423.465677, duration => 1.055628
 78 :velocity => 1405.447124, duration => 1.052708
 77 :velocity => 1387.428571, duration => 1.049759
 76 :velocity => 1369.410019, duration => 1.046780
 75 :velocity => 1351.391466, duration => 1.043770
 74 :velocity => 1333.372913, duration => 1.040729
 73 :velocity => 1315.354360, duration => 1.037655
 72 :velocity => 1297.335807, duration => 1.034548
 71 :velocity => 1279.317254, duration => 1.031407
 70 :velocity => 1261.298701, duration => 1.028231
 69 :velocity => 1243.280148, duration => 1.025020
 68 :velocity => 1225.261596, duration => 1.021772
 67 :velocity => 1207.243043, duration => 1.018486
 66 :velocity => 1189.224490, duration => 1.015162
 65 :velocity => 1171.205937, duration => 1.011798
 64 :velocity => 1153.187384, duration => 1.008393
 63 :velocity => 1135.168831, duration => 1.004946
 62 :velocity => 1117.150278, duration => 1.001457
 61 :velocity => 1099.131725, duration => 0.997923
 60 :velocity => 1081.113173, duration => 0.994343
 59 :velocity => 1063.094620, duration => 0.990716
 58 :velocity => 1045.076067, duration => 0.987041
 57 :velocity => 1027.057514, duration => 0.983316
 56 :velocity => 1009.038961, duration => 0.979540
 55 :velocity => 991.020408, duration => 0.975710
 54 :velocity => 973.001855, duration => 0.971826
 53 :velocity => 954.983302, duration => 0.967884
 52 :velocity => 936.964750, duration => 0.963884
 51 :velocity => 918.946197, duration => 0.959824
 50 :velocity => 900.927644, duration => 0.955700
 49 :velocity => 882.909091, duration => 0.951512
 48 :velocity => 864.890538, duration => 0.947256
 47 :velocity => 846.871985, duration => 0.942930
 46 :velocity => 828.853432, duration => 0.938532
 45 :velocity => 810.834879, duration => 0.934058
 44 :velocity => 792.816327, duration => 0.929506
 43 :velocity => 774.797774, duration => 0.924872
 42 :velocity => 756.779221, duration => 0.920152
 41 :velocity => 738.760668, duration => 0.915344
 40 :velocity => 720.742115, duration => 0.910444
 39 :velocity => 702.723562, duration => 0.905446
 38 :velocity => 684.705009, duration => 0.900347
 37 :velocity => 666.686456, duration => 0.895142
 36 :velocity => 648.667904, duration => 0.889826
 35 :velocity => 630.649351, duration => 0.884393
 34 :velocity => 612.630798, duration => 0.878837
 33 :velocity => 594.612245, duration => 0.873152
 32 :velocity => 576.593692, duration => 0.867330
 31 :velocity => 558.575139, duration => 0.861364
 30 :velocity => 540.556586, duration => 0.855245
 29 :velocity => 522.538033, duration => 0.848965
 28 :velocity => 504.519481, duration => 0.842513
 27 :velocity => 486.500928, duration => 0.835878
 26 :velocity => 468.482375, duration => 0.829048
 25 :velocity => 450.463822, duration => 0.822009
 24 :velocity => 432.445269, duration => 0.814746
 23 :velocity => 414.426716, duration => 0.807242
 22 :velocity => 396.408163, duration => 0.799478
 21 :velocity => 378.389610, duration => 0.791433
 20 :velocity => 360.371058, duration => 0.783083
 19 :velocity => 342.352505, duration => 0.774399
 18 :velocity => 324.333952, duration => 0.765349
 17 :velocity => 306.315399, duration => 0.755898
 16 :velocity => 288.296846, duration => 0.746000
 15 :velocity => 270.278293, duration => 0.735606
 14 :velocity => 252.259740, duration => 0.724655
 13 :velocity => 234.241187, duration => 0.713073
 12 :velocity => 216.222635, duration => 0.700772
 11 :velocity => 198.204082, duration => 0.687640
 10 :velocity => 180.185529, duration => 0.673538
 9 :velocity => 162.166976, duration => 0.658285
 8 :velocity => 144.148423, duration => 0.641643
 7 :velocity => 126.129870, duration => 0.623284
 6 :velocity => 108.111317, duration => 0.602742
 5 :velocity => 90.092764, duration => 0.579318
 4 :velocity => 72.074212, duration => 0.551884
 */

/** 내가 만든 알고리즘. 구형.
 double distanceForVelocity(double v);
 double durationForVelocity(double v);

539 :velocity => 9712.000000, duration => 1.602575
538 :velocity => 9691.746276, duration => 1.601767
537 :velocity => 9671.500861, duration => 1.600959
536 :velocity => 9651.263755, duration => 1.600149
535 :velocity => 9631.034959, duration => 1.599338
534 :velocity => 9610.814471, duration => 1.598526
533 :velocity => 9590.602293, duration => 1.597713
532 :velocity => 9570.398424, duration => 1.596899
531 :velocity => 9550.202864, duration => 1.596084
530 :velocity => 9530.015614, duration => 1.595268
529 :velocity => 9509.836672, duration => 1.594450
528 :velocity => 9489.666040, duration => 1.593631
527 :velocity => 9469.503717, duration => 1.592812
526 :velocity => 9449.349703, duration => 1.591991
525 :velocity => 9429.203998, duration => 1.591169
524 :velocity => 9409.066603, duration => 1.590345
523 :velocity => 9388.937516, duration => 1.589521
522 :velocity => 9368.816739, duration => 1.588696
521 :velocity => 9348.704271, duration => 1.587869
520 :velocity => 9328.600113, duration => 1.587041
519 :velocity => 9308.504263, duration => 1.586212
518 :velocity => 9288.416723, duration => 1.585382
517 :velocity => 9268.337491, duration => 1.584551
516 :velocity => 9248.266569, duration => 1.583718
515 :velocity => 9228.203957, duration => 1.582885
514 :velocity => 9208.149653, duration => 1.582050
513 :velocity => 9188.103658, duration => 1.581214
512 :velocity => 9168.065973, duration => 1.580377
511 :velocity => 9148.036597, duration => 1.579538
510 :velocity => 9128.015530, duration => 1.578699
509 :velocity => 9108.002773, duration => 1.577858
508 :velocity => 9087.998324, duration => 1.577016
507 :velocity => 9068.002185, duration => 1.576173
506 :velocity => 9048.014355, duration => 1.575329
505 :velocity => 9028.034834, duration => 1.574483
504 :velocity => 9008.063622, duration => 1.573636
503 :velocity => 8988.100719, duration => 1.572788
502 :velocity => 8968.146126, duration => 1.571939
501 :velocity => 8948.199842, duration => 1.571088
500 :velocity => 8928.261867, duration => 1.570237
499 :velocity => 8908.332201, duration => 1.569384
498 :velocity => 8888.410844, duration => 1.568529
497 :velocity => 8868.497797, duration => 1.567674
496 :velocity => 8848.593058, duration => 1.566817
495 :velocity => 8828.696629, duration => 1.565959
494 :velocity => 8808.808509, duration => 1.565100
493 :velocity => 8788.928699, duration => 1.564239
492 :velocity => 8769.057197, duration => 1.563377
491 :velocity => 8749.194005, duration => 1.562514
490 :velocity => 8729.339122, duration => 1.561650
489 :velocity => 8709.492548, duration => 1.560784
488 :velocity => 8689.654283, duration => 1.559917
487 :velocity => 8669.824327, duration => 1.559049
486 :velocity => 8650.002681, duration => 1.558180
485 :velocity => 8630.189344, duration => 1.557309
484 :velocity => 8610.384316, duration => 1.556437
483 :velocity => 8590.587597, duration => 1.555563
482 :velocity => 8570.799187, duration => 1.554688
481 :velocity => 8551.019087, duration => 1.553812
480 :velocity => 8531.247295, duration => 1.552935
479 :velocity => 8511.483813, duration => 1.552056
478 :velocity => 8491.728640, duration => 1.551176
477 :velocity => 8471.981776, duration => 1.550294
476 :velocity => 8452.243222, duration => 1.549412
475 :velocity => 8432.512977, duration => 1.548527
474 :velocity => 8412.791040, duration => 1.547642
473 :velocity => 8393.077413, duration => 1.546755
472 :velocity => 8373.372096, duration => 1.545867
471 :velocity => 8353.675087, duration => 1.544977
470 :velocity => 8333.986388, duration => 1.544086
469 :velocity => 8314.305997, duration => 1.543194
468 :velocity => 8294.633916, duration => 1.542300
467 :velocity => 8274.970144, duration => 1.541405
466 :velocity => 8255.314682, duration => 1.540508
465 :velocity => 8235.667528, duration => 1.539610
464 :velocity => 8216.028684, duration => 1.538711
463 :velocity => 8196.398149, duration => 1.537810
462 :velocity => 8176.775923, duration => 1.536908
461 :velocity => 8157.162006, duration => 1.536004
460 :velocity => 8137.556399, duration => 1.535099
459 :velocity => 8117.959100, duration => 1.534193
458 :velocity => 8098.370111, duration => 1.533285
457 :velocity => 8078.789431, duration => 1.532376
456 :velocity => 8059.217060, duration => 1.531465
455 :velocity => 8039.652999, duration => 1.530552
454 :velocity => 8020.097246, duration => 1.529639
453 :velocity => 8000.549803, duration => 1.528724
452 :velocity => 7981.010669, duration => 1.527807
451 :velocity => 7961.479844, duration => 1.526889
450 :velocity => 7941.957328, duration => 1.525969
449 :velocity => 7922.443122, duration => 1.525048
448 :velocity => 7902.937225, duration => 1.524125
447 :velocity => 7883.439636, duration => 1.523201
446 :velocity => 7863.950358, duration => 1.522276
445 :velocity => 7844.469388, duration => 1.521348
444 :velocity => 7824.996727, duration => 1.520420
443 :velocity => 7805.532376, duration => 1.519490
442 :velocity => 7786.076334, duration => 1.518558
441 :velocity => 7766.628601, duration => 1.517625
440 :velocity => 7747.189177, duration => 1.516690
439 :velocity => 7727.758062, duration => 1.515753
438 :velocity => 7708.335257, duration => 1.514815
437 :velocity => 7688.920760, duration => 1.513876
436 :velocity => 7669.514573, duration => 1.512935
435 :velocity => 7650.116696, duration => 1.511992
434 :velocity => 7630.727127, duration => 1.511048
433 :velocity => 7611.345867, duration => 1.510102
432 :velocity => 7591.972917, duration => 1.509155
431 :velocity => 7572.608276, duration => 1.508206
430 :velocity => 7553.251944, duration => 1.507255
429 :velocity => 7533.903921, duration => 1.506303
428 :velocity => 7514.564208, duration => 1.505349
427 :velocity => 7495.232803, duration => 1.504394
426 :velocity => 7475.909708, duration => 1.503437
425 :velocity => 7456.594922, duration => 1.502478
424 :velocity => 7437.288445, duration => 1.501518
423 :velocity => 7417.990277, duration => 1.500556
422 :velocity => 7398.700419, duration => 1.499592
421 :velocity => 7379.418870, duration => 1.498627
420 :velocity => 7360.145630, duration => 1.497660
419 :velocity => 7340.880699, duration => 1.496691
418 :velocity => 7321.624077, duration => 1.495721
417 :velocity => 7302.375765, duration => 1.494749
416 :velocity => 7283.135761, duration => 1.493775
415 :velocity => 7263.904067, duration => 1.492800
414 :velocity => 7244.680682, duration => 1.491822
413 :velocity => 7225.465606, duration => 1.490844
412 :velocity => 7206.258840, duration => 1.489863
411 :velocity => 7187.060382, duration => 1.488881
410 :velocity => 7167.870234, duration => 1.487896
409 :velocity => 7148.688395, duration => 1.486911
408 :velocity => 7129.514865, duration => 1.485923
407 :velocity => 7110.349645, duration => 1.484934
406 :velocity => 7091.192733, duration => 1.483942
405 :velocity => 7072.044131, duration => 1.482950
404 :velocity => 7052.903838, duration => 1.481955
403 :velocity => 7033.771854, duration => 1.480958
402 :velocity => 7014.648179, duration => 1.479960
401 :velocity => 6995.532814, duration => 1.478960
400 :velocity => 6976.425757, duration => 1.477958
399 :velocity => 6957.327010, duration => 1.476954
398 :velocity => 6938.236572, duration => 1.475949
397 :velocity => 6919.154443, duration => 1.474941
396 :velocity => 6900.080624, duration => 1.473932
395 :velocity => 6881.015113, duration => 1.472921
394 :velocity => 6861.957912, duration => 1.471908
393 :velocity => 6842.909020, duration => 1.470893
392 :velocity => 6823.868437, duration => 1.469876
391 :velocity => 6804.836164, duration => 1.468857
390 :velocity => 6785.812199, duration => 1.467837
389 :velocity => 6766.796544, duration => 1.466814
388 :velocity => 6747.789198, duration => 1.465790
387 :velocity => 6728.790161, duration => 1.464763
386 :velocity => 6709.799433, duration => 1.463735
385 :velocity => 6690.817014, duration => 1.462705
384 :velocity => 6671.842905, duration => 1.461673
383 :velocity => 6652.877105, duration => 1.460639
382 :velocity => 6633.919614, duration => 1.459603
381 :velocity => 6614.970432, duration => 1.458565
380 :velocity => 6596.029560, duration => 1.457525
379 :velocity => 6577.096996, duration => 1.456483
378 :velocity => 6558.172742, duration => 1.455438
377 :velocity => 6539.256797, duration => 1.454392
376 :velocity => 6520.349161, duration => 1.453344
375 :velocity => 6501.449834, duration => 1.452294
374 :velocity => 6482.558817, duration => 1.451242
373 :velocity => 6463.676108, duration => 1.450188
372 :velocity => 6444.801709, duration => 1.449132
371 :velocity => 6425.935619, duration => 1.448073
370 :velocity => 6407.077839, duration => 1.447013
369 :velocity => 6388.228367, duration => 1.445950
368 :velocity => 6369.387205, duration => 1.444886
367 :velocity => 6350.554352, duration => 1.443819
366 :velocity => 6331.729808, duration => 1.442750
365 :velocity => 6312.913573, duration => 1.441679
364 :velocity => 6294.105647, duration => 1.440606
363 :velocity => 6275.306031, duration => 1.439531
362 :velocity => 6256.514723, duration => 1.438453
361 :velocity => 6237.731725, duration => 1.437374
360 :velocity => 6218.957037, duration => 1.436292
359 :velocity => 6200.190657, duration => 1.435208
358 :velocity => 6181.432586, duration => 1.434122
357 :velocity => 6162.682825, duration => 1.433033
356 :velocity => 6143.941373, duration => 1.431943
355 :velocity => 6125.208230, duration => 1.430850
354 :velocity => 6106.483396, duration => 1.429755
353 :velocity => 6087.766872, duration => 1.428658
352 :velocity => 6069.058656, duration => 1.427558
351 :velocity => 6050.358750, duration => 1.426456
350 :velocity => 6031.667153, duration => 1.425352
349 :velocity => 6012.983865, duration => 1.424245
348 :velocity => 5994.308887, duration => 1.423137
347 :velocity => 5975.642217, duration => 1.422025
346 :velocity => 5956.983857, duration => 1.420912
345 :velocity => 5938.333806, duration => 1.419796
344 :velocity => 5919.692064, duration => 1.418678
343 :velocity => 5901.058631, duration => 1.417558
342 :velocity => 5882.433508, duration => 1.416435
341 :velocity => 5863.816693, duration => 1.415309
340 :velocity => 5845.208188, duration => 1.414182
339 :velocity => 5826.607992, duration => 1.413051
338 :velocity => 5808.016106, duration => 1.411919
337 :velocity => 5789.432528, duration => 1.410784
336 :velocity => 5770.857260, duration => 1.409646
335 :velocity => 5752.290300, duration => 1.408507
334 :velocity => 5733.731650, duration => 1.407364
333 :velocity => 5715.181310, duration => 1.406219
332 :velocity => 5696.639278, duration => 1.405072
331 :velocity => 5678.105555, duration => 1.403922
330 :velocity => 5659.580142, duration => 1.402769
329 :velocity => 5641.063038, duration => 1.401614
328 :velocity => 5622.554243, duration => 1.400457
327 :velocity => 5604.053757, duration => 1.399297
326 :velocity => 5585.561581, duration => 1.398134
325 :velocity => 5567.077714, duration => 1.396969
324 :velocity => 5548.602155, duration => 1.395801
323 :velocity => 5530.134907, duration => 1.394630
322 :velocity => 5511.675967, duration => 1.393457
321 :velocity => 5493.225336, duration => 1.392281
320 :velocity => 5474.783015, duration => 1.391102
319 :velocity => 5456.349003, duration => 1.389921
318 :velocity => 5437.923299, duration => 1.388737
317 :velocity => 5419.505906, duration => 1.387550
316 :velocity => 5401.096821, duration => 1.386361
315 :velocity => 5382.696046, duration => 1.385169
314 :velocity => 5364.303579, duration => 1.383974
313 :velocity => 5345.919422, duration => 1.382776
312 :velocity => 5327.543574, duration => 1.381576
311 :velocity => 5309.176036, duration => 1.380373
310 :velocity => 5290.816806, duration => 1.379166
309 :velocity => 5272.465886, duration => 1.377958
308 :velocity => 5254.123274, duration => 1.376746
307 :velocity => 5235.788973, duration => 1.375531
306 :velocity => 5217.462980, duration => 1.374314
305 :velocity => 5199.145296, duration => 1.373093
304 :velocity => 5180.835922, duration => 1.371870
303 :velocity => 5162.534856, duration => 1.370643
302 :velocity => 5144.242100, duration => 1.369414
301 :velocity => 5125.957654, duration => 1.368182
300 :velocity => 5107.681516, duration => 1.366947
299 :velocity => 5089.413687, duration => 1.365709
298 :velocity => 5071.154168, duration => 1.364467
297 :velocity => 5052.902958, duration => 1.363223
296 :velocity => 5034.660057, duration => 1.361976
295 :velocity => 5016.425465, duration => 1.360725
294 :velocity => 4998.199183, duration => 1.359472
293 :velocity => 4979.981209, duration => 1.358215
292 :velocity => 4961.771545, duration => 1.356955
291 :velocity => 4943.570190, duration => 1.355693
290 :velocity => 4925.377145, duration => 1.354427
289 :velocity => 4907.192408, duration => 1.353157
288 :velocity => 4889.015980, duration => 1.351885
287 :velocity => 4870.847862, duration => 1.350609
286 :velocity => 4852.688053, duration => 1.349330
285 :velocity => 4834.536553, duration => 1.348048
284 :velocity => 4816.393363, duration => 1.346763
283 :velocity => 4798.258481, duration => 1.345474
282 :velocity => 4780.131909, duration => 1.344182
281 :velocity => 4762.013646, duration => 1.342887
280 :velocity => 4743.903692, duration => 1.341588
279 :velocity => 4725.802047, duration => 1.340286
278 :velocity => 4707.708712, duration => 1.338980
277 :velocity => 4689.623685, duration => 1.337671
276 :velocity => 4671.546968, duration => 1.336359
275 :velocity => 4653.478560, duration => 1.335043
274 :velocity => 4635.418461, duration => 1.333723
273 :velocity => 4617.366672, duration => 1.332400
272 :velocity => 4599.323191, duration => 1.331074
271 :velocity => 4581.288020, duration => 1.329744
270 :velocity => 4563.261158, duration => 1.328410
269 :velocity => 4545.242605, duration => 1.327073
268 :velocity => 4527.232361, duration => 1.325732
267 :velocity => 4509.230427, duration => 1.324388
266 :velocity => 4491.236801, duration => 1.323040
265 :velocity => 4473.251485, duration => 1.321688
264 :velocity => 4455.274478, duration => 1.320332
263 :velocity => 4437.305781, duration => 1.318973
262 :velocity => 4419.345392, duration => 1.317610
261 :velocity => 4401.393313, duration => 1.316243
260 :velocity => 4383.449542, duration => 1.314872
259 :velocity => 4365.514081, duration => 1.313498
258 :velocity => 4347.586930, duration => 1.312119
257 :velocity => 4329.668087, duration => 1.310737
256 :velocity => 4311.757554, duration => 1.309351
255 :velocity => 4293.855329, duration => 1.307961
254 :velocity => 4275.961414, duration => 1.306567
253 :velocity => 4258.075808, duration => 1.305168
252 :velocity => 4240.198512, duration => 1.303766
251 :velocity => 4222.329524, duration => 1.302360
250 :velocity => 4204.468846, duration => 1.300950
249 :velocity => 4186.616477, duration => 1.299535
248 :velocity => 4168.772417, duration => 1.298117
247 :velocity => 4150.936666, duration => 1.296694
246 :velocity => 4133.109224, duration => 1.295267
245 :velocity => 4115.290092, duration => 1.293836
244 :velocity => 4097.479269, duration => 1.292400
243 :velocity => 4079.676755, duration => 1.290960
242 :velocity => 4061.882550, duration => 1.289516
241 :velocity => 4044.096654, duration => 1.288068
240 :velocity => 4026.319068, duration => 1.286615
239 :velocity => 4008.549790, duration => 1.285158
238 :velocity => 3990.788822, duration => 1.283696
237 :velocity => 3973.036164, duration => 1.282230
236 :velocity => 3955.291814, duration => 1.280759
235 :velocity => 3937.555773, duration => 1.279284
234 :velocity => 3919.828042, duration => 1.277804
233 :velocity => 3902.108620, duration => 1.276320
232 :velocity => 3884.397507, duration => 1.274831
231 :velocity => 3866.694703, duration => 1.273337
230 :velocity => 3849.000208, duration => 1.271838
229 :velocity => 3831.314023, duration => 1.270335
228 :velocity => 3813.636147, duration => 1.268827
227 :velocity => 3795.966580, duration => 1.267314
226 :velocity => 3778.305322, duration => 1.265796
225 :velocity => 3760.652373, duration => 1.264274
224 :velocity => 3743.007734, duration => 1.262746
223 :velocity => 3725.371404, duration => 1.261214
222 :velocity => 3707.743382, duration => 1.259676
221 :velocity => 3690.123671, duration => 1.258133
220 :velocity => 3672.512268, duration => 1.256586
219 :velocity => 3654.909174, duration => 1.255033
218 :velocity => 3637.314390, duration => 1.253475
217 :velocity => 3619.727915, duration => 1.251912
216 :velocity => 3602.149749, duration => 1.250343
215 :velocity => 3584.579892, duration => 1.248769
214 :velocity => 3567.018344, duration => 1.247190
213 :velocity => 3549.465106, duration => 1.245606
212 :velocity => 3531.920177, duration => 1.244016
211 :velocity => 3514.383557, duration => 1.242420
210 :velocity => 3496.855246, duration => 1.240819
209 :velocity => 3479.335244, duration => 1.239213
208 :velocity => 3461.823552, duration => 1.237601
207 :velocity => 3444.320168, duration => 1.235983
206 :velocity => 3426.825094, duration => 1.234360
205 :velocity => 3409.338329, duration => 1.232730
204 :velocity => 3391.859874, duration => 1.231095
203 :velocity => 3374.389727, duration => 1.229455
202 :velocity => 3356.927890, duration => 1.227808
201 :velocity => 3339.474362, duration => 1.226155
200 :velocity => 3322.029143, duration => 1.224496
199 :velocity => 3304.592233, duration => 1.222832
198 :velocity => 3287.163632, duration => 1.221161
197 :velocity => 3269.743341, duration => 1.219484
196 :velocity => 3252.331359, duration => 1.217800
195 :velocity => 3234.927685, duration => 1.216111
194 :velocity => 3217.532322, duration => 1.214415
193 :velocity => 3200.145267, duration => 1.212713
192 :velocity => 3182.766521, duration => 1.211004
191 :velocity => 3165.396085, duration => 1.209289
190 :velocity => 3148.033958, duration => 1.207567
189 :velocity => 3130.680140, duration => 1.205839
188 :velocity => 3113.334631, duration => 1.204104
187 :velocity => 3095.997432, duration => 1.202362
186 :velocity => 3078.668541, duration => 1.200613
185 :velocity => 3061.347960, duration => 1.198858
184 :velocity => 3044.035688, duration => 1.197096
183 :velocity => 3026.731725, duration => 1.195326
182 :velocity => 3009.436072, duration => 1.193550
181 :velocity => 2992.148727, duration => 1.191766
180 :velocity => 2974.869692, duration => 1.189976
179 :velocity => 2957.598966, duration => 1.188178
178 :velocity => 2940.336549, duration => 1.186372
177 :velocity => 2923.082441, duration => 1.184560
176 :velocity => 2905.836643, duration => 1.182740
175 :velocity => 2888.599154, duration => 1.180912
174 :velocity => 2871.369974, duration => 1.179076
173 :velocity => 2854.149103, duration => 1.177233
172 :velocity => 2836.936541, duration => 1.175383
171 :velocity => 2819.732288, duration => 1.173524
170 :velocity => 2802.536345, duration => 1.171657
169 :velocity => 2785.348711, duration => 1.169783
168 :velocity => 2768.169386, duration => 1.167900
167 :velocity => 2750.998370, duration => 1.166009
166 :velocity => 2733.835663, duration => 1.164110
165 :velocity => 2716.681266, duration => 1.162202
164 :velocity => 2699.535178, duration => 1.160286
163 :velocity => 2682.397398, duration => 1.158362
162 :velocity => 2665.267929, duration => 1.156428
161 :velocity => 2648.146768, duration => 1.154487
160 :velocity => 2631.033916, duration => 1.152536
159 :velocity => 2613.929374, duration => 1.150576
158 :velocity => 2596.833141, duration => 1.148608
157 :velocity => 2579.745217, duration => 1.146630
156 :velocity => 2562.665602, duration => 1.144643
155 :velocity => 2545.594297, duration => 1.142647
154 :velocity => 2528.531300, duration => 1.140641
153 :velocity => 2511.476613, duration => 1.138626
152 :velocity => 2494.430235, duration => 1.136602
151 :velocity => 2477.392166, duration => 1.134567
150 :velocity => 2460.362406, duration => 1.132523
149 :velocity => 2443.340956, duration => 1.130469
148 :velocity => 2426.327815, duration => 1.128404
147 :velocity => 2409.322983, duration => 1.126330
146 :velocity => 2392.326460, duration => 1.124245
145 :velocity => 2375.338246, duration => 1.122150
144 :velocity => 2358.358341, duration => 1.120044
143 :velocity => 2341.386746, duration => 1.117928
142 :velocity => 2324.423460, duration => 1.115800
141 :velocity => 2307.468483, duration => 1.113662
140 :velocity => 2290.521815, duration => 1.111513
139 :velocity => 2273.583457, duration => 1.109352
138 :velocity => 2256.653407, duration => 1.107180
137 :velocity => 2239.731667, duration => 1.104997
136 :velocity => 2222.818236, duration => 1.102802
135 :velocity => 2205.913114, duration => 1.100595
134 :velocity => 2189.016302, duration => 1.098377
133 :velocity => 2172.127798, duration => 1.096146
132 :velocity => 2155.247604, duration => 1.093903
131 :velocity => 2138.375719, duration => 1.091647
130 :velocity => 2121.512143, duration => 1.089379
129 :velocity => 2104.656876, duration => 1.087098
128 :velocity => 2087.809918, duration => 1.084804
127 :velocity => 2070.971270, duration => 1.082498
126 :velocity => 2054.140931, duration => 1.080177
125 :velocity => 2037.318901, duration => 1.077844
124 :velocity => 2020.505180, duration => 1.075497
123 :velocity => 2003.699769, duration => 1.073136
122 :velocity => 1986.902666, duration => 1.070761
121 :velocity => 1970.113873, duration => 1.068371
120 :velocity => 1953.333389, duration => 1.065968
119 :velocity => 1936.561214, duration => 1.063549
118 :velocity => 1919.797348, duration => 1.061116
117 :velocity => 1903.041792, duration => 1.058668
116 :velocity => 1886.294545, duration => 1.056204
115 :velocity => 1869.555607, duration => 1.053725
114 :velocity => 1852.824978, duration => 1.051230
113 :velocity => 1836.102658, duration => 1.048719
112 :velocity => 1819.388647, duration => 1.046192
111 :velocity => 1802.682946, duration => 1.043649
110 :velocity => 1785.985554, duration => 1.041088
109 :velocity => 1769.296471, duration => 1.038511
108 :velocity => 1752.615697, duration => 1.035916
107 :velocity => 1735.943232, duration => 1.033304
106 :velocity => 1719.279077, duration => 1.030674
105 :velocity => 1702.623231, duration => 1.028026
104 :velocity => 1685.975694, duration => 1.025359
103 :velocity => 1669.336466, duration => 1.022674
102 :velocity => 1652.705547, duration => 1.019969
101 :velocity => 1636.082938, duration => 1.017245
100 :velocity => 1619.468637, duration => 1.014502
99 :velocity => 1602.862646, duration => 1.011738
98 :velocity => 1586.264964, duration => 1.008954
97 :velocity => 1569.675592, duration => 1.006149
96 :velocity => 1553.094528, duration => 1.003323
95 :velocity => 1536.521774, duration => 1.000476
94 :velocity => 1519.957328, duration => 0.997607
93 :velocity => 1503.401192, duration => 0.994715
92 :velocity => 1486.853366, duration => 0.991800
91 :velocity => 1470.313848, duration => 0.988863
90 :velocity => 1453.782640, duration => 0.985901
89 :velocity => 1437.259740, duration => 0.982916
88 :velocity => 1420.745150, duration => 0.979906
87 :velocity => 1404.238869, duration => 0.976871
86 :velocity => 1387.740898, duration => 0.973811
85 :velocity => 1371.251235, duration => 0.970724
84 :velocity => 1354.769882, duration => 0.967611
83 :velocity => 1338.296838, duration => 0.964471
82 :velocity => 1321.832103, duration => 0.961303
81 :velocity => 1305.375677, duration => 0.958107
80 :velocity => 1288.927560, duration => 0.954882
79 :velocity => 1272.487753, duration => 0.951628
78 :velocity => 1256.056255, duration => 0.948343
77 :velocity => 1239.633066, duration => 0.945028
76 :velocity => 1223.218186, duration => 0.941681
75 :velocity => 1206.811615, duration => 0.938301
74 :velocity => 1190.413354, duration => 0.934889
73 :velocity => 1174.023402, duration => 0.931443
72 :velocity => 1157.641759, duration => 0.927963
71 :velocity => 1141.268425, duration => 0.924447
70 :velocity => 1124.903400, duration => 0.920894
69 :velocity => 1108.546684, duration => 0.917305
68 :velocity => 1092.198278, duration => 0.913678
67 :velocity => 1075.858181, duration => 0.910011
66 :velocity => 1059.526393, duration => 0.906304
65 :velocity => 1043.202914, duration => 0.902557
64 :velocity => 1026.887745, duration => 0.898766
63 :velocity => 1010.580884, duration => 0.894933
62 :velocity => 994.282333, duration => 0.891055
61 :velocity => 977.992091, duration => 0.887131
60 :velocity => 961.710158, duration => 0.883160
59 :velocity => 945.436535, duration => 0.879140
58 :velocity => 929.171220, duration => 0.875071
57 :velocity => 912.914215, duration => 0.870950
56 :velocity => 896.665519, duration => 0.866776
55 :velocity => 880.425132, duration => 0.862547
54 :velocity => 864.193054, duration => 0.858262
53 :velocity => 847.969286, duration => 0.853919
52 :velocity => 831.753826, duration => 0.849516
51 :velocity => 815.546676, duration => 0.845050
50 :velocity => 799.347835, duration => 0.840520
49 :velocity => 783.157303, duration => 0.835924
48 :velocity => 766.975081, duration => 0.831259
47 :velocity => 750.801167, duration => 0.826523
46 :velocity => 734.635563, duration => 0.821712
45 :velocity => 718.478268, duration => 0.816825
44 :velocity => 702.329282, duration => 0.811858
43 :velocity => 686.188606, duration => 0.806808
42 :velocity => 670.056238, duration => 0.801671
41 :velocity => 653.932180, duration => 0.796445
40 :velocity => 637.816431, duration => 0.791125
39 :velocity => 621.708991, duration => 0.785708
38 :velocity => 605.609860, duration => 0.780188
37 :velocity => 589.519039, duration => 0.774561
36 :velocity => 573.436526, duration => 0.768822
35 :velocity => 557.362323, duration => 0.762966
34 :velocity => 541.296429, duration => 0.756987
33 :velocity => 525.238844, duration => 0.750878
32 :velocity => 509.189569, duration => 0.744633
31 :velocity => 493.148602, duration => 0.738244
30 :velocity => 477.115945, duration => 0.731703
29 :velocity => 461.091597, duration => 0.725001
28 :velocity => 445.075558, duration => 0.718129
27 :velocity => 429.067828, duration => 0.711075
26 :velocity => 413.068408, duration => 0.703828
25 :velocity => 397.077297, duration => 0.696376
24 :velocity => 381.094495, duration => 0.688703
23 :velocity => 365.120002, duration => 0.680793
22 :velocity => 349.153818, duration => 0.672629
21 :velocity => 333.195943, duration => 0.664189
20 :velocity => 317.246378, duration => 0.655452
19 :velocity => 301.305122, duration => 0.646390
18 :velocity => 285.372175, duration => 0.636973
17 :velocity => 269.447537, duration => 0.627168
16 :velocity => 253.531208, duration => 0.616932
15 :velocity => 237.623189, duration => 0.606220
14 :velocity => 221.723479, duration => 0.594974
13 :velocity => 205.832078, duration => 0.583126
12 :velocity => 189.948986, duration => 0.570594
11 :velocity => 174.074203, duration => 0.557276
10 :velocity => 158.207730, duration => 0.543045
9 :velocity => 142.349565, duration => 0.527736
8 :velocity => 126.499710, duration => 0.511132
7 :velocity => 110.658164, duration => 0.492939
6 :velocity => 94.824928, duration => 0.472740
5 :velocity => 79.000000, duration => 0.449916
4 :velocity => 63.183382, duration => 0.423476
*/

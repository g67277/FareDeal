//
//  TTCounterLabel.m
//  TTCounterLabel
//
//  Created by Ross Gibson on 10/10/2013.
//  Copyright (c) 2013 Triggertrap. All rights reserved.
//

#import "TTCounterLabel.h"

@interface TTCounterLabel () {
    
}

@property (strong, nonatomic) NSString *valueString;
@property (strong, nonatomic) NSTimer *clockTimer;
@property (nonatomic, assign) unsigned long long value;
@property (nonatomic, assign) unsigned long long resetValue;
@property (nonatomic, assign) double startTime;
@property (nonatomic, assign) BOOL running;

@end

@implementation TTCounterLabel

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    // Initialization code
    self.valueString = @"";
    self.textAlignment = NSTextAlignmentCenter;
    /*self.font = [UIFont systemFontOfSize:55];
    self.boldFont = [UIFont boldSystemFontOfSize:55];
    self.regularFont = [UIFont systemFontOfSize:55];*/
    self.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
    self.boldFont = [UIFont fontWithName:@"AvenirNext-Bold" size:14];
    self.regularFont = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
    self.countDirection = kCountDirectionUp;
    self.value = 0;
    self.startValue = 0;
}

#pragma mark - Setters

- (void)setValue:(unsigned long long)value {
    
    if (value < ULONG_LONG_MAX) {
        _value = value;
        self.currentValue = _value;
        [self updateDisplay];
    }
    
    //No need to check for greater than ULONG_LONG_MAX due to the fact that the largest number a user can enter is
    //99h59m59s = 360000000, ULONG_LONG_MAX is 18446744073709551615 (depends on library and system) and also this number should not be shown
    
    //Checking with negative numbers is also unnecessary due to the fact that value is passed unsigned
}

- (void)setStartValue:(unsigned long long)startValue {
    if (startValue < ULONG_LONG_MAX) {
        _startValue = startValue;
        self.resetValue = _startValue;
        [self setValue:startValue];
    } else {
        // The value is negative, or too large
        NSLog(@"Invalid value: startValue of %llu is invalid, either negative or too large", startValue);
        
        NSLog(@"Setting startValue to the max value of ULONG_LONG_MAX - 1");
        _startValue = (ULONG_LONG_MAX - 1);
        self.resetValue = _startValue;
        [self setValue:startValue];
    }
}

#pragma mark - Private

- (void)updateDisplay {
    // The control only displays the 10th of a millisecond, and 50 ms is enough to
    // ensure we see the last digit go to zero.
    if (self.countDirection == kCountDirectionDown && _value < 50 && self.isRunning) {
        [self stop];
        self.valueString = self.displayMode == kDisplayModeFull ? @"00s.00" : @"00s";
        
        // Inform any delegates
        if (self.countdownDelegate && [self.countdownDelegate respondsToSelector:@selector(countdownDidEndForSource:)]) {
            [self.countdownDelegate performSelector:@selector(countdownDidEndForSource:) withObject:self];
        }
    } else {
        self.valueString = [self timeFormattedStringForValue:_value];
    }
    
    __weak typeof(self) weakSelf = self;
    
    [self setText:self.valueString afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        unsigned long long msperhour = 3600000;
        unsigned long long hrs = weakSelf.value / msperhour;
        
        NSString *hoursString = [NSString stringWithFormat:@"%llu", hrs];
        
        NSUInteger hrsLength = hoursString.length;
        
        // Hours
        if (weakSelf.value > 3599999) {
            // The hours will be bold font, we need to set the font for the mins and secs
            CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)weakSelf.regularFont.fontName, weakSelf.regularFont.pointSize, NULL);
            
            if (font) {
                if (hrsLength > 2) {
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:NSMakeRange((hrsLength + 2), 2)];
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:NSMakeRange((hrsLength + 6), 2)];
                    CFRelease(font);
                } else {
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:NSMakeRange(4, 2)];
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:NSMakeRange(8, 2)];
                    CFRelease(font);
                }
            }
        }
        
        // Mins
        if (weakSelf.value > 59999) {
            // The mins will be bold font, we need to set the font for the secs
            CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)weakSelf.regularFont.fontName, weakSelf.regularFont.pointSize, NULL);
            
            if (font) {
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:NSMakeRange(4, 2)];
                CFRelease(font);
            }
        }
        // Remove bold font so all sections carrry the same weight
        CTFontRef boldFont = CTFontCreateWithName((__bridge CFStringRef)weakSelf.regularFont.fontName, weakSelf.regularFont.pointSize, NULL);
        
        if (boldFont) {
            if (hrsLength > 2) {
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)boldFont range:NSMakeRange(0, hrsLength)];
                CFRelease(boldFont);
            } else {
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)boldFont range:NSMakeRange(0, 2)];
                CFRelease(boldFont);
            }
        }
        
        return mutableAttributedString;
    }];
    
    [self setNeedsDisplay];
}

- (void)clockDidTick:(NSTimer *)timer {
    double currentTime = CFAbsoluteTimeGetCurrent();
    
    double elapsedTime = currentTime - self.startTime;
    
    // Convert the double to milliseconds
    unsigned long long milliSecs = (unsigned long long)(elapsedTime * 1000);
    
    if (self.countDirection == kCountDirectionDown) {
        //Only setValue if the value passed is a positive number or 0
        //Trying to pass negative value from subtracting two unsigned variables causes max unsigned long long to be passed
        if (_startValue >= milliSecs) {
            [self setValue:(_startValue - milliSecs)];
        }
    } else {
        [self setValue:(_startValue + milliSecs)];
    }
}

- (NSString *)timeFormattedStringForValue:(unsigned long long)value {
    unsigned long long msperhour = 3600000;
    unsigned long long mspermin = 60000;
    
    unsigned long long hrs = value / msperhour;
    unsigned long long mins = (value % msperhour) / mspermin;
    unsigned long long secs = ((value % msperhour) % mspermin) / 1000;
    unsigned long long frac = value % 1000 / 10;
    
    NSString *formattedString = @"";
    
    if (hrs == 0) {
        if (mins == 0) {
            formattedString = self.displayMode == kDisplayModeFull ? [NSString stringWithFormat:@"%02llus.%02llu", secs, frac] : [NSString stringWithFormat:@"00 : 00 : %02llu", secs];
        } else {
            formattedString = self.displayMode == kDisplayModeFull ? [NSString stringWithFormat:@"%02llum %02llus.%02llu", mins, secs, frac] : [NSString stringWithFormat:@"00 : %02llu : %02llu", mins, secs];
        }
    } else {
        formattedString = self.displayMode == kDisplayModeFull ? [NSString stringWithFormat:@"%02lluh %02llum %02llus.%02llu", hrs, mins, secs, frac] : [NSString stringWithFormat:@"%02llu : %02llu : %02llu", hrs, mins, secs];
    }
    
    return formattedString;
}

#pragma mark - Public

- (void)start {
    if (self.running) return;
    
    self.startTime = CFAbsoluteTimeGetCurrent();
    
    self.running = YES;
    self.isRunning = self.running;
    
    self.clockTimer = [NSTimer timerWithTimeInterval:0.02
                                              target:self
                                            selector:@selector(clockDidTick:)
                                            userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.clockTimer forMode:NSRunLoopCommonModes];
}

- (void)stop {
    if (self.clockTimer) {
        [self.clockTimer invalidate];
        self.clockTimer = nil;
        
        _startValue = self.value;
    }
    
    self.running = NO;
    self.isRunning = self.running;
}

- (void)reset {
    [self stop];
    
    self.startValue = self.resetValue;
    [self setValue:self.resetValue];
}

- (void)updateApperance {
    self.maximumLineHeight = self.regularFont.pointSize;
    [self setValue:_currentValue];
}

@end

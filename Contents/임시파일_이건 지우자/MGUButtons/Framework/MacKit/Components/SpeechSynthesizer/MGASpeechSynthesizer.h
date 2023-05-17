//
//  MGASpeechSynthesizer.h
//  SpeakLine
//
//  Created by Kwan Hyun Son on 2022/05/09.
//  Copyright © 2022 koni. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGASpeechSynthesizer : NSObject

// [self.speecher startSpeakingString:@"제기랄. 워매 잘나오냐?????~~~~~"];
- (BOOL)startSpeakingString:(NSString *)string;
- (void)stopSpeaking;

- (NSArray <NSSpeechSynthesizerVoiceName>*)tellMeAvailableVoices;
- (void)tellMeAttributesForAvailableVoices;

@end

NS_ASSUME_NONNULL_END

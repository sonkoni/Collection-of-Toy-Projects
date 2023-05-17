//
//  MGASpeechSynthesizer.m
//  SpeakLine
//
//  Created by Kwan Hyun Son on 2022/05/09.
//  Copyright © 2022 koni. All rights reserved.
//

#import "MGASpeechSynthesizer.h"

@interface MGASpeechSynthesizer () <NSSpeechSynthesizerDelegate>
@property (nonatomic, strong) NSSpeechSynthesizer *speechSynthesizer;
@end

@implementation MGASpeechSynthesizer

- (instancetype)init {
    self = [super init];
    if (self) {
        CommonInit(self);
    }
    return self;
}

static void CommonInit(MGASpeechSynthesizer *self) {
    self->_speechSynthesizer = [[NSSpeechSynthesizer alloc] initWithVoice:@"com.apple.speech.synthesis.voice.yuna"];
    self.speechSynthesizer.delegate = self;
}


#pragma mark - Action
- (BOOL)startSpeakingString:(NSString *)string {
    if([string length] == 0) {
        NSLog(@"string is zero-length");
        return NO;
    } else {
        return [self.speechSynthesizer startSpeakingString:string];
    }
}

- (void)stopSpeaking {
    [self.speechSynthesizer stopSpeaking];
}

#pragma mark - Description
- (NSArray <NSSpeechSynthesizerVoiceName>*)tellMeAvailableVoices {
    return [NSSpeechSynthesizer availableVoices];
}

- (void)tellMeAttributesForAvailableVoices {
    for (NSSpeechSynthesizerVoiceName voiceName in [self tellMeAvailableVoices]) {
        NSDictionary <NSVoiceAttributeKey, id>*dict = [NSSpeechSynthesizer attributesForVoice:voiceName];
        NSLog(@"--> %@", dict);
    }
    //
    // NSVoiceAttributeKey 에 해당.
    //  NSVoiceIdentifier
    //  NSVoiceName
    //  NSVoiceAge
    //  NSVoiceGender
    //  NSVoiceDemoText
    //  NSVoiceLocaleIdentifier
    //  NSVoiceSupportedCharacters
    //  NSVoiceIndividuallySpokenCharacters
}


#pragma mark - <NSSpeechSynthesizerDelegate>
- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender willSpeakWord:(NSRange)characterRange ofString:(NSString *)string {}
- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender willSpeakPhoneme:(short)phonemeOpcode {}
- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender didEncounterErrorAtIndex:(NSUInteger)characterIndex ofString:(NSString *)string message:(NSString *)message {}
- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender didEncounterSyncMessage:(NSString *)message {}
- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)finishedSpeaking {}
@end

/**
NSArray <NSSpeechSynthesizerVoiceName>*availableVoices = [NSSpeechSynthesizer availableVoices];
(
    "com.apple.speech.synthesis.voice.Alex",
    "com.apple.speech.synthesis.voice.alice",
    "com.apple.speech.synthesis.voice.alva",
    "com.apple.speech.synthesis.voice.amelie",
    "com.apple.speech.synthesis.voice.anna",
    "com.apple.speech.synthesis.voice.carmit",
    "com.apple.speech.synthesis.voice.damayanti",
    "com.apple.speech.synthesis.voice.daniel",
    "com.apple.speech.synthesis.voice.diego",
    "com.apple.speech.synthesis.voice.ellen",
    "com.apple.speech.synthesis.voice.fiona",
    "com.apple.speech.synthesis.voice.Fred",
    "com.apple.speech.synthesis.voice.ioana",
    "com.apple.speech.synthesis.voice.joana",
    "com.apple.speech.synthesis.voice.jorge",
    "com.apple.speech.synthesis.voice.juan",
    "com.apple.speech.synthesis.voice.kanya",
    "com.apple.speech.synthesis.voice.karen",
    "com.apple.speech.synthesis.voice.kyoko",
    "com.apple.speech.synthesis.voice.laura",
    "com.apple.speech.synthesis.voice.lekha",
    "com.apple.speech.synthesis.voice.luca",
    "com.apple.speech.synthesis.voice.luciana",
    "com.apple.speech.synthesis.voice.maged",
    "com.apple.speech.synthesis.voice.mariska",
    "com.apple.speech.synthesis.voice.meijia",
    "com.apple.speech.synthesis.voice.melina",
    "com.apple.speech.synthesis.voice.milena",
    "com.apple.speech.synthesis.voice.moira",
    "com.apple.speech.synthesis.voice.monica",
    "com.apple.speech.synthesis.voice.nora",
    "com.apple.speech.synthesis.voice.paulina",
    "com.apple.speech.synthesis.voice.rishi",
    "com.apple.speech.synthesis.voice.samantha",
    "com.apple.speech.synthesis.voice.sara",
    "com.apple.speech.synthesis.voice.satu",
    "com.apple.speech.synthesis.voice.sinji",
    "com.apple.speech.synthesis.voice.tessa",
    "com.apple.speech.synthesis.voice.thomas",
    "com.apple.speech.synthesis.voice.tingting",
    "com.apple.speech.synthesis.voice.veena",
    "com.apple.speech.synthesis.voice.Victoria",
    "com.apple.speech.synthesis.voice.xander",
    "com.apple.speech.synthesis.voice.yelda",
    "com.apple.speech.synthesis.voice.yuna",
    "com.apple.speech.synthesis.voice.yuri",
    "com.apple.speech.synthesis.voice.zosia",
    "com.apple.speech.synthesis.voice.zuzana"
)
*/

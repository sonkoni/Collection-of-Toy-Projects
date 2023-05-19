//
//  MacKit.h
//  ----------------------------------------------------------------------
//  Prefix : MGA
//  AppKit 에 대응하는 확장함수 및 클래스 제공
//  ----------------------------------------------------------------------
//

#import <Foundation/Foundation.h>

//! Project version number for MacKit.
FOUNDATION_EXPORT double MacKitVersionNumber;

//! Project version string for MacKit.
FOUNDATION_EXPORT const unsigned char MacKitVersionString[];

//! Assets
#import <MacKit/MGAAssets.h>

//! Extension
#import <MacKit/NSApplication+Extension.h>
#import <MacKit/NSBezierPath+Extension.h>
#import <MacKit/NSBox+Extension.h>
#import <MacKit/NSButton+Extension.h>
#import <MacKit/NSColor+Extension.h>
#import <MacKit/NSEvent+Extension.h>
#import <MacKit/NSFont+Extension.h>
#import <MacKit/NSFontManager+Extension.h>
#import <MacKit/NSHapticFeedbackManager+Extension.h>
#import <MacKit/NSImage+Extension.h>
#import <MacKit/NSMenu+Extension.h>
#import <MacKit/NSMenuItem+Extension.h>
#import <MacKit/NSOutlineView+Extension.h>
#import <MacKit/NSSplitViewController+Extension.h>
#import <MacKit/NSScrollView+Extension.h>
#import <MacKit/NSTableView+Extension.h>
#import <MacKit/NSCollectionViewDiffableDataSource+Extension.h>
#import <MacKit/NSTextField+Extension.h>
#import <MacKit/NSToolbar+Extension.h>
#import <MacKit/NSToolbarItem+Extension.h>
#import <MacKit/NSTreeController+Extension.h>
#import <MacKit/NSView+Extension.h>
#import <MacKit/NSViewController+Extension.h>
#import <MacKit/NSVisualEffectView+Extension.h>
#import <MacKit/NSWindow+Extension.h>
#import <MacKit/NSWorkspace+Extension.h>

//! Components
#import <MacKit/MGASoundStateListener.h>
#import <MacKit/MGAContentView.h>
#import <MacKit/MGAView.h>
#import <MacKit/MGALayerBackedView.h>
#import <MacKit/MGALayerHostingView.h>
#import <MacKit/MGALabel.h>
#import <MacKit/MGALabel+Extension.h>
#import <MacKit/MGATextField.h>
#import <MacKit/MGATextView.h>
#import <MacKit/MGAImageView.h>
#import <MacKit/MGAPopover.h>
#import <MacKit/MGASpeechSynthesizer.h>
#import <MacKit/MGAContextMenuButton.h>
#import <MacKit/MGADisclosurePopUpButton.h>
#import <MacKit/MGATempAlert.h>
#import <MacKit/MGADNSwitch.h>
#import <MacKit/MGASevenSwitch.h>
#import <MacKit/MGAButton.h>
#import <MacKit/MGAStepper.h>
#import <MacKit/MGAToolbar.h>
#import <MacKit/MGAShrinkButton.h>
#import <MacKit/MGAPopUpMenuItemContentView.h>
#import <MacKit/MGAPreferencePane.h>
#import <MacKit/MGAPreferencesWindowController.h>
#import <MacKit/MGAPreferencesStyleInterface.h>
#import <MacKit/MGATableGroupRowView.h>
#import <MacKit/MGATableItemRowView.h>
#import <MacKit/MGATableCellView.h>
#import <MacKit/MGASnippetsLabCell.h>
#import <MacKit/MGAReflectionView.h>
#import <MacKit/MGAScrollView.h>
#import <MacKit/MGACarouselView.h>


//! Helper
#import <MacKit/MGASystemPreferencesHelper.h>

// 
// Wire
// Copyright (C) 2016 Wire Swiss GmbH
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
// 


import XCTest
import Classy
import Cartography
@testable import Wire

@objc private class MockAudioRecordViewControllerDelegate: NSObject, AudioRecordViewControllerDelegate {
    
    var cancelCallCount: UInt = 0
    
    @objc func audioRecordViewControllerDidCancel(audioRecordViewController: AudioRecordBaseViewController) {
        cancelCallCount = cancelCallCount + 1
    }
    
    @objc func audioRecordViewControllerDidStartRecording(audioRecordViewController: AudioRecordBaseViewController) {}

    @objc func audioRecordViewControllerWantsToSendAudio(audioRecordViewController: AudioRecordBaseViewController, recordingURL: NSURL, duration: NSTimeInterval, context: AudioMessageContext, filter: AVSAudioEffectType) {}
}

@objc class AudioRecordViewControllerTests: ZMSnapshotTestCase {
    
    var sut: AudioRecordViewController!
    private var delegate: MockAudioRecordViewControllerDelegate!
    
    override func setUp() {
        super.setUp()
        accentColor = .StrongBlue
        sut = AudioRecordViewController()
        delegate = MockAudioRecordViewControllerDelegate()
        sut.delegate = delegate
        CASStyler.defaultStyler().styleItem(sut)
        sut.updateTimeLabel(123)
        sut.setOverlayState(.Default, animated: false)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testThatItRendersViewControllerCorrectlyState_Recording() {
        // when
        XCTAssertEqual(sut.recordingState, AudioRecordState.Recording)
        
        // then
        verifyInAllPhoneWidths(view: sut.prepareForSnapshot())
    }
    
    func testThatItRendersViewControllerCorrectlyState_Recording_WithTime() {
        // when
        XCTAssertEqual(sut.recordingState, AudioRecordState.Recording)
        
        // then
        verifyInAllPhoneWidths(view: sut.prepareForSnapshot())
    }
    
    func testThatItRendersViewControllerCorrectlyState_Recording_WithTime_Visualization() {
        // when
        XCTAssertEqual(sut.recordingState, AudioRecordState.Recording)
        sut.updateTimeLabel(123)
        sut.audioPreviewView.updateWithLevel(0.2)
        sut.setOverlayState(.Expanded(0), animated: false)
        
        // then
        verifyInAllPhoneWidths(view: sut.prepareForSnapshot())
    }
    
    func testThatItRendersViewControllerCorrectlyState_Recording_WithTime_Visualization_Full() {
        // when
        XCTAssertEqual(sut.recordingState, AudioRecordState.Recording)
        sut.updateTimeLabel(123)
        sut.audioPreviewView.updateWithLevel(0.8)
        sut.setOverlayState(.Expanded(1), animated: false)
        
        // then
        verifyInAllPhoneWidths(view: sut.prepareForSnapshot())
    }
    
    func testThatItRendersViewControllerCorrectlyState_FinishedRecording() {
        // when
        sut.recordingState = .FinishedRecording
        
        // then
        verifyInAllPhoneWidths(view: sut.prepareForSnapshot())
    }
    
    func testThatItRendersViewControllerCorrectlyState_FinishedRecording_Playing() {
        // when
        sut.recordingState = .FinishedRecording
        sut.buttonOverlay.playingState = .Playing
        sut.updateTimeLabel(343)

        // then
        verifyInAllPhoneWidths(view: sut.prepareForSnapshot())
    }
        
    func testThatItCallsItsDelegateWhenCancelIsPressed() {
        // when
        sut.cancelButton.sendActionsForControlEvents(.TouchUpInside)
        
        // then
        XCTAssertEqual(delegate.cancelCallCount, 1)
    }
    
}


private extension UIViewController {
    private func prepareForSnapshot() -> UIView {
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
        
        let container = UIView()
        container.addSubview(view)
        
        constrain(view, container) { view, container in
            view.height == 112
            container.height == 130
            view.bottom == container.bottom
            view.left == container.left
            view.right == container.right
        }
        
        return container
    }
}

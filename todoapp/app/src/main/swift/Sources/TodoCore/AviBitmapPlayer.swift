
import Foundation
import java_swift
import JavaCoder

import Avi
import Swift_Android_Bitmap

public class Bitmap {
    let jniObject: jobject

    public init(jniObject: jobject) {
        self.jniObject = JNI.api.NewGlobalRef(JNI.env, jniObject)!
    }

    deinit {
        JNI.api.DeleteGlobalRef(JNI.env, jniObject)
    }

    // Create swift object
    public static func from(javaObject: jobject) throws -> Bitmap {
        return Bitmap(jniObject: javaObject)
    }

    // Create java object with native pointer
    public func javaObject() -> jobject {
        return jniObject
    }
}

public class AviBitmapPlayer {
    private let aviLib: AviLib

    private init() {
        aviLib = AviLib()
    }

    public static func create() -> AviBitmapPlayer {
        return AviBitmapPlayer()
    }

    public func open(_ aviFilePath: String) -> Bool {
        return aviLib.open(aviFilePath)
    }

    public func getWidth() -> Int32 {
        let width = aviLib.getWidth()
        // NSLog("width = \(width)")
        return width
    }

    public func getHeight() -> Int32 {
        let height = aviLib.getHeight()
        // NSLog("height = \(height)")
        return height
    }

    public func getFrameRate() -> Double {
        let frameRate: Double = aviLib.getFrameRate()
        // NSLog("frameRate = \(frameRate)")
        return frameRate
    }

    public func render(_ bitmap: Bitmap) -> Int {
        //
        let ppFrameBuffer: UnsafeMutablePointer<UnsafeMutableRawPointer?> = UnsafeMutablePointer<UnsafeMutableRawPointer?>.allocate(capacity: 1)
        defer {
            ppFrameBuffer.deallocate()
        }
        ppFrameBuffer.pointee = nil
        //
        var bytesReadedCount: Int = 0
        //
        let pKeyFrame: UnsafeMutablePointer<Int32> = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
        defer {
            pKeyFrame.deallocate()
        }
        pKeyFrame.pointee = 0
        //

        if AndroidBitmap.lockPixels(env: JNI.env, jbitmap: bitmap.javaObject(), addrPtr: ppFrameBuffer) == 0 {
            //
            let pFrameBuffer: UnsafeMutableRawPointer? = ppFrameBuffer.pointee
            /*
             defer {
                 pFrameBuffer?.deallocate()
             }
             */
            //
            if let pFrameBuffer = pFrameBuffer {
                // NSLog("pFrameBuffer = \(pFrameBuffer)")
                bytesReadedCount = aviLib.readFrame(vidbuf: pFrameBuffer.assumingMemoryBound(to: Int8.self), keyframe: pKeyFrame)

                // NSLog("bytesReadedCount = \(bytesReadedCount)")
            }

            if AndroidBitmap.unlockPixels(env: JNI.env, jbitmap: bitmap.javaObject()) == 0 {
                // success
                // NSLog("AndroidBitmap.unlockPixels success!")
            }
        }
        return bytesReadedCount
    }
}

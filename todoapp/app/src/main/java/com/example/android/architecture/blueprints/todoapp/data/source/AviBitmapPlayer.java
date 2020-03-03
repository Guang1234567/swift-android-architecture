package com.example.android.architecture.blueprints.todoapp.data.source;

import android.graphics.Bitmap;
import android.support.annotation.NonNull;

import com.readdle.codegen.anotation.SwiftReference;

@SwiftReference
public class AviBitmapPlayer {
    // Swift JNI private native pointer
    private long nativePointer = 0L;

    // Swift JNI private constructor
    // Should be private. Don't call this constructor from Java!
    private AviBitmapPlayer() {
    }

    // Swift JNI release method
    public native void release();

    @Override
    protected void finalize() throws Throwable {
        try {
            if (nativePointer != 0L) {
                release();
            }
        }
        finally {
            super.finalize();
        }
    }

    @NonNull
    public native static AviBitmapPlayer create();

    @NonNull
    public native Boolean open(@NonNull String aviFilePath);

    /**
     *
     * @param bitmap
     * @return bytesReadedCount
     */
    @NonNull
    public native Integer render(@NonNull Bitmap bitmap);

    @NonNull
    public native Integer getWidth();

    @NonNull
    public native Integer getHeight();

    @NonNull
    public native Double getFrameRate();
}

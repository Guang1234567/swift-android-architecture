package com.example.android.architecture.blueprints.todoapp.videoplayer;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Rect;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;

import com.example.android.architecture.blueprints.todoapp.R;
import com.example.android.architecture.blueprints.todoapp.data.source.AviBitmapPlayer;

import java.util.concurrent.atomic.AtomicBoolean;


public class AviBitmapPlayerActivity extends AppCompatActivity {

    private static final String TAG = "AviBitmapPlayer";

    private final AtomicBoolean mIsPlaying = new AtomicBoolean();

    private SurfaceHolder mSurfaceHolder;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_avi_bitmap_palyer);
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        FloatingActionButton fab = findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show();
            }
        });


        SurfaceView surfaceView = findViewById(R.id.surface_view);

        mSurfaceHolder = surfaceView.getHolder();

        mSurfaceHolder.addCallback(new SurfaceHolder.Callback() {

            private AviBitmapPlayer mPlayer;

            @Override
            public void surfaceCreated(SurfaceHolder holder) {
                mPlayer = AviBitmapPlayer.create();
                boolean status = mPlayer.open("/sdcard/galleon.avi");
                //boolean status = mPlayer.open("/sdcard/not_exist_file.avi");
                mIsPlaying.set(status);

                Log.i(TAG, "mPlayer.open() : status = " + status);
            }

            @Override
            public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {

                if (!mIsPlaying.get()) {
                    return;
                }

                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        final int width = mPlayer.getWidth();
                        final int height = mPlayer.getHeight();


                        Bitmap bitmap = Bitmap.createBitmap(
                                width,
                                height,
                                Bitmap.Config.RGB_565
                        );

                        Log.i(TAG, "java : mPlayer.getWidth() = " + width);
                        Log.i(TAG, "java : mPlayer.getHeight() = " + height);

                        double frameRate = mPlayer.getFrameRate();
                        Log.i(TAG, "java : frameRate = " + frameRate);
                        long frameDelay = (long) (1000 / frameRate);
                        Log.i(TAG, "java : frameDelay = " + frameDelay);

                        while (mIsPlaying.get()) {
                            long bytesReadedCount = mPlayer.render(bitmap);
                            if (bytesReadedCount < 1) {
                                mIsPlaying.set(false);
                            }
                            //Log.i(TAG, "java : bytesReadedCount = " + bytesReadedCount);
                            Canvas canvas = mSurfaceHolder.lockCanvas();
                            //Log.i(TAG, "java : canvas.getWidth() = " + canvas.getWidth());
                            //Log.i(TAG, "java : canvas.getHeight() = " + String.valueOf((int) ((double) height / width * canvas.getWidth())));
                            final Rect viewPort = new Rect(0, 0, canvas.getWidth(), (int) ((double) height / width * canvas.getWidth()));
                            final Rect bitmapRect = new Rect(0, 0, width, height);
                            canvas.drawBitmap(
                                    bitmap,
                                    bitmapRect,
                                    viewPort,
                                    null);
                            mSurfaceHolder.unlockCanvasAndPost(canvas);

                            try {
                                Thread.sleep(frameDelay);
                            } catch (Throwable tr) {
                                break;
                            }
                        }
                    }
                }).start();
            }

            @Override
            public void surfaceDestroyed(SurfaceHolder holder) {
                mIsPlaying.set(false);
                mPlayer.release();
            }
        });
    }
}

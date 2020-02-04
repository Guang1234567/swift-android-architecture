/*
 * Copyright 2016, The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.example.android.architecture.blueprints.todoapp.data.source;

import com.example.android.architecture.blueprints.todoapp.data.Task;
import com.readdle.codegen.anotation.SwiftFunc;
import com.readdle.codegen.anotation.SwiftReference;

import android.support.annotation.NonNull;

/**
 * Concrete implementation to load tasks from the data sources into a cache.
 * <p>
 * For simplicity, this implements a dumb synchronisation between locally persisted data and data
 * obtained from the server, by using the remote data source only if the local database doesn't
 * exist or is empty.
 *
 * //TODO: Implement this class using LiveData.
 */
@SwiftReference
public class TasksRepository implements TasksDataSource {

    // Swift JNI private native pointer
    private long nativePointer = 0L;

    // Swift JNI private constructor
    // Should be private. Don't call this constructor from Java!
    private TasksRepository() {
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

    /**
     * Returns the single instance of this class, creating it if necessary.
     *
     * @return the {@link TasksRepository} instance
     */
    @NonNull
    public native static TasksRepository getInstance();

    /**
     * Used to force {@link #getInstance()} to create a new instance
     * next time it's called.
     */
    public native static void destroyInstance();

    /**
     * Gets tasks from cache, local data source (SQLite) or remote data source, whichever is
     * available first.
     * <p>
     * Note: {@link LoadTasksCallback#onDataNotAvailable()} is fired if all data sources fail to
     * get the data.
     */
    @Override
    public native void getTasks(@NonNull final LoadTasksCallback callback);

    @Override
    public native void saveTask(@NonNull Task task);

    @Override
    public native void completeTask(@NonNull Task task);

    @Override
    public native void completeTaskWithId(@NonNull String taskId);

    @Override
    public native void activateTask(@NonNull Task task);

    @Override
    public native void activateTaskWithId(@NonNull String taskId);

    @Override
    public native void clearCompletedTasks();

    /**
     * Gets tasks from local data source (sqlite) unless the table is new or empty. In that case it
     * uses the network data source. This is done to simplify the sample.
     * <p>
     * Note: {@link GetTaskCallback#onDataNotAvailable()} is fired if both data sources fail to
     * get the data.
     */
    @Override
    public native void getTask(@NonNull final String taskId, @NonNull final GetTaskCallback callback);

    @Override
    public native void refreshTasks();

    @Override
    public native void deleteAllTasks();

    @Override
    public native void deleteTask(@NonNull String taskId);

}

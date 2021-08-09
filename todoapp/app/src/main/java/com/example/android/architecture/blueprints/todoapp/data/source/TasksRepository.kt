package com.example.android.architecture.blueprints.todoapp.data.source

import com.example.android.architecture.blueprints.todoapp.data.Task
import com.readdle.codegen.anotation.SwiftReference

@SwiftReference
class TasksRepository private constructor() : TasksDataSource {

    // Swift JNI private native pointer
    private val nativePointer = 0L

    // Swift JNI release method
    external fun release()

    companion object {
        @JvmStatic
        external fun init(): TasksRepository
    }

    external override fun getTasks(callback: LoadTasksCallback)

    external override fun getTask(taskId: String, callback: GetTaskCallback)

    external override fun saveTask(task: Task)

    external override fun completeTask(task: Task)

    external override fun completeTaskWithId(taskId: String)

    external override fun activateTask(task: Task)

    external override fun activateTaskWithId(taskId: String)

    external override fun clearCompletedTasks()

    external override fun refreshTasks()

    external override fun deleteAllTasks()

    external override fun deleteTask(taskId: String)
}


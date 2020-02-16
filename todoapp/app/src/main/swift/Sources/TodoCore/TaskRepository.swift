//
// Created by Andrew on 3/28/18.
//

import Foundation

import AndroidSwiftLogcat

import AndroidSwiftTrace

import Backtrace

import SQLite_swift_android

public protocol LoadTasksDelegate {
    func onTasksLoaded(_ tasks: [Task])

    func onDataNotAvailable()
}

public protocol GetTaskDelegate {
    func onTaskLoaded(_ task: Task)

    func onDataNotAvailable()
}

/**
 * Concrete implementation to load tasks from the data sources into a cache.
 * <p>
 * For simplicity, this implements a dumb synchronisation between locally persisted data and data
 * obtained from the server, by using the remote data source only if the local database doesn't
 * exist or is empty.
 *
 * //TODO: Implement this class using LiveData.
 */
public class TasksRepository {
    private static let TAG = "TasksRepository"

    private static var INSTANCE = TasksRepository()

    /**
     * This variable has package local visibility so it can be accessed from tests.
     */
    var mCachedTasks: [String: Task]?

    // Prevent direct instantiation.
    private init() {
        let snt1 = ScopedNativeTraceSection("android_swift_systrace_001")
        let snt2 = ScopedNativeTraceSection("android_swift_systrace_002")
        let snt3 = ScopedNativeTraceSection("android_swift_systrace_003")
        ScopedNativeTraceSection.beginTrace("android_swift_systrace_demo")

        AndroidLogcat.w(TasksRepository.TAG, "TasksRepository init !!!")
        Backtrace.install()
        Backtrace.print()
        AndroidLogcat.w(TasksRepository.TAG, "TasksRepository init !!!2222")
        // var crashExpected: String? = nil
        // crashExpected!.uppercased()
        AndroidLogcat.w(TasksRepository.TAG, "TasksRepository init !!!333")

        ScopedNativeTraceSection.endTrace("android_swift_systrace_demo")

        let db = SQLiteDB.shared
        let isOpened = db.open(dbPath: "/sdcard/test123.db")
        AndroidLogcat.w(TasksRepository.TAG, "isOpened = \(isOpened)")
        let category1 = Category()
        category1.name = "My New Category1"
        _ = category1.save()
        let category2 = Category()
        category2.name = "My New Category2"
        _ = category2.save()

        if let category = Category.rowBy(id: 1) {
            AndroidLogcat.w(TasksRepository.TAG, "Found category with ID = 1")
        }

        let array = Category.rows(filter: "id > 0")

        if let category = Category.rowBy(id: 1) {
            category.delete() // note: just set `isDeleted` field to `1`, not delete it really.
            AndroidLogcat.w(TasksRepository.TAG, "Deleted category with ID = 1")
        }

        db.transaction {
            let category = Category()
            category.name = "Transaction_Outter"
            _ = category.save()
            db.transaction {
                let category = Category()
                category.name = "Transaction_inner_1"
                _ = category.save()
                db.transaction {
                    let category = Category()
                    category.name = "Transaction_inner_1_1"
                    _ = category.save()

                    throw MyError.forTest
                }
            }

            db.transaction {
                let category = Category()
                category.name = "Transaction_inner_2"
                _ = category.save()
            }

            db.transaction { txn in
                txn.beginTransaction()
                do {
                    let category = Category()
                    category.name = "Transaction_inner_2"
                    _ = category.save()

                    txn.commit()
                } catch {
                    txn.rollback()
                }
            }
        }

        db.closeDB()
    }

    enum MyError: Error {
        case forTest
    }

    /**
     * Returns the single instance of this class, creating it if necessary.
     *
     * @return the {@link TasksRepository} instance
     */
    public static func getInstance() -> TasksRepository {
        return INSTANCE
    }

    /**
     * Used to force {@link #getInstance()} to create a new instance
     * next time it's called.
     */
    public static func destroyInstance() {
        // Do nothing
    }

    /**
     * Gets tasks from cache, local data source (SQLite) or remote data source, whichever is
     * available first.
     * <p>
     * Note: {@link LoadTasksCallback#onDataNotAvailable()} is fired if all data sources fail to
     * get the data.
     */
    public func getTasks(_ callback: LoadTasksDelegate) {
        // Respond immediately with cache if available and not dirty
        if let tasks = mCachedTasks?.values {
            callback.onTasksLoaded(Array(tasks))
        } else {
            callback.onTasksLoaded([])
        }
    }

    public func saveTask(_ task: Task) {
        // Do in memory cache update to keep the app UI up to date
        if mCachedTasks == nil {
            mCachedTasks = [String: Task]()
        }
        mCachedTasks?[task.id] = task
    }

    public func completeTask(_ task: Task) {
        let completedTask = Task(id: task.id, title: task.title, description: task.description, completed: true)

        // Do in memory cache update to keep the app UI up to date
        if mCachedTasks == nil {
            mCachedTasks = [String: Task]()
        }
        mCachedTasks?[task.id] = completedTask
    }

    public func completeTaskWithId(_ id: String) {
        if let task = mCachedTasks?[id] {
            completeTask(task)
        }
    }

    public func activateTask(_ task: Task) {
        let activeTask = Task(id: task.id, title: task.title, description: task.description)

        // Do in memory cache update to keep the app UI up to date
        if mCachedTasks == nil {
            mCachedTasks = [String: Task]()
        }
        mCachedTasks?[task.id] = activeTask
    }

    public func activateTaskWithId(_ id: String) {
        if let task = mCachedTasks?[id] {
            activateTask(task)
        }
    }

    public func clearCompletedTasks() {
        // Do in memory cache update to keep the app UI up to date
        if mCachedTasks == nil {
            mCachedTasks = [String: Task]()
        }

        // Filter by isCompleted of Task ($0 is a tuple of type `(key: String, value: Task)`)
        mCachedTasks = mCachedTasks?.filter {
            $0.value.completed == false
        }
    }

    /**
     * Gets tasks from local data source (sqlite) unless the table is new or empty. In that case it
     * uses the network data source. This is done to simplify the sample.
     * <p>
     * Note: {@link GetTaskCallback#onDataNotAvailable()} is fired if both data sources fail to
     * get the data.
     */
    public func getTask(_ taskId: String, _ callback: GetTaskDelegate) {
        // Respond immediately with cache if available
        if let cachedTask = mCachedTasks?[taskId] {
            callback.onTaskLoaded(cachedTask)
        } else {
            callback.onDataNotAvailable()
        }
    }

    public func refreshTasks() {
        // Do nothing
    }

    public func deleteAllTasks() {
        if mCachedTasks == nil {
            mCachedTasks = [String: Task]()
        }
        mCachedTasks?.removeAll()
    }

    public func deleteTask(_ taskId: String) {
        mCachedTasks?.removeValue(forKey: taskId)
    }
}

//
// Created by Andrew on 3/28/18.
//

import Foundation

import AndroidSwiftLogcat

import AndroidSwiftTrace

import Backtrace

import SQLite_swift_android

import Swift_Posix_Thread

import Swift_Coroutine

import Swift_Boost_Context

import RxSwift

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
    static let TAG = "TasksRepository"

    /**
     * This variable has package local visibility so it can be accessed from tests.
     */
    var mCachedTasks: [String: Task]?

    // Prevent direct instantiation.
    public init() {
        ///*
        let snt1 = ScopedNativeTraceSection("android_swift_systrace_001")
        let snt2 = ScopedNativeTraceSection("android_swift_systrace_002")
        let snt3 = ScopedNativeTraceSection("android_swift_systrace_003")
        ScopedNativeTraceSection.beginTrace("android_swift_systrace_demo")

        AndroidLogcat.e(TasksRepository.TAG, "ScopedNativeTraceSection.sdkVersion = \(ScopedNativeTraceSection.sdkVersion)")

        AndroidLogcat.w(TasksRepository.TAG, "TasksRepository init !!!")
        Backtrace.install()
        A1()
        //fatalError("test Backtrace !!!")
        //let stackTrace: [String] = Thread.callStackSymbols;
        //AndroidLogcat.w(TasksRepository.TAG, "Thread.callStackSymbols not working on Android! always stackTrace.length = \(stackTrace.count)")
        //stackTrace.forEach {
        //    AndroidLogcat.w(TasksRepository.TAG, $0)
        //}
        AndroidLogcat.w(TasksRepository.TAG, "TasksRepository init !!!2222")
        // var crashExpected: String? = nil
        // crashExpected!.uppercased()
        AndroidLogcat.w(TasksRepository.TAG, "TasksRepository init !!!333")

        ScopedNativeTraceSection.endTrace("android_swift_systrace_demo")

        let db = SQLiteDB()
        let isOpened = db.open(dbPath: "/data/data/com.example.android.architecture.blueprints.todomvvmlive/cache/test123.db")
        AndroidLogcat.w(TasksRepository.TAG, "isOpened = \(isOpened)")
        let category1 = Category(db: db)
        category1.name = "My New Category1"
        _ = category1.save()
        let category2 = Category(db: db)
        category2.name = "My New Category2"
        _ = category2.save()

        if let category = Category.rowBy(db: db, id: 1) {
            AndroidLogcat.w(TasksRepository.TAG, "Found category with ID = 1")
        }

        let array = Category.rows(db: db, filter: "id > 0")

        if let category = Category.rowBy(db: db, id: 1) {
            category.delete() // note: just set `isDeleted` field to `1`, not delete it really.
            AndroidLogcat.w(TasksRepository.TAG, "Deleted category with ID = 1")
        }

        let testQueue = DispatchQueue(label: "forTest", attributes: [.concurrent])

        testQueue.async(qos: .background) {
            do {
                try db.transaction {
                    let category = Category(db: db)
                    category.name = "1-Transaction_Outter"
                    _ = category.save()
                    try db.transaction {
                        let category = Category(db: db)
                        category.name = "1-Transaction_inner_1"
                        _ = category.save()
                        try db.transaction {
                            let category = Category(db: db)
                            category.name = "1-Transaction_inner_1_1"
                            _ = category.save()

                            throw MyError.forTest
                        }
                        try db.transaction {
                            let category = Category(db: db)
                            category.name = "1-Transaction_inner_1_2"
                            _ = category.save()
                        }
                    }

                    try db.transaction {
                        let category = Category(db: db)
                        category.name = "1-Transaction_inner_2"
                        _ = category.save()

                        try db.transaction {
                            let category = Category(db: db)
                            category.name = "1-Transaction_inner_2-1"
                            _ = category.save()

                            throw MyError.forTest
                        }
                        try db.transaction {
                            let category = Category(db: db)
                            category.name = "1-Transaction_inner_2-2"
                            _ = category.save()
                        }
                    }
                }
            } catch {
                // ignore
            }
        }

        testQueue.async(qos: .userInteractive) {
            do {
                try db.transaction {
                    let category = Category(db: db)
                    category.name = "2-Transaction_Outter"
                    _ = category.save()
                    try db.transaction {
                        let category = Category(db: db)
                        category.name = "2-Transaction_inner_1"
                        _ = category.save()
                        try db.transaction {
                            let category = Category(db: db)
                            category.name = "2-Transaction_inner_1_1"
                            _ = category.save()

                            throw MyError.forTest
                        }
                        try db.transaction {
                            let category = Category(db: db)
                            category.name = "2-Transaction_inner_1_2"
                            _ = category.save()
                        }
                    }

                    try db.transaction {
                        let category = Category(db: db)
                        category.name = "2-Transaction_inner_2"
                        _ = category.save()

                        try db.transaction {
                            let category = Category(db: db)
                            category.name = "2-Transaction_inner_2-1"
                            _ = category.save()

                            throw MyError.forTest
                        }
                        try db.transaction {
                            let category = Category(db: db)
                            category.name = "2-Transaction_inner_2-2"
                            _ = category.save()
                        }
                    }
                }
            } catch {
                // ignore
            }
        }

        // db.closeDB()

        if let pthread2: PosixThread<Void> = PosixThread({ () in

            AndroidLogcat.i(TasksRepository.TAG, "2start a new thread return void")

            print("2current Thread \(Thread.current)")

            print("2 no input param")

            return ()
        }) {
            let threadResult: Void? = pthread2.join()
            if let threadResult = threadResult {
                AndroidLogcat.i(TasksRepository.TAG, "result2 = \(threadResult)")
            } else {
                AndroidLogcat.i(TasksRepository.TAG, "result2 = nil")
            }
        } else {
            AndroidLogcat.i(TasksRepository.TAG, "create Posix thread2 fail!")
        }

        do {

            try example_01()
            try example_02()
            try example_03()
            try example_04()
            try example_05()
            try example_06()
            try example_07()
        } catch {
            AndroidLogcat.e(TasksRepository.TAG, "\(error)")
        }
        // */
    }

    enum MyError: Error {
        case forTest
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

    func example_01() throws {
        // Example-01
        // ===================
        AndroidLogcat.i(TasksRepository.TAG, "Example-01 =============================")

        //let queue = DispatchQueue(label: "TestCoroutine")
        let queue = DispatchQueue.global()

        let coJob1 = CoLauncher.launch(name: "co1", dispatchQueue: queue) { (co: Coroutine) throws -> String in
            defer {
                AndroidLogcat.i(TasksRepository.TAG, "co 01 - end \(Thread.current)")
            }
            AndroidLogcat.i(TasksRepository.TAG, "co 01 - start \(Thread.current)")
            try co.yield()
            return "co1 's result"
        }

        let coJob2 = CoLauncher.launch(dispatchQueue: queue) { (co: Coroutine) throws -> String in
            defer {
                AndroidLogcat.i(TasksRepository.TAG, "co 02 - end \(Thread.current)")
            }
            AndroidLogcat.i(TasksRepository.TAG, "co 02 - start \(Thread.current)")
            try co.yield()
            throw TestError.SomeError(reason: "Occupy some error in co2")
            return "co2 's result"
        }

        let coJob3 = CoLauncher.launch(dispatchQueue: queue) { (co: Coroutine) throws -> String in
            defer {
                AndroidLogcat.i(TasksRepository.TAG, "co 03 - end \(Thread.current)")
            }
            AndroidLogcat.i(TasksRepository.TAG, "co 03 - start \(Thread.current)")
            try co.yield()
            return "co3 's result"
        }

        try coJob1.join()
        try coJob2.join()
        try coJob3.join()

        AndroidLogcat.i(TasksRepository.TAG, "Example-01 =============  end  ===============")
    }

    func example_02() throws {
        // Example-02
        // ===================
        AndroidLogcat.i(TasksRepository.TAG, "Example-02 =============================")

        let producerQueue = DispatchQueue(label: "producerQueue", attributes: .concurrent)
        let consumerQueue = DispatchQueue(label: "consumerQueue", attributes: .concurrent)
        let semFull = CoSemaphore(value: 8, "full")
        let semEmpty = CoSemaphore(value: 0, "empty")
        let semMutex = CoSemaphore(value: 1, "mutex")
        //let semMutex = DispatchSemaphore(value: 1)
        var buffer: [Int] = []

        let coConsumer = CoLauncher.launch(dispatchQueue: consumerQueue) { (co: Coroutine) throws -> Void in
            for time in (1...32) {
                try semEmpty.wait(co)
                try semMutex.wait(co)
                if buffer.isEmpty {
                    fatalError()
                }
                let consumedItem = buffer.removeFirst()
                print("consume : \(consumedItem)  -- at \(time)   \(Thread.current)")
                semMutex.signal()
                semFull.signal()
            }
        }

        let coProducer = CoLauncher.launch(dispatchQueue: producerQueue) { (co: Coroutine) throws -> Void in
            for time in (1...32).reversed() {
                try semFull.wait(co)
                try semMutex.wait(co)
                buffer.append(time)
                print("produced : \(time)   \(Thread.current)")
                semMutex.signal()
                semEmpty.signal()
            }
        }

        try coConsumer.join()
        try coProducer.join()

        AndroidLogcat.i(TasksRepository.TAG, "finally, buffer = \(buffer)")
        AndroidLogcat.i(TasksRepository.TAG, "semFull  = \(semFull)")
        AndroidLogcat.i(TasksRepository.TAG, "semEmpty = \(semEmpty)")
        AndroidLogcat.i(TasksRepository.TAG, "semMutex = \(semMutex)")
    }

    func example_03() throws {
        // Example-03
        // ===================
        AndroidLogcat.i(TasksRepository.TAG, "Example-03 =============================")

        //let queue = DispatchQueue(label: "TestCoroutine")
        let queue = DispatchQueue.global()

        let coDelay = CoLauncher.launch(dispatchQueue: queue) { (co: Coroutine) throws -> String in
            AndroidLogcat.i(TasksRepository.TAG, "coDelay - start \(Thread.current)")
            let start = Date.timeIntervalSinceReferenceDate
            try co.delay(.seconds(2))
            let end = Date.timeIntervalSinceReferenceDate
            AndroidLogcat.i(TasksRepository.TAG, "coDelay - end \(Thread.current)  in \((end - start) * 1000) ms")
            return "coDelay 's result"
        }

        try coDelay.join()
    }

    func example_04() throws {
        // Example-04
        // ===================
        print("Example-04 =============================")
        let start = Date.timeIntervalSinceReferenceDate
        let queue = DispatchQueue(label: "example_04", attributes: .concurrent)
        let coJob = CoLauncher.launch(name: "coTestNestFuture", dispatchQueue: queue) { (co: Coroutine) throws -> Void in
            var sum: Int = 0
            for i in (1...100) {
                //print("--------------------   makeCoFuture_01_\(i) --- await(\(co)) -- before")
                try co.continueOn(.global())
                sum += try makeCoFuture_01("makeCoFuture_01_\(i)", queue, i).await(co)
                try co.continueOn(.main)
                //print("--------------------   makeCoFuture_01_\(i) --- await(\(co)) -- end")
            }
            print("sum = \(sum)")
        }
        try coJob.join()

        //print("Thread.sleep(forTimeInterval: 5)")
        let end = Date.timeIntervalSinceReferenceDate
        print("coFuture - end \(Thread.current)  in \((end - start) * 1000) ms")
        //Thread.sleep(forTimeInterval: 1)
    }

    func example_05() throws {
        // Example-05
        // ===================
        AndroidLogcat.i(TasksRepository.TAG, "Example-05 =============================")

        let consumerQueue = DispatchQueue(label: "consumerQueue", qos: .userInteractive, attributes: .concurrent)
        let producerQueue_01 = DispatchQueue(label: "producerQueue_01", /*qos: .background,*/ attributes: .concurrent)
        let producerQueue_02 = DispatchQueue(label: "producerQueue_02", /*qos: .background,*/ attributes: .concurrent)
        let producerQueue_03 = DispatchQueue(label: "producerQueue_03", /*qos: .background,*/ attributes: .concurrent)
        let closeQueue = DispatchQueue(label: "closeQueue", /*qos: .background,*/ attributes: .concurrent)
        let channel = CoChannel<Int>(name: "CoChannel_Example-05", capacity: 1)

        let coClose = CoLauncher.launch(name: "coClose", dispatchQueue: closeQueue) { (co: Coroutine) throws -> Void in
            try co.delay(.milliseconds(100))
            AndroidLogcat.i(TasksRepository.TAG, "coClose before  --  delay")
            //try co.yield()
            channel.close()
            AndroidLogcat.i(TasksRepository.TAG, "coClose after  --  delay")
        }

        let coConsumer = CoLauncher.launch(name: "coConsumer", dispatchQueue: consumerQueue) { (co: Coroutine) throws -> Void in
            var time: Int = 1
            for item in try channel.receive(co) {
                try co.delay(.milliseconds(15))
                //try co.delay(.milliseconds(5))
                AndroidLogcat.i(TasksRepository.TAG, "consumed : \(item)  --  \(time)  --  \(Thread.current)")
                time += 1
            }
            AndroidLogcat.i(TasksRepository.TAG, "coConsumer  --  end")
        }

        let coProducer01 = CoLauncher.launch(name: "coProducer01", dispatchQueue: producerQueue_01) { (co: Coroutine) throws -> Void in
            for time in (1...20).reversed() {
                try co.delay(.milliseconds(10))
                //AndroidLogcat.i(TasksRepository.TAG, "coProducer01  --  before produce : \(time)")
                try channel.send(co, time)
                AndroidLogcat.i(TasksRepository.TAG, "coProducer01  --  after produce : \(time)")
            }
            AndroidLogcat.i(TasksRepository.TAG, "coProducer01  --  end")
        }

        let coProducer02 = CoLauncher.launch(name: "coProducer02", dispatchQueue: producerQueue_02) { (co: Coroutine) throws -> Void in
            for time in (21...40).reversed() {
                //AndroidLogcat.i(TasksRepository.TAG, "coProducer02  --  before produce : \(time)")
                try co.delay(.milliseconds(10))
                try channel.send(co, time)
                AndroidLogcat.i(TasksRepository.TAG, "coProducer02  --  after produce : \(time)")
            }
            AndroidLogcat.i(TasksRepository.TAG, "coProducer02  --  end")
        }

        let coProducer03 = CoLauncher.launch(name: "coProducer03", dispatchQueue: producerQueue_03) { (co: Coroutine) throws -> Void in
            for time in (41...60).reversed() {
                //AndroidLogcat.i(TasksRepository.TAG, "coProducer02  --  before produce : \(time)")
                try co.delay(.milliseconds(10))
                try channel.send(co, time)
                AndroidLogcat.i(TasksRepository.TAG, "coProducer03  --  after produce : \(time)")
            }
            AndroidLogcat.i(TasksRepository.TAG, "coProducer03  --  end")
        }

        try coClose.join()
        try coConsumer.join()
        try coProducer01.join()
        try coProducer02.join()
        try coProducer03.join()

        AndroidLogcat.i(TasksRepository.TAG, "channel = \(channel)")
    }

    func example_06() throws {
        // Example-06
        // ===================
        AndroidLogcat.i(TasksRepository.TAG, "Example-06 =============================")

        let queue = DispatchQueue.global()
        let queue_001 = DispatchQueue(label: "queue_001", attributes: .concurrent)
        let queue_002 = DispatchQueue(label: "queue_002", attributes: .concurrent)

        queue.async {
            Thread.sleep(forTimeInterval: 0.005)
            AndroidLogcat.i(TasksRepository.TAG, "other job \(Thread.current)")
        }

        let coJob1 = CoLauncher.launch(name: "co1", dispatchQueue: queue) { (co: Coroutine) throws -> String in
            defer {
                AndroidLogcat.i(TasksRepository.TAG, "co 01 - end \(Thread.current)")
            }
            AndroidLogcat.i(TasksRepository.TAG, "co 01 - start \(Thread.current)")
            try co.continueOn(queue_001)
            AndroidLogcat.i(TasksRepository.TAG, "co 01 - continueOn - queue_001 -  \(Thread.current)")
            try co.continueOn(DispatchQueue.main)
            AndroidLogcat.i(TasksRepository.TAG, "co 01 - continueOn - queue_main -  \(Thread.current)")
            try co.continueOn(queue_002)
            AndroidLogcat.i(TasksRepository.TAG, "co 01 - continueOn - queue_002 -  \(Thread.current)")
            try co.continueOn(queue)

            return "co1 's result"
        }

        try coJob1.join()

        Thread.sleep(forTimeInterval: 1)
    }

/// Coroutine instead of `BackPress` in RxSwift RxJava
    func example_07() throws {
        // Example-07
        // ===================
        AndroidLogcat.i(TasksRepository.TAG, "Example-07 =============================")
        let bag = DisposeBag()
        let rxProducerQueue_01 = DispatchQueue(label: "rx_producerQueue_01", qos: .background, attributes: .concurrent)
        let rxProducerQueue_02 = DispatchQueue.global()
        let ob = Observable<Int>.coroutineCreate(dispatchQueue: rxProducerQueue_01) { (co, eventProducer) in
            for time in (1...20).reversed() {
                if time % 2 == 0 {
                    try co.continueOn(rxProducerQueue_01)
                } else {
                    try co.continueOn(rxProducerQueue_02)
                }
                try eventProducer.send(time)
                AndroidLogcat.i(TasksRepository.TAG, "produce: \(time) -- \(Thread.current)")

                if time == 11 {
                    return // exit in a half-way, no more event be produced
                }
                /*if time == 10 {
                    throw TestError.SomeError(reason: "Occupy some exception in a half-way, no more event be produced") // occupy exception in a half-way, no more event be produced
                }*/
            }
        }

        let _ = ob.subscribe(
                        onNext: { (text) in
                            Thread.sleep(forTimeInterval: 1)
                            AndroidLogcat.i(TasksRepository.TAG, "consume: \(text)")
                        },
                        onError: { (error) in
                            AndroidLogcat.i(TasksRepository.TAG, "onError: \(error)")
                        },
                        onCompleted: {
                            AndroidLogcat.i(TasksRepository.TAG, "onCompleted")
                        },
                        onDisposed: {
                            AndroidLogcat.i(TasksRepository.TAG, "onDisposed")
                        }
                )
                .disposed(by: bag)

        Thread.sleep(forTimeInterval: 15)
    }
}


func makeCoFuture_01(_ name: String, _ dispatchQueue: DispatchQueue, _ i: Int) -> CoFuture<Int> {
    return CoFuture(name, dispatchQueue) { (co: Coroutine) in
        var sum: Int = 0
        for j in (1...100) {
            //print("--------------------   makeCoFuture_02_\(j) --- await(\(co)) -- before")
            try co.continueOn(.main)
            sum += try makeCoFuture_02("makeCoFuture_02_\(j)", dispatchQueue, j).await(co)
            try co.continueOn(.global())
            //print("--------------------   makeCoFuture_02_\(j) --- await(\(co)) -- end")
        }
        return sum
    }
}

func makeCoFuture_02(_ name: String, _ dispatchQueue: DispatchQueue, _ i: Int) -> CoFuture<Int> {
    return CoFuture(name, dispatchQueue) { (co: Coroutine) in
        //try co.delay(.milliseconds(5))
        return i
    }
}

enum TestError: Error {
    case SomeError(reason: String)
}

func A1() -> Void {
    A2()
}

func A2() -> Void {
    A3()
}

func A3() -> Void {
    B1()
}

func B1() -> Void {
    B2()
}

func B2() -> Void {
    B3()
}

func B3() -> Void {
    Van().drive()
}

class Van {
    func drive() -> Void {

        AndroidLogcat.i(TasksRepository.TAG, " ")
        AndroidLogcat.i(TasksRepository.TAG, " ")
        AndroidLogcat.i(TasksRepository.TAG, " ")
        AndroidLogcat.i(TasksRepository.TAG, "👇👇👇 case1 :  print current")
        Backtrace.current.frames.forEach {
            AndroidLogcat.e(TasksRepository.TAG, $0.description)
        }

        AndroidLogcat.i(TasksRepository.TAG, " ")
        AndroidLogcat.i(TasksRepository.TAG, " ")
        AndroidLogcat.i(TasksRepository.TAG, " ")
        AndroidLogcat.i(TasksRepository.TAG,"👇👇👇👇👇 case2 : Backtrace.capture")
        do {
            try Backtrace.capture(from: oilEmpty)
            //try oilEmpty()
            //fatalError("Backtrace.capture(from: oilEmpty)")
        } catch let err as Backtrace.Captured {
            AndroidLogcat.e(TasksRepository.TAG, err.description)
        } catch let uncaughtError {
            AndroidLogcat.e(TasksRepository.TAG, "uncaught exception \(uncaughtError)")
        }

        AndroidLogcat.i(TasksRepository.TAG, " ")
        AndroidLogcat.i(TasksRepository.TAG, " ")
        AndroidLogcat.i(TasksRepository.TAG, " ")
        AndroidLogcat.i(TasksRepository.TAG, "👇👇👇👇👇👇👇👇👇  case3 : fatalError")
        //fatalError("Just test Backtrace !!!")
        AndroidLogcat.i(TasksRepository.TAG, "👆👆👆👆👆👆👆👆👆  note: never print this line !!!")
    }
}

func oilEmpty() throws -> Void {
        1 + 1;
        throw CarError.oilEmpty(message: "!!! oil empty !!!")
    }

enum CarError: Error {
    case oilEmpty(message: String)
    case flatTire(message: String)
}

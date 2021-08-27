import Backtrace

@_silgen_name("swift_willThrow")
@inline(never)
func swiftWillThrowImpl2() {
    Backtrace.swiftWillThrow(skip: 9)
}
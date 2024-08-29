# Dynamic Programming(동적 계획법)

## Dynamic Programming은 다음과 같은 과정을 통해 문제를 해결한다.
1. 문제 분할: 원래의 문제를 더 작은 부분 문제로 나누어 해결한다.
2. 부분 문제 해결: 각 부분 문제를 해결한다.
3. 결과 저장: 각 부분 문제의 결과를 메모이제이션 또는 테이블을 사용하여 저장한다.
4. 결과 재사용: 저장된 결과를 재사용하여 중복 계산을 방지한다.


## 예시: 피보나치 수열 (Fibonacci Sequence)
피보나치 수열은 **Dynamic Programming**의 대표적인 예이다. 피보나치 수열은 다음과 같은 점화식을 가진다:

* $F_0 = 0$
* $F_1 = 1$
* $F_{n+2} = F_{n+1} + F_n$

Dynamic Programming을 사용하여 피보나치 수열을 계산하는 코드

### 1. 메모이제이션을 사용한 피보나치 수열
* 메모이제이션은 재귀 호출을 통해 부분 문제를 해결하고, 그 결과를 저장하여 중복 계산을 방지하는 기법이다.
* 이 코드는 각 피보나치 수를 계산한 결과를 `memo` 딕셔너리에 저장하여, 같은 값을 다시 계산하지 않도록 한다.
```swift
// Swift 샘플코드:

import Foundation

// 메모이제이션을 사용한 피보나치 수열 계산
func fibonacci(_ n: Int, memo: inout [Int: Int]) -> Int {
    if let result = memo[n] {
        return result
    }
    if n <= 1 {
        return n
    }
    let result = fibonacci(n - 1, memo: &memo) + fibonacci(n - 2, memo: &memo)
    memo[n] = result
    return result
}

// 예시 사용
var memo = [Int: Int]()
print(fibonacci(10, memo: &memo))  // 출력: 55
```

```objective-c
// Objective-C 샘플코드:

#import <Foundation/Foundation.h>

// 메모이제이션을 사용한 피보나치 수열 계산
NSInteger fibonacci(NSInteger n, NSMutableDictionary<NSNumber *, NSNumber *> *memo) {
    NSNumber *key = @(n);
    NSNumber *result = memo[key];
    if (result) {
        return [result integerValue];
    }
    if (n <= 1) {
        return n;
    }
    NSInteger fib = fibonacci(n - 1, memo) + fibonacci(n - 2, memo);
    memo[key] = @(fib);
    return fib;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSMutableDictionary<NSNumber *, NSNumber *> *memo = [NSMutableDictionary dictionary];
        NSLog(@"%ld", (long)fibonacci(10, memo));  // 출력: 55
    }
    return 0;
}
```

### 2. 테이블을 사용한 피보나치 수열
* 테이블을 사용한 방법은 반복문을 통해 부분 문제의 결과를 저장하고 이를 이용해 최종 문제를 해결하는 방법이다.
* 이 코드는 `table` 배열을 사용하여 각 피보나치 수를 계산하고 저장하여 중복 계산을 방지한다.

```swift
// 스위프트 샘플코드:

import Foundation

// 테이블을 사용한 피보나치 수열 계산
func fibonacciTable(_ n: Int) -> Int {
    if n <= 1 {
        return n
    }
    var table = [Int](repeating: 0, count: n + 1)
    table[1] = 1
    for i in 2...n {
        table[i] = table[i - 1] + table[i - 2]
    }
    return table[n]
}

// 예시 사용
print(fibonacciTable(10))  // 출력: 55

```

```objective-c
// Objective-C 샘플코드:

#import <Foundation/Foundation.h>

// 테이블을 사용한 피보나치 수열 계산
NSInteger fibonacciTable(NSInteger n) {
    if (n <= 1) {
        return n;
    }
    NSMutableArray<NSNumber *> *table = [NSMutableArray arrayWithCapacity:n + 1];
    for (NSInteger i = 0; i <= n; i++) {
        [table addObject:@(0)];
    }
    table[1] = @(1);
    for (NSInteger i = 2; i <= n; i++) {
        table[i] = @(table[i - 1].integerValue + table[i - 2].integerValue);
    }
    return table[n].integerValue;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"%ld", (long)fibonacciTable(10));  // 출력: 55
    }
    return 0;
}

```

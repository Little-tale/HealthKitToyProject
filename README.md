## 사용자의 걸음을 추적하는 간단한 앱입니다.

# HealthKit
> 헬스킷을 경험하기 위한 mini 프로젝트입니다. ( 걸음수만 )


 <img src="https://github.com/user-attachments/assets/db5c03c6-80ff-444d-908e-9d3bff4c3751" width="300" height="480"/>
 
## HKObjectType
> 데이터 유형의 서브 클래스를 포함한 추상 슈퍼 클래스
모든 HealthKit 데이터는 HKObjectType으로 묶여있다.

```swift
    class HKObjectType : NSObject
```

## HKSampleType
> 데이터 샘플을 나타내는 데 사용되는 클래스 의 추상 하위 클래스
샘플 타입은 데이터에 해당하는 HealthKit들의 데이터 타입

```swift
    class HKCharacteristicType : HKObjectType
```

## HKCharacteristicType
> 시간에 따라 변경되지 않는 데이터 유형

```swift
    class HKCharacteristicType : HKObjectType
```

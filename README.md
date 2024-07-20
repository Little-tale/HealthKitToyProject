## 헬스킷을 공부하는 간단한 앱입니다.

# 설명
> 헬스킷을 경험하기 위한 mini 프로젝트입니다. ( 걸음수만 ) <br>
> 사용자의 몸무게를 가져옵니다. ( 업데이트 7/18 ) <br>
> 사용자의 수면 시간을 가져옵니다. ( 업데이트 7/20 ) <br> 

 <img src="https://github.com/user-attachments/assets/897a5260-dbb1-426e-b486-92355c0b7c4e" width="280" height="520"/>
 
## HKObjectType
> 데이터 유형의 서브 클래스를 포함한 추상 슈퍼 클래스 <br>
> 모든 HealthKit 데이터는 HKObjectType으로 묶여있다.

```swift
    class HKObjectType : NSObject
```

## HKSampleType
> 데이터 샘플을 나타내는 데 사용되는 클래스 의 추상 하위 클래스
> 샘플 타입은 데이터에 해당하는 HealthKit들의 데이터 타입
> (몸무게 로직에 활용한 코드 보실수 있습니다.)

```swift
    class HKCharacteristicType : HKObjectType
```

## HKCharacteristicType
> 시간에 따라 변경되지 않는 데이터 유형

```swift
    class HKCharacteristicType : HKObjectType
```

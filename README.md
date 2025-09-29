# APB-Bus-Peripheral-Project


### Simple Block Diagram
<img width="1854" height="928" alt="image" src="https://github.com/user-attachments/assets/c59fbf45-360e-453c-b725-7bb20ccfa96c" />

## 📝 프로젝트 요약
---
본 프로젝트는 저전력·저속 주변장치 통신을 위한 **AMBA APB(Advanced Peripheral Bus)** 프로토콜을 활용하여 **RISC-V Multi-Cycle CPU**의 주변장치(Peripheral)들을 설계하고 기능 검증을 수행하는 데 중점을 두었습니다.

주요 목표는 다음과 같습니다:

* **하드웨어 설계**: RISC-V CPU에 연결되는 APB 기반의 주변장치(Timer, GPIO, UART) 구현
* **기능 검증**: 클래스 기반의 **SystemVerilog 테스트벤치(UVM)**를 이용해 설계된 DUT(Design Under Test)의 동작 확인
* **시스템 통합**: C 언어 기반의 펌웨어를 작성하여 FPGA 보드에서 최종 기능 검증

---
## 🛠️ 개발 환경 및 도구
---
| 구분 | 내용 |
|:---|:---|
| **언어** | SystemVerilog, C |
| **개발 툴** | Vivado 2020.2 |
| **FPGA 보드** | Xilinx Basys3 |

---
## 📖 핵심 기술: AMBA APB
---
AMBA APB는 ARM에서 개발한 버스 프로토콜로, 낮은 대역폭과 전력이 중요한 임베디드 시스템에 최적화되어 있습니다. 간단한 2단계(SETUP - ACCESS) 구조로 구현이 용이하다는 장점을 가집니다.

**APB 신호 정의**

| 신호명 | 기능 |
|:---|:---|
| `PCLK` | 클록 신호 |
| `PRESETn` | 비동기 리셋 (Active Low) |
| `PADDR` | 주변장치 주소 버스 |
| `PSELx` | 특정 슬레이브 활성화 신호 |
| `PENABLE` | Access 단계 시작을 알리는 신호 |
| `PWRITE` | 데이터 전송 방향 제어 (1: 쓰기, 0: 읽기) |
| `PWDATA` | 쓰기 데이터 버스 |
| `PRDATA` | 읽기 데이터 버스 |
| `PREADY` | 슬레이브 준비 완료 신호 |

---
## ⚙️ 하드웨어 아키텍처
---
프로젝트의 시스템은 APB 버스를 통해 RISC-V CPU(마스터)와 여러 주변장치(슬레이브)를 연결하는 구조로 설계되었습니다.

* **APB Master**: CPU로부터 요청을 받아 APB 트랜잭션을 생성하고 제어합니다.
* **APB Slaves**: APB 버스에 연결된 개별 주변장치 모듈입니다.
    * **Timer**: 특정 시간 간격으로 인터럽트를 발생시키는 카운터 기능 구현
    * **GPIO**: 범용 입출력 포트를 제어하여 외부 신호 처리
    * **UART**: PC와의 비동기 직렬 통신을 담당
* **APB Decoder**: CPU의 주소(`PADDR`) 신호를 분석하여 원하는 슬레이브(`PSELx`)를 활성화합니다.
* **APB MUX**: 여러 슬레이브로부터 온 읽기 데이터(`PRDATA`) 중, 선택된 데이터만을 마스터로 전달합니다.

---
## 🔬 기능 검증
---
설계된 모든 모듈과 최종 통합 시스템의 신뢰성을 확인하기 위해 체계적인 검증을 수행했습니다.

* **검증 환경**: **UVM(Universal Verification Methodology)**을 참고하여, 객체 지향 프로그래밍이 가능한 SystemVerilog 클래스 기반의 테스트벤치를 구축했습니다.
* **검증 대상**: APB Master, APB Slaves(GPIO, UART), RAM 등
* **주요 검증 항목**:
    * APB 프로토콜의 모든 쓰기/읽기 동작이 규격에 맞는지 확인
    * 각 주변장치의 고유한 기능(예: GPIO의 입출력 제어, UART의 데이터 송수신)이 올바른지 확인
    * 주소 디코더와 데이터 멀티플렉서의 정확한 동작 여부 확인

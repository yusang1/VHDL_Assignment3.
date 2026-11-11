# VHDL Assignment 3

다섯 순차회로의 VHDL 소스, 개별 게이트 Logisim 회로, 회로도·파형·설명을 포함한 PDF 보고서입니다.

## 제출 파일

- [Assignment3_Report.pdf](Assignment3_Report.pdf): 회로도, 동작 설명, 합성 결과 회로도, 시뮬레이션 파형 및 검증표
- [vhdl/](vhdl/): VHDL 소스 5개
- [logisim/](logisim/): Logisim 프로젝트 5개

| 회로 | VHDL | Logisim 구성 |
|---|---|---|
| RS Latch | 교차결합 NOR 논리 | NOR 2개, 직접 보이는 교차 피드백 배선 |
| D Latch | en=1일 때 D 전달, en=0일 때 유지 | NAND 게이트 |
| D Flip-Flop | rising_edge(clk) | NAND D 래치 2개 + 클록 인버터 |
| JK Flip-Flop | 상승 에지에서 Hold/Reset/Set/Toggle | NAND 게이트 및 Q/Qn 피드백 |
| Async Set/Clear D FF | Clear 우선, 다음 Set, 다음 상승 에지 D | 두 래치에 비동기 제어를 적용한 개별 게이트 회로 |

다섯 회로 모두 **Tunnel 없이 입력·클록·출력·피드백을 실제 연결선으로 직접 배선**했습니다. 기본 제공 Latch/Flip-Flop 부품은 사용하지 않습니다. D/JK 플립플롭과 비동기 D 플립플롭은 MASTER와 SLAVE 위치를 표시했습니다. 교차점에 접속점(점)이 없으면 선은 서로 연결되지 않습니다. 큰 회로는 Logisim 확대율을 줄여 전체 구조를 확인한 뒤 원하는 부분을 확대하면 됩니다.

## RS 래치를 처음 열었을 때 E가 보이면

Logisim-evolution 5.0.0에서 초기 S=R=0으로 열면 저장된 상태가 없으므로 Q/Qn이 E로 표시될 수 있습니다. 이는 유효한 초기화 이후의 Hold 동작과 다릅니다. Poke 도구로 다음 순서대로 입력을 바꾸세요. 시뮬레이션이 활성화되어 있어야 합니다.

| 순서 | S | R | Q | Qn | 동작 |
|---|---|---|---|---|---|
| 1 | 0 | 1 | 0 | 1 | 먼저 Reset하여 초기화 |
| 2 | 0 | 0 | 0 | 1 | Hold |
| 3 | 1 | 0 | 1 | 0 | Set |
| 4 | 0 | 0 | 1 | 0 | Hold |
| 5 | 1 | 1 | 0 | 0 | 금지 입력 |
| 6 | 0 | 1 | 0 | 1 | Reset으로 회복 |

피드백 선이 교차하는 곳에 접속점(점)이 없으면 두 선은 연결되지 않습니다. S=R=1에서 둘을 동시에 0으로 내린 뒤의 상태는 보장하지 않습니다.

## 검증

GHDL 5.0.1/VHDL-2008에서 다섯 설계의 컴파일, 합성, RTL 시뮬레이션과 합성된 VHDL netlist 시뮬레이션을 통과했습니다. Logisim 2.7.1과 **Logisim-evolution 5.0.0** 양쪽의 실제 시뮬레이션 엔진에서도 다섯 `.circ`를 검증했습니다.

총 50단계 중 출력 미지정 초기 준비 2단계를 제외한 **48개 Q 검사**가 통과했고, 해당 시점의 GHDL/Logisim 출력도 일치했습니다. RS Qn도 6번 검사했습니다. Logisim-evolution 5.0.0에서 초기 E → Reset 후 Q=0/Qn=1 → R=0에서 유지되는 것도 별도로 확인했습니다. 회로별 파형과 단계별 결과는 PDF에 포함되어 있습니다.

이는 지정된 입력 시나리오에 대한 디지털 기능 검증이며, 실제 하드웨어의 setup/hold 및 비동기 recovery/removal 타이밍 검증은 아닙니다. 합성은 특정 FPGA 기술에 매핑하지 않은 일반 합성입니다. 기존 2.7.1 포맷을 Logisim-evolution으로 열 때 호환 모드 안내가 표시될 수 있습니다.

## LMS 제출

이 저장소는 공개되어 있습니다. LMS에는 저장소 주소만 제출하세요. 저장소 이름 끝의 점도 주소에 포함됩니다.

https://github.com/yusang1/VHDL_Assignment3.

## 직접 배선으로 수정한 버전

D 래치, D 플립플롭, JK 플립플롭, 비동기 Set/Clear D 플립플롭도 RS 래치처럼 내부 배선이 보이도록 수정했습니다. 수정 후 위의 48개 Q 검사 및 RS Qn 검사를 두 Logisim 버전에서 다시 통과했습니다. PDF의 회로도도 갱신했고, 큰 회로 3개는 확대 회로도 부록을 추가했습니다.

저장소에서 `.circ` 파일을 새로 다운로드하여 열어주세요. 이미 열어둔 예전 파일에는 GitHub 수정 사항이 자동 적용되지 않습니다.

다른 회로도 처음에는 저장값이 정해져 있지 않을 수 있습니다. D 래치는 en=1, D=0으로 초기화하고, D FF는 D=0에서 clk를 0→1로 바꾸세요. JK FF는 J=0, K=1에서 clk를 0→1로 바꾸면 Reset됩니다. 비동기 D FF는 clr=1로 초기화할 수 있습니다.

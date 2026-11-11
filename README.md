# VHDL Assignment 3

다섯 순차회로의 VHDL, 개별 게이트 Logisim 회로, PDF 보고서와 실제 실행 결과입니다.

## 제출 파일

- `Assignment3_Report.pdf`: 회로 설명, 실제 Logisim 회로도, 합성 netlist에서 생성한 회로도, 파형 및 검증표
- `vhdl/*.vhd`: RS latch, D latch, D FF, JK FF, asynchronous Set/Clear D FF
- `logisim/*.circ`: Logisim **2.7.1** 프로젝트 (개별 게이트만 사용)
- `tb/*.vhd`: VHDL-2008 assertion 테스트벤치
- `results/`: VCD 원본, 합성 VHDL netlist, RTL/합성후 시뮬레이션 로그, 실제 Logisim 엔진 검증 CSV
- `schematics/`: 회로도 PNG, 합성 netlist 기반 Graphviz DOT

## 검증 결과

| 회로 | RTL 시뮬레이션 | 합성 | 합성후 시뮬레이션 | Logisim 단계 |
|---|---|---|---|---|
| RS latch | PASS | PASS | PASS | 6 |
| D latch | PASS | PASS | PASS | 6 |
| D FF | PASS | PASS | PASS | 8 |
| JK FF | PASS | PASS | PASS | 13 |
| Async D FF | PASS | PASS | PASS | 17 |

총 50단계, 초기 준비 2단계 외 Q 검사 48개. RS의 Qn도 6번 확인합니다. Logisim의 출력값은 별도 진리표 계산기가 아니라 제출된 `.circ`를 Logisim 엔진에 직접 로드해 얻었습니다. `scripts/LogisimVerify.java`를 참고하세요.

RS의 S=R=1에서는 Q=Qn=0이며, 둘을 동시에 0으로 해제한 뒤의 결과는 정의하지 않습니다. 테스트는 유효한 Reset으로 회복합니다. 초기 저장 상태는 보장하지 않으며 유효 입력으로 초기화합니다.

Logisim의 같은 이름 Tunnel은 전기적으로 연결됩니다. 각 파일을 열고 Poke 도구로 입력 핀을 바꾸면 됩니다. 상세 입력 순서는 `results/*_vectors.tsv`에 있으며, 한 행의 입력들을 적용한 뒤 전파가 안정되도록 기다립니다. 내부 master/slave 래치는 전부 게이트로 펼쳐져 있고, 기본 제공 Latch/Flip-Flop은 사용하지 않습니다.

## 다시 실행

환경: GHDL 5.0.1, Logisim 2.7.1, Java 21. GUI로 `.circ`를 여는 데에는 Logisim 자체의 Java 요구사항을 따르면 됩니다. Java 소스 실행 방식의 검증기는 JDK 11 이상이 필요합니다.

```bash
bash scripts/run_vhdl.sh
# Logisim jar와 fontchooser/colorpicker 등 배포판 의존 jar를 클래스패스에 포함:
export LOGISIM_CP='/path/to/logisim.jar:/path/to/dependency-jars/*'
bash scripts/run_logisim.sh
```

GHDL 실행 파일 경로는 `GHDL_BIN`으로 지정할 수 있습니다. RS의 피드백 및 D latch를 허용하도록 일반 합성에는 `--latches`를 사용합니다. 합성 결과는 특정 FPGA에 매핑한 것이 아닙니다. 실제 FPGA의 dual asynchronous set/clear 지원 여부와 타이밍 제약은 별도 확인이 필요합니다. 파형의 Logisim 점은 논리 상태 비교이며 아날로그 지연 비교가 아닙니다.

보고서 재생성에는 Python의 matplotlib/reportlab, Graphviz `dot`가 필요합니다. 먼저 위 검증을 실행한 뒤 `python3 scripts/generate_report.py`를 사용하세요.

## GitHub 제출

1. 본 폴더 내용을 본인 GitHub 저장소에 업로드합니다.
2. `Assignment3_Report.pdf`, `.vhd` 5개, `.circ` 5개가 표시되는지 확인합니다.
3. 교수자/조교가 접근할 수 있도록 공개 저장소 또는 수업에서 허용한 접근 권한을 설정합니다.
4. LMS에는 저장소 URL만 제출합니다.

보고서에 이름/학번이 필수라면 제출 전에 추가하세요. 회로 설명과 파형을 확인하고 본인이 동작을 설명할 수 있도록 검토하세요.

VCD/Logisim 간 결과 비교는 `python3 scripts/check_equivalence.py`로 다시 실행할 수 있습니다.

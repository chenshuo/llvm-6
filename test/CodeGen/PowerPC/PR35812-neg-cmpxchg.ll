; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; Make sure that a negative value for the compare-and-swap is zero extended
; from i8/i16 to i32 since it will be compared for equality.
; RUN: llc -mtriple=powerpc64le-linux-gnu -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mtriple=powerpc64le-linux-gnu -mcpu=pwr7 < %s | FileCheck %s --check-prefix=CHECK-P7

@str = private unnamed_addr constant [46 x i8] c"FAILED: __atomic_compare_exchange_n() failed.\00"
@str.1 = private unnamed_addr constant [59 x i8] c"FAILED: __atomic_compare_exchange_n() set the wrong value.\00"
@str.2 = private unnamed_addr constant [7 x i8] c"PASSED\00"

define signext i32 @main() {
; CHECK-LABEL: main:
; CHECK:    li 3, -32477
; CHECK:    li 6, 234
; CHECK:    sth 3, 46(1)
; CHECK:    lis 3, 0
; CHECK:    ori 4, 3, 33059
; CHECK:    sync
; CHECK:  .LBB0_1: # %L.entry
; CHECK:    lharx 3, 0, 5
; CHECK:    cmpw 4, 3
; CHECK:    bne 0, .LBB0_3
; CHECK:    sthcx. 6, 0, 5
; CHECK:    bne 0, .LBB0_1
; CHECK:    b .LBB0_4
; CHECK:  .LBB0_3: # %L.entry
; CHECK:    sthcx. 3, 0, 5
; CHECK:  .LBB0_4: # %L.entry
; CHECK:    cmplwi 3, 33059
; CHECK:    lwsync
; CHECK:    lhz 3, 46(1)
; CHECK:    cmplwi 3, 234
;
; CHECK-P7-LABEL: main:
; CHECK-P7:    li 3, -32477
; CHECK-P7:    lis 4, 0
; CHECK-P7:    li 7, 0
; CHECK-P7:    li 5, 234
; CHECK-P7:    sth 3, 46(1)
; CHECK-P7:    ori 4, 4, 33059
; CHECK-P7:    rlwinm 3, 6, 3, 27, 27
; CHECK-P7:    ori 7, 7, 65535
; CHECK-P7:    sync
; CHECK-P7:    slw 8, 5, 3
; CHECK-P7:    slw 9, 4, 3
; CHECK-P7:    rldicr 4, 6, 0, 61
; CHECK-P7:    slw 5, 7, 3
; CHECK-P7:    and 7, 8, 5
; CHECK-P7:    and 8, 9, 5
; CHECK-P7:  .LBB0_1: # %L.entry
; CHECK-P7:    lwarx 9, 0, 4
; CHECK-P7:    and 6, 9, 5
; CHECK-P7:    cmpw 0, 6, 8
; CHECK-P7:    bne 0, .LBB0_3
; CHECK-P7:    andc 9, 9, 5
; CHECK-P7:    or 9, 9, 7
; CHECK-P7:    stwcx. 9, 0, 4
; CHECK-P7:    bne 0, .LBB0_1
; CHECK-P7:    b .LBB0_4
; CHECK-P7:  .LBB0_3: # %L.entry
; CHECK-P7:    stwcx. 9, 0, 4
; CHECK-P7:  .LBB0_4: # %L.entry
; CHECK-P7:    srw 3, 6, 3
; CHECK-P7:    lwsync
; CHECK-P7:    cmplwi 3, 33059
; CHECK-P7:    lhz 3, 46(1)
; CHECK-P7:    cmplwi 3, 234
L.entry:
  %value.addr = alloca i16, align 2
  store i16 -32477, i16* %value.addr, align 2
  %0 = cmpxchg i16* %value.addr, i16 -32477, i16 234 seq_cst seq_cst
  %1 = extractvalue { i16, i1 } %0, 1
  br i1 %1, label %L.B0000, label %L.B0003

L.B0003:                                          ; preds = %L.entry
  %puts = call i32 @puts(i8* getelementptr inbounds ([46 x i8], [46 x i8]* @str, i64 0, i64 0))
  ret i32 1

L.B0000:                                          ; preds = %L.entry
  %2 = load i16, i16* %value.addr, align 2
  %3 = icmp eq i16 %2, 234
  br i1 %3, label %L.B0001, label %L.B0005

L.B0005:                                          ; preds = %L.B0000
  %puts1 = call i32 @puts(i8* getelementptr inbounds ([59 x i8], [59 x i8]* @str.1, i64 0, i64 0))
  ret i32 1

L.B0001:                                          ; preds = %L.B0000
  %puts2 = call i32 @puts(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.2, i64 0, i64 0))
  ret i32 0
}

; Function Attrs: nounwind
declare i32 @puts(i8* nocapture readonly) #0

; RUN: opt -analyze -scalar-evolution < %s | FileCheck %s
;
; This file contains test cases that verify that some simple uses of ICMP and
; SELECT are recognized as SMAX/SMIN.


; Try to match the following pattern in function f1:
; a+1 >s b ? a+x : b+x  ->  smax(a, b)+x
; CHECK: %max = select i1 %cond, i64 %x, i64 %y
; CHECK-NEXT: -->  (%x smax %y)

define void @f1(i64 %x, i64 %y) {
entry:
  %z = add i64 %x, 1
  %cond = icmp sgt i64 %z, %y
  %max = select i1 %cond, i64 %x, i64 %y
  ret void
}


; Try to match the following pattern in function f2:
; a+1 >s b ? b+x : a+x  ->  smin(a, b)+x
; CHECK: %min = select i1 %cond, i64 %y, i64 %x
; CHECK-NEXT: -->  (-1 + (-1 * ((-1 + (-1 * %x)) smax (-1 + (-1 * %y)))))

define void @f2(i64 %x, i64 %y) {
entry:
  %z = add i64 %x, 1
  %cond = icmp sgt i64 %z, %y
  %min = select i1 %cond, i64 %y, i64 %x
  ret void
}

; RUN: opt -analyze -scalar-evolution < %s | FileCheck %s
;
; This file contains test cases that verify that some simple uses of ICMP and
; SELECT are recognized as SMAX/UMAX or SMIN/UMIN.

; Try to match the following pattern in function f0:
; a+1 >s b ? a+x : b+x  ->  smax(a, b)+x
define void @f0(i64 %x, i64 %y) {
; CHECK-LABEL: Classifying expressions for: @f0
entry:
  %z = add i64 %x, 1
  %cond = icmp sgt i64 %z, %y
  %max = select i1 %cond, i64 %x, i64 %y
; CHECK: %max = select i1 %cond, i64 %x, i64 %y
; CHECK-NEXT: -->  (%x smax %y)
  ret void
}

; Try to match the following pattern in function f1:
; a+1 >s b ? b+x : a+x  ->  smin(a, b)+x
define void @f1(i64 %x, i64 %y) {
; CHECK-LABEL: Classifying expressions for: @f1
entry:
  %z = add i64 %x, 1
  %cond = icmp sgt i64 %z, %y
  %min = select i1 %cond, i64 %y, i64 %x
; CHECK: %min = select i1 %cond, i64 %y, i64 %x
; CHECK-NEXT: -->  (-1 + (-1 * ((-1 + (-1 * %x)) smax (-1 + (-1 * %y)))))
  ret void
}

; Try to match the following pattern in function f2:
; a+1 >u b ? a+x : b+x  ->  umax(a, b)+x
define void @f2(i64 %x, i64 %y) {
; CHECK-LABEL: Classifying expressions for: @f2
entry:
  %z = add i64 %x, 1
  %cond = icmp ugt i64 %z, %y
  %max = select i1 %cond, i64 %x, i64 %y
; CHECK: %max = select i1 %cond, i64 %x, i64 %y
; CHECK-NEXT: -->  (%x umax %y)
  ret void
}

; Try to match the following pattern in function f3:
; a+1 >u b ? b+x : a+x  ->  umin(a, b)+x
define void @f3(i64 %x, i64 %y) {
; CHECK-LABEL: Classifying expressions for: @f3
entry:
  %z = add i64 %x, 1
  %cond = icmp ugt i64 %z, %y
  %min = select i1 %cond, i64 %y, i64 %x
; CHECK: %min = select i1 %cond, i64 %y, i64 %x
; CHECK-NEXT: -->  (-1 + (-1 * ((-1 + (-1 * %x)) umax (-1 + (-1 * %y)))))
  ret void
}

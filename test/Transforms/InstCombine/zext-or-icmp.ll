; RUN: opt < %s -instcombine -S | FileCheck %s

; Remove an icmp by using its operand in the subsequent logic directly.

define i8 @zext_or_icmp_icmp(i8 %a, i8 %b) {
  %mask = and i8 %a, 1
  %toBool1 = icmp eq i8 %mask, 0
  %toBool2 = icmp eq i8 %b, 0
  %bothCond = or i1 %toBool1, %toBool2
  %zext = zext i1 %bothCond to i8
  ret i8 %zext

; CHECK-LABEL: zext_or_icmp_icmp(
; CHECK-NEXT:   [[ICMP:%.*]] = icmp ne i8 %b, 0
; CHECK-NEXT:   [[ZEXT:%.*]] = zext i1 [[ICMP]] to i8
; CHECK-NEXT:   [[AND:%.*]] = and i8 [[ZEXT]], %a
; CHECK-NEXT:   [[XOR:%.*]] = xor i8 [[AND]], 1
; CHECK-NEXT:   ret i8 %zext
}


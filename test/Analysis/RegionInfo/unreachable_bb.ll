; RUN: opt -regions -analyze < %s | FileCheck %s

; CHECK: Region tree:
; CHECK: [0] entry => <Function Return>
; CHECK:   [1] loop => exit
; CHECK:       [2] loop.next => loop.backedge

define void @foo.bar() {
entry:
  br label %loop

loop:
  br label %loop.next

loop.next:
  br i1 false, label %loop.backedge, label %loop.unreachable

loop.unreachable:
  unreachable

loop.backedge:
  br i1 false, label %loop, label %exit

exit:
  ret void
}

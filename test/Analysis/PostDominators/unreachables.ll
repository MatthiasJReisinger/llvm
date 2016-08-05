; RUN: opt -postdomtree -analyze < %s | FileCheck %s

; Make sure we do _not_ add the unreachable node to the root nodes of the post
; dominator tree, as otherwise the post-dominator tree would flatten out and
; loose its structure. Instead, unreachable branches are just ignored in
; the post-dominator tree the same way infinite loops are left out.

; CHECK: Inorder PostDominator Tree:
; CHECK:   [1]  <<exit node>> {0,11}
; CHECK:     [2] %exit {1,10}
; CHECK:       [3] %loop.backedge {2,9}
; CHECK:         [4] %loop.next {3,8}
; CHECK:           [5] %loop {4,7}
; CHECK:             [6] %entry {5,6}

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

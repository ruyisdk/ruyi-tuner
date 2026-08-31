; ModuleID = '/tmp/tmp_33_digits.cpp'
source_filename = "/tmp/tmp_33_digits.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

module asm ".globl _ZSt21ios_base_library_initv"

@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: mustprogress uwtable
define dso_local noundef i32 @_Z4calci(i32 noundef %x) #0 {
entry:
  %x.addr = alloca i32, align 4
  %s = alloca i32, align 4
  %d = alloca i32, align 4
  store i32 %x, ptr %x.addr, align 4, !tbaa !5
  call void @llvm.lifetime.start.p0(i64 4, ptr %s) #4
  call void @llvm.lifetime.start.p0(i64 4, ptr %d) #4
  store i32 0, ptr %s, align 4, !tbaa !5
  br label %while.cond

while.cond:                                       ; preds = %sw.epilog, %entry
  %0 = load i32, ptr %x.addr, align 4, !tbaa !5
  %cmp = icmp sgt i32 %0, 0
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %1 = load i32, ptr %x.addr, align 4, !tbaa !5
  %rem = srem i32 %1, 10
  store i32 %rem, ptr %d, align 4, !tbaa !5
  %2 = load i32, ptr %d, align 4, !tbaa !5
  switch i32 %2, label %sw.default [
    i32 0, label %sw.bb
    i32 2, label %sw.bb2
    i32 4, label %sw.bb2
    i32 6, label %sw.bb2
    i32 8, label %sw.bb2
  ]

sw.bb:                                            ; preds = %while.body
  br label %sw.epilog

sw.bb2:                                           ; preds = %while.body, %while.body, %while.body, %while.body
  %3 = load i32, ptr %d, align 4, !tbaa !5
  %4 = load i32, ptr %s, align 4, !tbaa !5
  %add = add nsw i32 %4, %3
  store i32 %add, ptr %s, align 4, !tbaa !5
  br label %sw.epilog

sw.default:                                       ; preds = %while.body
  %5 = load i32, ptr %d, align 4, !tbaa !5
  %6 = load i32, ptr %d, align 4, !tbaa !5
  %mul = mul nsw i32 %5, %6
  %7 = load i32, ptr %s, align 4, !tbaa !5
  %add3 = add nsw i32 %7, %mul
  store i32 %add3, ptr %s, align 4, !tbaa !5
  br label %sw.epilog

sw.epilog:                                        ; preds = %sw.default, %sw.bb2, %sw.bb
  %8 = load i32, ptr %x.addr, align 4, !tbaa !5
  %div = sdiv i32 %8, 10
  store i32 %div, ptr %x.addr, align 4, !tbaa !5
  br label %while.cond, !llvm.loop !9

while.end:                                        ; preds = %while.cond
  %9 = load i32, ptr %s, align 4, !tbaa !5
  call void @llvm.lifetime.end.p0(i64 4, ptr %d) #4
  call void @llvm.lifetime.end.p0(i64 4, ptr %s) #4
  ret i32 %9
}

; Function Attrs: mustprogress norecurse uwtable
define dso_local noundef i32 @main() #2 {
entry:
  %retval = alloca i32, align 4
  %n = alloca i32, align 4
  %i = alloca i32, align 4
  %ans = alloca i32, align 4
  store i32 0, ptr %retval, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr %n) #4
  call void @llvm.lifetime.start.p0(i64 4, ptr %i) #4
  call void @llvm.lifetime.start.p0(i64 4, ptr %ans) #4
  %call = call i32 (ptr, ...) @__isoc23_scanf(ptr noundef @.str, ptr noundef %n)
  store i32 0, ptr %ans, align 4, !tbaa !5
  store i32 1, ptr %i, align 4, !tbaa !5
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, ptr %i, align 4, !tbaa !5
  %1 = load i32, ptr %n, align 4, !tbaa !5
  %cmp = icmp sle i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %2 = load i32, ptr %i, align 4, !tbaa !5
  %rem = srem i32 %2, 3
  %cmp1 = icmp eq i32 %rem, 0
  br i1 %cmp1, label %if.then, label %if.else

if.then:                                          ; preds = %for.body
  %3 = load i32, ptr %i, align 4, !tbaa !5
  %call2 = call noundef i32 @_Z4calci(i32 noundef %3)
  %4 = load i32, ptr %ans, align 4, !tbaa !5
  %add = add nsw i32 %4, %call2
  store i32 %add, ptr %ans, align 4, !tbaa !5
  br label %if.end

if.else:                                          ; preds = %for.body
  %5 = load i32, ptr %i, align 4, !tbaa !5
  %mul = mul nsw i32 %5, 2
  %call3 = call noundef i32 @_Z4calci(i32 noundef %mul)
  %6 = load i32, ptr %ans, align 4, !tbaa !5
  %add4 = add nsw i32 %6, %call3
  store i32 %add4, ptr %ans, align 4, !tbaa !5
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %7 = load i32, ptr %i, align 4, !tbaa !5
  %inc = add nsw i32 %7, 1
  store i32 %inc, ptr %i, align 4, !tbaa !5
  br label %for.cond, !llvm.loop !12

for.end:                                          ; preds = %for.cond
  %8 = load i32, ptr %ans, align 4, !tbaa !5
  %call5 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %8)
  call void @llvm.lifetime.end.p0(i64 4, ptr %ans) #4
  call void @llvm.lifetime.end.p0(i64 4, ptr %i) #4
  call void @llvm.lifetime.end.p0(i64 4, ptr %n) #4
  ret i32 0
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

declare i32 @__isoc23_scanf(ptr noundef, ...) #3

declare i32 @printf(ptr noundef, ...) #3

attributes #0 = { mustprogress uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress norecurse uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"clang version 21.1.8 (https://github.com/llvm/llvm-project.git 2078da43e25a4623cab2d0d60decddf709aaea28)"}
!5 = !{!6, !6, i64 0}
!6 = !{!"int", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C++ TBAA"}
!9 = distinct !{!9, !10, !11}
!10 = !{!"llvm.loop.mustprogress"}
!11 = !{!"llvm.loop.unroll.disable"}
!12 = distinct !{!12, !10, !11}

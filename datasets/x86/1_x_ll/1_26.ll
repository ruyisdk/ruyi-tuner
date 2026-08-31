; ModuleID = '/tmp/tmp_szqlk_l.cpp'
source_filename = "/tmp/tmp_szqlk_l.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

module asm ".globl _ZSt21ios_base_library_initv"

@a = dso_local global [1000 x i32] zeroinitializer, align 16
@l = dso_local global i32 0, align 4
@x = dso_local global i32 0, align 4
@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: mustprogress norecurse uwtable
define dso_local noundef i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %q = alloca i32, align 4
  %p = alloca i32, align 4
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %y = alloca i32, align 4
  store i32 0, ptr %retval, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr %i) #4
  call void @llvm.lifetime.start.p0(i64 4, ptr %j) #4
  call void @llvm.lifetime.start.p0(i64 4, ptr %q) #4
  call void @llvm.lifetime.start.p0(i64 4, ptr %p) #4
  call void @llvm.lifetime.start.p0(i64 4, ptr %n) #4
  call void @llvm.lifetime.start.p0(i64 4, ptr %m) #4
  call void @llvm.lifetime.start.p0(i64 4, ptr %y) #4
  %call = call i32 (ptr, ...) @__isoc23_scanf(ptr noundef @.str, ptr noundef %n)
  store i32 0, ptr %p, align 4, !tbaa !5
  br label %for.cond

for.cond:                                         ; preds = %for.inc9, %entry
  %0 = load i32, ptr %p, align 4, !tbaa !5
  %1 = load i32, ptr %n, align 4, !tbaa !5
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end11

for.body:                                         ; preds = %for.cond
  store i32 1, ptr %q, align 4, !tbaa !5
  store i32 0, ptr @l, align 4, !tbaa !5
  %call1 = call i32 (ptr, ...) @__isoc23_scanf(ptr noundef @.str, ptr noundef @x)
  store i32 2, ptr %i, align 4, !tbaa !5
  br label %for.cond2

for.cond2:                                        ; preds = %for.inc, %for.body
  %2 = load i32, ptr %i, align 4, !tbaa !5
  %3 = load i32, ptr @x, align 4, !tbaa !5
  %cmp3 = icmp sle i32 %2, %3
  br i1 %cmp3, label %for.body4, label %for.end

for.body4:                                        ; preds = %for.cond2
  %4 = load i32, ptr @x, align 4, !tbaa !5
  %5 = load i32, ptr %i, align 4, !tbaa !5
  %rem = srem i32 %4, %5
  %cmp5 = icmp eq i32 %rem, 0
  br i1 %cmp5, label %if.then, label %if.end

if.then:                                          ; preds = %for.body4
  %6 = load i32, ptr %i, align 4, !tbaa !5
  %7 = load i32, ptr %q, align 4, !tbaa !5
  %idxprom = sext i32 %7 to i64
  %arrayidx = getelementptr inbounds [1000 x i32], ptr @a, i64 0, i64 %idxprom
  store i32 %6, ptr %arrayidx, align 4, !tbaa !5
  %8 = load i32, ptr %q, align 4, !tbaa !5
  %inc = add nsw i32 %8, 1
  store i32 %inc, ptr %q, align 4, !tbaa !5
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body4
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %9 = load i32, ptr %i, align 4, !tbaa !5
  %inc6 = add nsw i32 %9, 1
  store i32 %inc6, ptr %i, align 4, !tbaa !5
  br label %for.cond2, !llvm.loop !9

for.end:                                          ; preds = %for.cond2
  %10 = load i32, ptr %q, align 4, !tbaa !5
  %sub = sub nsw i32 %10, 1
  %call7 = call noundef i32 @_Z3fffii(i32 noundef %sub, i32 noundef 1)
  %11 = load i32, ptr @l, align 4, !tbaa !5
  %call8 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %11)
  br label %for.inc9

for.inc9:                                         ; preds = %for.end
  %12 = load i32, ptr %p, align 4, !tbaa !5
  %inc10 = add nsw i32 %12, 1
  store i32 %inc10, ptr %p, align 4, !tbaa !5
  br label %for.cond, !llvm.loop !12

for.end11:                                        ; preds = %for.cond
  call void @llvm.lifetime.end.p0(i64 4, ptr %y) #4
  call void @llvm.lifetime.end.p0(i64 4, ptr %m) #4
  call void @llvm.lifetime.end.p0(i64 4, ptr %n) #4
  call void @llvm.lifetime.end.p0(i64 4, ptr %p) #4
  call void @llvm.lifetime.end.p0(i64 4, ptr %q) #4
  call void @llvm.lifetime.end.p0(i64 4, ptr %j) #4
  call void @llvm.lifetime.end.p0(i64 4, ptr %i) #4
  %13 = load i32, ptr %retval, align 4
  ret i32 %13
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

declare i32 @__isoc23_scanf(ptr noundef, ...) #2

; Function Attrs: mustprogress uwtable
define dso_local noundef i32 @_Z3fffii(i32 noundef %w, i32 noundef %t) #3 {
entry:
  %w.addr = alloca i32, align 4
  %t.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %y = alloca i32, align 4
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %p = alloca i32, align 4
  store i32 %w, ptr %w.addr, align 4, !tbaa !5
  store i32 %t, ptr %t.addr, align 4, !tbaa !5
  call void @llvm.lifetime.start.p0(i64 4, ptr %i) #4
  call void @llvm.lifetime.start.p0(i64 4, ptr %j) #4
  call void @llvm.lifetime.start.p0(i64 4, ptr %y) #4
  call void @llvm.lifetime.start.p0(i64 4, ptr %n) #4
  call void @llvm.lifetime.start.p0(i64 4, ptr %m) #4
  call void @llvm.lifetime.start.p0(i64 4, ptr %p) #4
  %0 = load i32, ptr %t.addr, align 4, !tbaa !5
  store i32 %0, ptr %i, align 4, !tbaa !5
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %1 = load i32, ptr %i, align 4, !tbaa !5
  %2 = load i32, ptr %w.addr, align 4, !tbaa !5
  %cmp = icmp sle i32 %1, %2
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %3 = load i32, ptr @x, align 4, !tbaa !5
  %4 = load i32, ptr %i, align 4, !tbaa !5
  %idxprom = sext i32 %4 to i64
  %arrayidx = getelementptr inbounds [1000 x i32], ptr @a, i64 0, i64 %idxprom
  %5 = load i32, ptr %arrayidx, align 4, !tbaa !5
  %rem = srem i32 %3, %5
  %cmp1 = icmp eq i32 %rem, 0
  br i1 %cmp1, label %if.then, label %if.end11

if.then:                                          ; preds = %for.body
  %6 = load i32, ptr @x, align 4, !tbaa !5
  %7 = load i32, ptr %i, align 4, !tbaa !5
  %idxprom2 = sext i32 %7 to i64
  %arrayidx3 = getelementptr inbounds [1000 x i32], ptr @a, i64 0, i64 %idxprom2
  %8 = load i32, ptr %arrayidx3, align 4, !tbaa !5
  %div = sdiv i32 %6, %8
  store i32 %div, ptr @x, align 4, !tbaa !5
  %9 = load i32, ptr @x, align 4, !tbaa !5
  %cmp4 = icmp eq i32 %9, 1
  br i1 %cmp4, label %if.then5, label %if.end

if.then5:                                         ; preds = %if.then
  %10 = load i32, ptr @l, align 4, !tbaa !5
  %inc = add nsw i32 %10, 1
  store i32 %inc, ptr @l, align 4, !tbaa !5
  br label %if.end

if.end:                                           ; preds = %if.then5, %if.then
  %11 = load i32, ptr @x, align 4, !tbaa !5
  %cmp6 = icmp sgt i32 %11, 1
  br i1 %cmp6, label %if.then7, label %if.end8

if.then7:                                         ; preds = %if.end
  %12 = load i32, ptr %w.addr, align 4, !tbaa !5
  %13 = load i32, ptr %i, align 4, !tbaa !5
  %call = call noundef i32 @_Z3fffii(i32 noundef %12, i32 noundef %13)
  br label %if.end8

if.end8:                                          ; preds = %if.then7, %if.end
  %14 = load i32, ptr @x, align 4, !tbaa !5
  %15 = load i32, ptr %i, align 4, !tbaa !5
  %idxprom9 = sext i32 %15 to i64
  %arrayidx10 = getelementptr inbounds [1000 x i32], ptr @a, i64 0, i64 %idxprom9
  %16 = load i32, ptr %arrayidx10, align 4, !tbaa !5
  %mul = mul nsw i32 %14, %16
  store i32 %mul, ptr @x, align 4, !tbaa !5
  br label %if.end11

if.end11:                                         ; preds = %if.end8, %for.body
  br label %for.inc

for.inc:                                          ; preds = %if.end11
  %17 = load i32, ptr %i, align 4, !tbaa !5
  %inc12 = add nsw i32 %17, 1
  store i32 %inc12, ptr %i, align 4, !tbaa !5
  br label %for.cond, !llvm.loop !13

for.end:                                          ; preds = %for.cond
  unreachable
}

declare i32 @printf(ptr noundef, ...) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

attributes #0 = { mustprogress norecurse uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { mustprogress uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
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
!13 = distinct !{!13, !10, !11}

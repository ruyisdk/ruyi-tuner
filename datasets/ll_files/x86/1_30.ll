; ModuleID = '/tmp/tmp_30_sieve.cpp'
source_filename = "/tmp/tmp_30_sieve.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

module asm ".globl _ZSt21ios_base_library_initv"

@prime = dso_local global [1001 x i8] zeroinitializer, align 16
@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: mustprogress norecurse uwtable
define dso_local noundef i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  %n = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %cnt = alloca i32, align 4
  store i32 0, ptr %retval, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr %n) #4
  call void @llvm.lifetime.start.p0(i64 4, ptr %i) #4
  call void @llvm.lifetime.start.p0(i64 4, ptr %j) #4
  call void @llvm.lifetime.start.p0(i64 4, ptr %cnt) #4
  %call = call i32 (ptr, ...) @__isoc23_scanf(ptr noundef @.str, ptr noundef %n)
  store i32 2, ptr %i, align 4, !tbaa !5
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, ptr %i, align 4, !tbaa !5
  %1 = load i32, ptr %n, align 4, !tbaa !5
  %cmp = icmp sle i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %2 = load i32, ptr %i, align 4, !tbaa !5
  %idxprom = sext i32 %2 to i64
  %arrayidx = getelementptr inbounds [1001 x i8], ptr @prime, i64 0, i64 %idxprom
  store i8 1, ptr %arrayidx, align 1, !tbaa !8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %3 = load i32, ptr %i, align 4, !tbaa !5
  %inc = add nsw i32 %3, 1
  store i32 %inc, ptr %i, align 4, !tbaa !5
  br label %for.cond, !llvm.loop !13

for.end:                                          ; preds = %for.cond
  store i32 2, ptr %i, align 4, !tbaa !5
  br label %for.cond1

for.cond1:                                        ; preds = %for.inc15, %for.end
  %4 = load i32, ptr %i, align 4, !tbaa !5
  %5 = load i32, ptr %i, align 4, !tbaa !5
  %mul = mul nsw i32 %4, %5
  %6 = load i32, ptr %n, align 4, !tbaa !5
  %cmp2 = icmp sle i32 %mul, %6
  br i1 %cmp2, label %for.body3, label %for.end17

for.body3:                                        ; preds = %for.cond1
  %7 = load i32, ptr %i, align 4, !tbaa !5
  %idxprom4 = sext i32 %7 to i64
  %arrayidx5 = getelementptr inbounds [1001 x i8], ptr @prime, i64 0, i64 %idxprom4
  %8 = load i8, ptr %arrayidx5, align 1, !tbaa !8
  %tobool = icmp ne i8 %8, 0
  br i1 %tobool, label %if.then, label %if.end

if.then:                                          ; preds = %for.body3
  %9 = load i32, ptr %i, align 4, !tbaa !5
  %10 = load i32, ptr %i, align 4, !tbaa !5
  %mul6 = mul nsw i32 %9, %10
  store i32 %mul6, ptr %j, align 4, !tbaa !5
  br label %for.cond7

for.cond7:                                        ; preds = %for.inc11, %if.then
  %11 = load i32, ptr %j, align 4, !tbaa !5
  %12 = load i32, ptr %n, align 4, !tbaa !5
  %cmp8 = icmp sle i32 %11, %12
  br i1 %cmp8, label %for.body9, label %for.end13

for.body9:                                        ; preds = %for.cond7
  %13 = load i32, ptr %j, align 4, !tbaa !5
  %idxprom10 = sext i32 %13 to i64
  %arrayidx11 = getelementptr inbounds [1001 x i8], ptr @prime, i64 0, i64 %idxprom10
  store i8 0, ptr %arrayidx11, align 1, !tbaa !8
  br label %for.inc11

for.inc11:                                        ; preds = %for.body9
  %14 = load i32, ptr %j, align 4, !tbaa !5
  %15 = load i32, ptr %i, align 4, !tbaa !5
  %add = add nsw i32 %14, %15
  store i32 %add, ptr %j, align 4, !tbaa !5
  br label %for.cond7, !llvm.loop !14

for.end13:                                        ; preds = %for.cond7
  br label %if.end

if.end:                                           ; preds = %for.end13, %for.body3
  br label %for.inc15

for.inc15:                                        ; preds = %if.end
  %16 = load i32, ptr %i, align 4, !tbaa !5
  %inc16 = add nsw i32 %16, 1
  store i32 %inc16, ptr %i, align 4, !tbaa !5
  br label %for.cond1, !llvm.loop !15

for.end17:                                        ; preds = %for.cond1
  store i32 0, ptr %cnt, align 4, !tbaa !5
  store i32 2, ptr %i, align 4, !tbaa !5
  br label %for.cond18

for.cond18:                                       ; preds = %for.inc27, %for.end17
  %17 = load i32, ptr %i, align 4, !tbaa !5
  %18 = load i32, ptr %n, align 4, !tbaa !5
  %cmp19 = icmp sle i32 %17, %18
  br i1 %cmp19, label %for.body20, label %for.end29

for.body20:                                       ; preds = %for.cond18
  %19 = load i32, ptr %i, align 4, !tbaa !5
  %idxprom21 = sext i32 %19 to i64
  %arrayidx22 = getelementptr inbounds [1001 x i8], ptr @prime, i64 0, i64 %idxprom21
  %20 = load i8, ptr %arrayidx22, align 1, !tbaa !8
  %tobool23 = icmp ne i8 %20, 0
  br i1 %tobool23, label %if.then24, label %if.end26

if.then24:                                        ; preds = %for.body20
  %21 = load i32, ptr %cnt, align 4, !tbaa !5
  %inc25 = add nsw i32 %21, 1
  store i32 %inc25, ptr %cnt, align 4, !tbaa !5
  br label %if.end26

if.end26:                                         ; preds = %if.then24, %for.body20
  br label %for.inc27

for.inc27:                                        ; preds = %if.end26
  %22 = load i32, ptr %i, align 4, !tbaa !5
  %inc28 = add nsw i32 %22, 1
  store i32 %inc28, ptr %i, align 4, !tbaa !5
  br label %for.cond18, !llvm.loop !16

for.end29:                                        ; preds = %for.cond18
  %23 = load i32, ptr %cnt, align 4, !tbaa !5
  %call30 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %23)
  call void @llvm.lifetime.end.p0(i64 4, ptr %cnt) #4
  call void @llvm.lifetime.end.p0(i64 4, ptr %j) #4
  call void @llvm.lifetime.end.p0(i64 4, ptr %i) #4
  call void @llvm.lifetime.end.p0(i64 4, ptr %n) #4
  ret i32 0
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

declare i32 @__isoc23_scanf(ptr noundef, ...) #2

declare i32 @printf(ptr noundef, ...) #2

attributes #0 = { mustprogress norecurse uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"clang version 21.1.8 (https://github.com/llvm/llvm-project.git 2078da43e25a4623cab2d0d60decddf709aaea28)"}
!5 = !{!6, !6, i64 0}
!6 = !{!"int", !9, i64 0}
!7 = !{!"bool", !9, i64 0}
!8 = !{!7, !7, i64 0}
!9 = !{!"omnipotent char", !10, i64 0}
!10 = !{!"Simple C++ TBAA"}
!11 = !{!"llvm.loop.mustprogress"}
!12 = !{!"llvm.loop.unroll.disable"}
!13 = distinct !{!13, !11, !12}
!14 = distinct !{!14, !11, !12}
!15 = distinct !{!15, !11, !12}
!16 = distinct !{!16, !11, !12}

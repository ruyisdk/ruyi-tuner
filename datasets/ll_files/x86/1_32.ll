; ModuleID = '/tmp/tmp_32_matmul.cpp'
source_filename = "/tmp/tmp_32_matmul.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

module asm ".globl _ZSt21ios_base_library_initv"

@a = dso_local global [55 x [55 x i32]] zeroinitializer, align 16
@b = dso_local global [55 x [55 x i32]] zeroinitializer, align 16
@c = dso_local global [55 x [55 x i32]] zeroinitializer, align 16
@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

; Function Attrs: mustprogress norecurse uwtable
define dso_local noundef i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  %n = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %s = alloca i32, align 4
  store i32 0, ptr %retval, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr %n) #4
  call void @llvm.lifetime.start.p0(i64 4, ptr %i) #4
  call void @llvm.lifetime.start.p0(i64 4, ptr %j) #4
  call void @llvm.lifetime.start.p0(i64 4, ptr %k) #4
  call void @llvm.lifetime.start.p0(i64 4, ptr %s) #4
  %call = call i32 (ptr, ...) @__isoc23_scanf(ptr noundef @.str, ptr noundef %n)
  store i32 0, ptr %i, align 4, !tbaa !5
  br label %for.cond

for.cond:                                         ; preds = %for.inc6, %entry
  %0 = load i32, ptr %i, align 4, !tbaa !5
  %1 = load i32, ptr %n, align 4, !tbaa !5
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end8

for.body:                                         ; preds = %for.cond
  store i32 0, ptr %j, align 4, !tbaa !5
  br label %for.cond1

for.cond1:                                        ; preds = %for.inc, %for.body
  %2 = load i32, ptr %j, align 4, !tbaa !5
  %3 = load i32, ptr %n, align 4, !tbaa !5
  %cmp2 = icmp slt i32 %2, %3
  br i1 %cmp2, label %for.body3, label %for.end

for.body3:                                        ; preds = %for.cond1
  %4 = load i32, ptr %i, align 4, !tbaa !5
  %idxprom = sext i32 %4 to i64
  %5 = load i32, ptr %j, align 4, !tbaa !5
  %idxprom4 = sext i32 %5 to i64
  %arrayidx = getelementptr inbounds [55 x [55 x i32]], ptr @a, i64 0, i64 %idxprom, i64 %idxprom4
  %call5 = call i32 (ptr, ...) @__isoc23_scanf(ptr noundef @.str, ptr noundef %arrayidx)
  br label %for.inc

for.inc:                                          ; preds = %for.body3
  %6 = load i32, ptr %j, align 4, !tbaa !5
  %inc = add nsw i32 %6, 1
  store i32 %inc, ptr %j, align 4, !tbaa !5
  br label %for.cond1, !llvm.loop !9

for.end:                                          ; preds = %for.cond1
  br label %for.inc6

for.inc6:                                         ; preds = %for.end
  %7 = load i32, ptr %i, align 4, !tbaa !5
  %inc7 = add nsw i32 %7, 1
  store i32 %inc7, ptr %i, align 4, !tbaa !5
  br label %for.cond, !llvm.loop !12

for.end8:                                         ; preds = %for.cond
  store i32 0, ptr %i, align 4, !tbaa !5
  br label %for.cond9

for.cond9:                                        ; preds = %for.inc17, %for.end8
  %8 = load i32, ptr %i, align 4, !tbaa !5
  %9 = load i32, ptr %n, align 4, !tbaa !5
  %cmp10 = icmp slt i32 %8, %9
  br i1 %cmp10, label %for.body11, label %for.end19

for.body11:                                       ; preds = %for.cond9
  store i32 0, ptr %j, align 4, !tbaa !5
  br label %for.cond12

for.cond12:                                       ; preds = %for.inc14, %for.body11
  %10 = load i32, ptr %j, align 4, !tbaa !5
  %11 = load i32, ptr %n, align 4, !tbaa !5
  %cmp13 = icmp slt i32 %10, %11
  br i1 %cmp13, label %for.body14, label %for.end16

for.body14:                                       ; preds = %for.cond12
  %12 = load i32, ptr %i, align 4, !tbaa !5
  %idxprom15 = sext i32 %12 to i64
  %13 = load i32, ptr %j, align 4, !tbaa !5
  %idxprom16 = sext i32 %13 to i64
  %arrayidx17 = getelementptr inbounds [55 x [55 x i32]], ptr @b, i64 0, i64 %idxprom15, i64 %idxprom16
  %call18 = call i32 (ptr, ...) @__isoc23_scanf(ptr noundef @.str, ptr noundef %arrayidx17)
  br label %for.inc14

for.inc14:                                        ; preds = %for.body14
  %14 = load i32, ptr %j, align 4, !tbaa !5
  %inc15 = add nsw i32 %14, 1
  store i32 %inc15, ptr %j, align 4, !tbaa !5
  br label %for.cond12, !llvm.loop !13

for.end16:                                        ; preds = %for.cond12
  br label %for.inc17

for.inc17:                                        ; preds = %for.end16
  %15 = load i32, ptr %i, align 4, !tbaa !5
  %inc18 = add nsw i32 %15, 1
  store i32 %inc18, ptr %i, align 4, !tbaa !5
  br label %for.cond9, !llvm.loop !14

for.end19:                                        ; preds = %for.cond9
  store i32 0, ptr %i, align 4, !tbaa !5
  br label %for.cond20

for.cond20:                                       ; preds = %for.inc39, %for.end19
  %16 = load i32, ptr %i, align 4, !tbaa !5
  %17 = load i32, ptr %n, align 4, !tbaa !5
  %cmp21 = icmp slt i32 %16, %17
  br i1 %cmp21, label %for.body22, label %for.end41

for.body22:                                       ; preds = %for.cond20
  store i32 0, ptr %j, align 4, !tbaa !5
  br label %for.cond23

for.cond23:                                       ; preds = %for.inc36, %for.body22
  %18 = load i32, ptr %j, align 4, !tbaa !5
  %19 = load i32, ptr %n, align 4, !tbaa !5
  %cmp24 = icmp slt i32 %18, %19
  br i1 %cmp24, label %for.body25, label %for.end38

for.body25:                                       ; preds = %for.cond23
  store i32 0, ptr %s, align 4, !tbaa !5
  store i32 0, ptr %k, align 4, !tbaa !5
  br label %for.cond26

for.cond26:                                       ; preds = %for.inc33, %for.body25
  %20 = load i32, ptr %k, align 4, !tbaa !5
  %21 = load i32, ptr %n, align 4, !tbaa !5
  %cmp27 = icmp slt i32 %20, %21
  br i1 %cmp27, label %for.body28, label %for.end35

for.body28:                                       ; preds = %for.cond26
  %22 = load i32, ptr %i, align 4, !tbaa !5
  %idxprom29 = sext i32 %22 to i64
  %23 = load i32, ptr %k, align 4, !tbaa !5
  %idxprom30 = sext i32 %23 to i64
  %arrayidx31 = getelementptr inbounds [55 x [55 x i32]], ptr @a, i64 0, i64 %idxprom29, i64 %idxprom30
  %24 = load i32, ptr %arrayidx31, align 4, !tbaa !5
  %25 = load i32, ptr %k, align 4, !tbaa !5
  %idxprom32 = sext i32 %25 to i64
  %26 = load i32, ptr %j, align 4, !tbaa !5
  %idxprom33 = sext i32 %26 to i64
  %arrayidx34 = getelementptr inbounds [55 x [55 x i32]], ptr @b, i64 0, i64 %idxprom32, i64 %idxprom33
  %27 = load i32, ptr %arrayidx34, align 4, !tbaa !5
  %mul = mul nsw i32 %24, %27
  %28 = load i32, ptr %s, align 4, !tbaa !5
  %add = add nsw i32 %28, %mul
  store i32 %add, ptr %s, align 4, !tbaa !5
  br label %for.inc33

for.inc33:                                        ; preds = %for.body28
  %29 = load i32, ptr %k, align 4, !tbaa !5
  %inc34 = add nsw i32 %29, 1
  store i32 %inc34, ptr %k, align 4, !tbaa !5
  br label %for.cond26, !llvm.loop !17

for.end35:                                        ; preds = %for.cond26
  %30 = load i32, ptr %s, align 4, !tbaa !5
  %31 = load i32, ptr %i, align 4, !tbaa !5
  %idxprom36 = sext i32 %31 to i64
  %32 = load i32, ptr %j, align 4, !tbaa !5
  %idxprom37 = sext i32 %32 to i64
  %arrayidx38 = getelementptr inbounds [55 x [55 x i32]], ptr @c, i64 0, i64 %idxprom36, i64 %idxprom37
  store i32 %30, ptr %arrayidx38, align 4, !tbaa !5
  br label %for.inc36

for.inc36:                                        ; preds = %for.end35
  %33 = load i32, ptr %j, align 4, !tbaa !5
  %inc37 = add nsw i32 %33, 1
  store i32 %inc37, ptr %j, align 4, !tbaa !5
  br label %for.cond23, !llvm.loop !16

for.end38:                                        ; preds = %for.cond23
  br label %for.inc39

for.inc39:                                        ; preds = %for.end38
  %34 = load i32, ptr %i, align 4, !tbaa !5
  %inc40 = add nsw i32 %34, 1
  store i32 %inc40, ptr %i, align 4, !tbaa !5
  br label %for.cond20, !llvm.loop !15

for.end41:                                        ; preds = %for.cond20
  store i32 0, ptr %i, align 4, !tbaa !5
  br label %for.cond42

for.cond42:                                       ; preds = %for.inc52, %for.end41
  %35 = load i32, ptr %i, align 4, !tbaa !5
  %36 = load i32, ptr %n, align 4, !tbaa !5
  %cmp43 = icmp slt i32 %35, %36
  br i1 %cmp43, label %for.body44, label %for.end54

for.body44:                                       ; preds = %for.cond42
  store i32 0, ptr %j, align 4, !tbaa !5
  br label %for.cond45

for.cond45:                                       ; preds = %for.inc49, %for.body44
  %37 = load i32, ptr %j, align 4, !tbaa !5
  %38 = load i32, ptr %n, align 4, !tbaa !5
  %cmp46 = icmp slt i32 %37, %38
  br i1 %cmp46, label %for.body47, label %for.end51

for.body47:                                       ; preds = %for.cond45
  %39 = load i32, ptr %i, align 4, !tbaa !5
  %idxprom48 = sext i32 %39 to i64
  %40 = load i32, ptr %j, align 4, !tbaa !5
  %idxprom49 = sext i32 %40 to i64
  %arrayidx50 = getelementptr inbounds [55 x [55 x i32]], ptr @c, i64 0, i64 %idxprom48, i64 %idxprom49
  %41 = load i32, ptr %arrayidx50, align 4, !tbaa !5
  %call51 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %41)
  br label %for.inc49

for.inc49:                                        ; preds = %for.body47
  %42 = load i32, ptr %j, align 4, !tbaa !5
  %inc50 = add nsw i32 %42, 1
  store i32 %inc50, ptr %j, align 4, !tbaa !5
  br label %for.cond45, !llvm.loop !19

for.end51:                                        ; preds = %for.cond45
  %call52 = call i32 @putchar(i32 noundef 10)
  br label %for.inc52

for.inc52:                                        ; preds = %for.end51
  %43 = load i32, ptr %i, align 4, !tbaa !5
  %inc53 = add nsw i32 %43, 1
  store i32 %inc53, ptr %i, align 4, !tbaa !5
  br label %for.cond42, !llvm.loop !18

for.end54:                                        ; preds = %for.cond42
  call void @llvm.lifetime.end.p0(i64 4, ptr %s) #4
  call void @llvm.lifetime.end.p0(i64 4, ptr %k) #4
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

declare i32 @putchar(i32 noundef) #2

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
!6 = !{!"int", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C++ TBAA"}
!9 = distinct !{!9, !10, !11}
!10 = !{!"llvm.loop.mustprogress"}
!11 = !{!"llvm.loop.unroll.disable"}
!12 = distinct !{!12, !10, !11}
!13 = distinct !{!13, !10, !11}
!14 = distinct !{!14, !10, !11}
!15 = distinct !{!15, !10, !11}
!16 = distinct !{!16, !10, !11}
!17 = distinct !{!17, !10, !11}
!18 = distinct !{!18, !10, !11}
!19 = distinct !{!19, !10, !11}

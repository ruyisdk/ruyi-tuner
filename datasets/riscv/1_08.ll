; ModuleID = 'src08.cpp'
source_filename = "src08.cpp"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "riscv64-unknown-linux-gnu"

%struct.Rect = type { %struct.Point, %struct.Point }
%struct.Point = type { i32, i32 }

@.str = private unnamed_addr constant [12 x i8] c"%d %d %d %d\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: minsize mustprogress noinline nounwind uwtable
define dso_local noundef signext i32 @_Z9rect_area4Rect([2 x i64] %0) #0 {
  %2 = alloca %struct.Rect, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store [2 x i64] %0, ptr %2, align 4
  %5 = getelementptr inbounds nuw %struct.Rect, ptr %2, i32 0, i32 1
  %6 = getelementptr inbounds nuw %struct.Point, ptr %5, i32 0, i32 0
  %7 = load i32, ptr %6, align 4
  %8 = getelementptr inbounds nuw %struct.Rect, ptr %2, i32 0, i32 0
  %9 = getelementptr inbounds nuw %struct.Point, ptr %8, i32 0, i32 0
  %10 = load i32, ptr %9, align 4
  %11 = sub nsw i32 %7, %10
  store i32 %11, ptr %3, align 4
  %12 = getelementptr inbounds nuw %struct.Rect, ptr %2, i32 0, i32 1
  %13 = getelementptr inbounds nuw %struct.Point, ptr %12, i32 0, i32 1
  %14 = load i32, ptr %13, align 4
  %15 = getelementptr inbounds nuw %struct.Rect, ptr %2, i32 0, i32 0
  %16 = getelementptr inbounds nuw %struct.Point, ptr %15, i32 0, i32 1
  %17 = load i32, ptr %16, align 4
  %18 = sub nsw i32 %14, %17
  store i32 %18, ptr %4, align 4
  %19 = load i32, ptr %3, align 4
  %20 = load i32, ptr %4, align 4
  %21 = mul nsw i32 %19, %20
  ret i32 %21
}

; Function Attrs: minsize mustprogress noinline nounwind uwtable
define dso_local noundef signext i32 @_Z12overlap_area4RectS_([2 x i64] %0, [2 x i64] %1) #0 {
  %3 = alloca %struct.Rect, align 4
  %4 = alloca %struct.Rect, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store [2 x i64] %0, ptr %3, align 4
  store [2 x i64] %1, ptr %4, align 4
  %7 = getelementptr inbounds nuw %struct.Rect, ptr %3, i32 0, i32 1
  %8 = getelementptr inbounds nuw %struct.Point, ptr %7, i32 0, i32 0
  %9 = load i32, ptr %8, align 4
  %10 = getelementptr inbounds nuw %struct.Rect, ptr %4, i32 0, i32 1
  %11 = getelementptr inbounds nuw %struct.Point, ptr %10, i32 0, i32 0
  %12 = load i32, ptr %11, align 4
  %13 = icmp slt i32 %9, %12
  br i1 %13, label %14, label %18

14:                                               ; preds = %2
  %15 = getelementptr inbounds nuw %struct.Rect, ptr %3, i32 0, i32 1
  %16 = getelementptr inbounds nuw %struct.Point, ptr %15, i32 0, i32 0
  %17 = load i32, ptr %16, align 4
  br label %22

18:                                               ; preds = %2
  %19 = getelementptr inbounds nuw %struct.Rect, ptr %4, i32 0, i32 1
  %20 = getelementptr inbounds nuw %struct.Point, ptr %19, i32 0, i32 0
  %21 = load i32, ptr %20, align 4
  br label %22

22:                                               ; preds = %18, %14
  %23 = phi i32 [ %17, %14 ], [ %21, %18 ]
  %24 = getelementptr inbounds nuw %struct.Rect, ptr %3, i32 0, i32 0
  %25 = getelementptr inbounds nuw %struct.Point, ptr %24, i32 0, i32 0
  %26 = load i32, ptr %25, align 4
  %27 = getelementptr inbounds nuw %struct.Rect, ptr %4, i32 0, i32 0
  %28 = getelementptr inbounds nuw %struct.Point, ptr %27, i32 0, i32 0
  %29 = load i32, ptr %28, align 4
  %30 = icmp sgt i32 %26, %29
  br i1 %30, label %31, label %35

31:                                               ; preds = %22
  %32 = getelementptr inbounds nuw %struct.Rect, ptr %3, i32 0, i32 0
  %33 = getelementptr inbounds nuw %struct.Point, ptr %32, i32 0, i32 0
  %34 = load i32, ptr %33, align 4
  br label %39

35:                                               ; preds = %22
  %36 = getelementptr inbounds nuw %struct.Rect, ptr %4, i32 0, i32 0
  %37 = getelementptr inbounds nuw %struct.Point, ptr %36, i32 0, i32 0
  %38 = load i32, ptr %37, align 4
  br label %39

39:                                               ; preds = %35, %31
  %40 = phi i32 [ %34, %31 ], [ %38, %35 ]
  %41 = sub nsw i32 %23, %40
  store i32 %41, ptr %5, align 4
  %42 = getelementptr inbounds nuw %struct.Rect, ptr %3, i32 0, i32 1
  %43 = getelementptr inbounds nuw %struct.Point, ptr %42, i32 0, i32 1
  %44 = load i32, ptr %43, align 4
  %45 = getelementptr inbounds nuw %struct.Rect, ptr %4, i32 0, i32 1
  %46 = getelementptr inbounds nuw %struct.Point, ptr %45, i32 0, i32 1
  %47 = load i32, ptr %46, align 4
  %48 = icmp slt i32 %44, %47
  br i1 %48, label %49, label %53

49:                                               ; preds = %39
  %50 = getelementptr inbounds nuw %struct.Rect, ptr %3, i32 0, i32 1
  %51 = getelementptr inbounds nuw %struct.Point, ptr %50, i32 0, i32 1
  %52 = load i32, ptr %51, align 4
  br label %57

53:                                               ; preds = %39
  %54 = getelementptr inbounds nuw %struct.Rect, ptr %4, i32 0, i32 1
  %55 = getelementptr inbounds nuw %struct.Point, ptr %54, i32 0, i32 1
  %56 = load i32, ptr %55, align 4
  br label %57

57:                                               ; preds = %53, %49
  %58 = phi i32 [ %52, %49 ], [ %56, %53 ]
  %59 = getelementptr inbounds nuw %struct.Rect, ptr %3, i32 0, i32 0
  %60 = getelementptr inbounds nuw %struct.Point, ptr %59, i32 0, i32 1
  %61 = load i32, ptr %60, align 4
  %62 = getelementptr inbounds nuw %struct.Rect, ptr %4, i32 0, i32 0
  %63 = getelementptr inbounds nuw %struct.Point, ptr %62, i32 0, i32 1
  %64 = load i32, ptr %63, align 4
  %65 = icmp sgt i32 %61, %64
  br i1 %65, label %66, label %70

66:                                               ; preds = %57
  %67 = getelementptr inbounds nuw %struct.Rect, ptr %3, i32 0, i32 0
  %68 = getelementptr inbounds nuw %struct.Point, ptr %67, i32 0, i32 1
  %69 = load i32, ptr %68, align 4
  br label %74

70:                                               ; preds = %57
  %71 = getelementptr inbounds nuw %struct.Rect, ptr %4, i32 0, i32 0
  %72 = getelementptr inbounds nuw %struct.Point, ptr %71, i32 0, i32 1
  %73 = load i32, ptr %72, align 4
  br label %74

74:                                               ; preds = %70, %66
  %75 = phi i32 [ %69, %66 ], [ %73, %70 ]
  %76 = sub nsw i32 %58, %75
  store i32 %76, ptr %6, align 4
  %77 = load i32, ptr %5, align 4
  %78 = icmp sgt i32 %77, 0
  br i1 %78, label %79, label %86

79:                                               ; preds = %74
  %80 = load i32, ptr %6, align 4
  %81 = icmp sgt i32 %80, 0
  br i1 %81, label %82, label %86

82:                                               ; preds = %79
  %83 = load i32, ptr %5, align 4
  %84 = load i32, ptr %6, align 4
  %85 = mul nsw i32 %83, %84
  br label %87

86:                                               ; preds = %79, %74
  br label %87

87:                                               ; preds = %86, %82
  %88 = phi i32 [ %85, %82 ], [ 0, %86 ]
  ret i32 %88
}

; Function Attrs: minsize mustprogress noinline norecurse uwtable
define dso_local noundef signext i32 @main() #1 {
  %1 = alloca i32, align 4
  %2 = alloca %struct.Rect, align 4
  %3 = alloca %struct.Rect, align 4
  %4 = alloca i32, align 4
  %5 = alloca %struct.Rect, align 4
  %6 = alloca i32, align 4
  %7 = alloca %struct.Rect, align 4
  %8 = alloca i32, align 4
  %9 = alloca %struct.Rect, align 4
  %10 = alloca %struct.Rect, align 4
  store i32 0, ptr %1, align 4
  %11 = getelementptr inbounds nuw %struct.Rect, ptr %2, i32 0, i32 0
  %12 = getelementptr inbounds nuw %struct.Point, ptr %11, i32 0, i32 0
  %13 = getelementptr inbounds nuw %struct.Rect, ptr %2, i32 0, i32 0
  %14 = getelementptr inbounds nuw %struct.Point, ptr %13, i32 0, i32 1
  %15 = getelementptr inbounds nuw %struct.Rect, ptr %2, i32 0, i32 1
  %16 = getelementptr inbounds nuw %struct.Point, ptr %15, i32 0, i32 0
  %17 = getelementptr inbounds nuw %struct.Rect, ptr %2, i32 0, i32 1
  %18 = getelementptr inbounds nuw %struct.Point, ptr %17, i32 0, i32 1
  %19 = call signext i32 (ptr, ...) @__isoc99_scanf(ptr noundef @.str, ptr noundef %12, ptr noundef %14, ptr noundef %16, ptr noundef %18) #4
  %20 = getelementptr inbounds nuw %struct.Rect, ptr %3, i32 0, i32 0
  %21 = getelementptr inbounds nuw %struct.Point, ptr %20, i32 0, i32 0
  %22 = getelementptr inbounds nuw %struct.Rect, ptr %3, i32 0, i32 0
  %23 = getelementptr inbounds nuw %struct.Point, ptr %22, i32 0, i32 1
  %24 = getelementptr inbounds nuw %struct.Rect, ptr %3, i32 0, i32 1
  %25 = getelementptr inbounds nuw %struct.Point, ptr %24, i32 0, i32 0
  %26 = getelementptr inbounds nuw %struct.Rect, ptr %3, i32 0, i32 1
  %27 = getelementptr inbounds nuw %struct.Point, ptr %26, i32 0, i32 1
  %28 = call signext i32 (ptr, ...) @__isoc99_scanf(ptr noundef @.str, ptr noundef %21, ptr noundef %23, ptr noundef %25, ptr noundef %27) #4
  call void @llvm.memcpy.p0.p0.i64(ptr align 4 %5, ptr align 4 %2, i64 16, i1 false)
  %29 = load [2 x i64], ptr %5, align 4
  %30 = call noundef signext i32 @_Z9rect_area4Rect([2 x i64] %29) #4
  store i32 %30, ptr %4, align 4
  call void @llvm.memcpy.p0.p0.i64(ptr align 4 %7, ptr align 4 %3, i64 16, i1 false)
  %31 = load [2 x i64], ptr %7, align 4
  %32 = call noundef signext i32 @_Z9rect_area4Rect([2 x i64] %31) #4
  store i32 %32, ptr %6, align 4
  call void @llvm.memcpy.p0.p0.i64(ptr align 4 %9, ptr align 4 %2, i64 16, i1 false)
  call void @llvm.memcpy.p0.p0.i64(ptr align 4 %10, ptr align 4 %3, i64 16, i1 false)
  %33 = load [2 x i64], ptr %9, align 4
  %34 = load [2 x i64], ptr %10, align 4
  %35 = call noundef signext i32 @_Z12overlap_area4RectS_([2 x i64] %33, [2 x i64] %34) #4
  store i32 %35, ptr %8, align 4
  %36 = load i32, ptr %4, align 4
  %37 = load i32, ptr %6, align 4
  %38 = add nsw i32 %36, %37
  %39 = load i32, ptr %8, align 4
  %40 = sub nsw i32 %38, %39
  %41 = call signext i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef signext %40) #4
  ret i32 0
}

; Function Attrs: minsize
declare signext i32 @__isoc99_scanf(ptr noundef, ...) #2

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #3

; Function Attrs: minsize
declare signext i32 @printf(ptr noundef, ...) #2

attributes #0 = { minsize mustprogress noinline nounwind uwtable "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv64" "target-features"="+64bit,+a,+c,+d,+f,+i,+m,+relax,+zaamo,+zalrsc,+zca,+zcd,+zicsr,+zmmul,-b,-e,-experimental-p,-experimental-smpmpmt,-experimental-svukte,-experimental-xrivosvisni,-experimental-xrivosvizip,-experimental-xsfmclic,-experimental-xsfsclic,-experimental-zibi,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvfbfa,-experimental-zvfofp8min,-experimental-zvkgs,-experimental-zvqdotq,-h,-q,-sdext,-sdtrig,-sha,-shcounterenw,-shgatpa,-shlcofideleg,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcntrpmf,-smcsrind,-smctr,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssctr,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xandesbfhcvt,-xandesperf,-xandesvbfhcvt,-xandesvdot,-xandesvpackfph,-xandesvsinth,-xandesvsintload,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xmipscbop,-xmipscmov,-xmipsexectl,-xmipslsp,-xqccmp,-xqci,-xqcia,-xqciac,-xqcibi,-xqcibm,-xqcicli,-xqcicm,-xqcics,-xqcicsr,-xqciint,-xqciio,-xqcilb,-xqcili,-xqcilia,-xqcilo,-xqcilsm,-xqcisim,-xqcisls,-xqcisync,-xsfcease,-xsfmm128t,-xsfmm16t,-xsfmm32a16f,-xsfmm32a32f,-xsfmm32a8f,-xsfmm32a8i,-xsfmm32t,-xsfmm64a64f,-xsfmm64t,-xsfmmbase,-xsfvcp,-xsfvfbfexp16e,-xsfvfexp16e,-xsfvfexp32e,-xsfvfexpa,-xsfvfexpa64e,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xsmtvdot,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zabha,-zacas,-zalasr,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zcb,-zce,-zcf,-zclsd,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccamoc,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zifencei,-zihintntl,-zihintpause,-zihpm,-zilsd,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #1 = { minsize mustprogress noinline norecurse uwtable "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv64" "target-features"="+64bit,+a,+c,+d,+f,+i,+m,+relax,+zaamo,+zalrsc,+zca,+zcd,+zicsr,+zmmul,-b,-e,-experimental-p,-experimental-smpmpmt,-experimental-svukte,-experimental-xrivosvisni,-experimental-xrivosvizip,-experimental-xsfmclic,-experimental-xsfsclic,-experimental-zibi,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvfbfa,-experimental-zvfofp8min,-experimental-zvkgs,-experimental-zvqdotq,-h,-q,-sdext,-sdtrig,-sha,-shcounterenw,-shgatpa,-shlcofideleg,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcntrpmf,-smcsrind,-smctr,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssctr,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xandesbfhcvt,-xandesperf,-xandesvbfhcvt,-xandesvdot,-xandesvpackfph,-xandesvsinth,-xandesvsintload,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xmipscbop,-xmipscmov,-xmipsexectl,-xmipslsp,-xqccmp,-xqci,-xqcia,-xqciac,-xqcibi,-xqcibm,-xqcicli,-xqcicm,-xqcics,-xqcicsr,-xqciint,-xqciio,-xqcilb,-xqcili,-xqcilia,-xqcilo,-xqcilsm,-xqcisim,-xqcisls,-xqcisync,-xsfcease,-xsfmm128t,-xsfmm16t,-xsfmm32a16f,-xsfmm32a32f,-xsfmm32a8f,-xsfmm32a8i,-xsfmm32t,-xsfmm64a64f,-xsfmm64t,-xsfmmbase,-xsfvcp,-xsfvfbfexp16e,-xsfvfexp16e,-xsfvfexp32e,-xsfvfexpa,-xsfvfexpa64e,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xsmtvdot,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zabha,-zacas,-zalasr,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zcb,-zce,-zcf,-zclsd,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccamoc,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zifencei,-zihintntl,-zihintpause,-zihpm,-zilsd,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #2 = { minsize "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv64" "target-features"="+64bit,+a,+c,+d,+f,+i,+m,+relax,+zaamo,+zalrsc,+zca,+zcd,+zicsr,+zmmul,-b,-e,-experimental-p,-experimental-smpmpmt,-experimental-svukte,-experimental-xrivosvisni,-experimental-xrivosvizip,-experimental-xsfmclic,-experimental-xsfsclic,-experimental-zibi,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvfbfa,-experimental-zvfofp8min,-experimental-zvkgs,-experimental-zvqdotq,-h,-q,-sdext,-sdtrig,-sha,-shcounterenw,-shgatpa,-shlcofideleg,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcntrpmf,-smcsrind,-smctr,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssctr,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xandesbfhcvt,-xandesperf,-xandesvbfhcvt,-xandesvdot,-xandesvpackfph,-xandesvsinth,-xandesvsintload,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xmipscbop,-xmipscmov,-xmipsexectl,-xmipslsp,-xqccmp,-xqci,-xqcia,-xqciac,-xqcibi,-xqcibm,-xqcicli,-xqcicm,-xqcics,-xqcicsr,-xqciint,-xqciio,-xqcilb,-xqcili,-xqcilia,-xqcilo,-xqcilsm,-xqcisim,-xqcisls,-xqcisync,-xsfcease,-xsfmm128t,-xsfmm16t,-xsfmm32a16f,-xsfmm32a32f,-xsfmm32a8f,-xsfmm32a8i,-xsfmm32t,-xsfmm64a64f,-xsfmm64t,-xsfmmbase,-xsfvcp,-xsfvfbfexp16e,-xsfvfexp16e,-xsfvfexp32e,-xsfvfexpa,-xsfvfexpa64e,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xsmtvdot,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zabha,-zacas,-zalasr,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zcb,-zce,-zcf,-zclsd,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccamoc,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zifencei,-zihintntl,-zihintpause,-zihpm,-zilsd,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #3 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #4 = { minsize }

!llvm.module.flags = !{!0, !1, !2, !4, !5, !6, !7, !8}
!llvm.ident = !{!9}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"target-abi", !"lp64d"}
!2 = !{i32 6, !"riscv-isa", !3}
!3 = !{!"rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"}
!4 = !{i32 8, !"PIC Level", i32 2}
!5 = !{i32 7, !"PIE Level", i32 2}
!6 = !{i32 7, !"uwtable", i32 2}
!7 = !{i32 7, !"frame-pointer", i32 2}
!8 = !{i32 8, !"SmallDataLimit", i32 0}
!9 = !{!"clang version 22.1.0-rc2 (git@isrc.iscas.ac.cn:plct/llvm-project.git 9e9b198b1d9032c72770faae4eda6cb8d902f2b6)"}

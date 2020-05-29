.class public simple4 
.super java/lang/Object

.method public static main([Ljava/lang/String;)V
 .limit locals 20 
 .limit stack 20
ldc 3.3
ldc 4.2
fadd
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(F)V
ldc 3.0
ldc 4.0
fadd
ldc 7.0
fmul
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(F)V
ldc 22.0
ldc 8.0
fadd
ldc 2.0
fmul
fstore 1
fload 1
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(F)V
return 
.end method


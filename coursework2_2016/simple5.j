.class public simple5 
.super java/lang/Object

.method public static main([Ljava/lang/String;)V
 .limit locals 20 
 .limit stack 20
ldc 3.3
ldc 4.2
fadd
fstore 1
ldc 3.0
ldc 4.0
fadd
ldc 7.0
fmul
fstore 2
fload 1
fload 2
fadd
fstore 3
fload 3
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(F)V
iconst_1
istore 4
iconst_5
iconst_4
iadd
istore 5
iload 4
iload 5
iadd
istore 4
iload 4
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(I)V
return 
.end method


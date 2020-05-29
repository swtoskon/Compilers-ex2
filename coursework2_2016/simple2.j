.class public simple2 
.super java/lang/Object

.method public static main([Ljava/lang/String;)V
 .limit locals 20 
 .limit stack 20
iconst_3
iconst_4
iadd
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(I)V
iconst_3
iconst_4
iadd
bipush 7
imul
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(I)V
return 
.end method


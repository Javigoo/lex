
TARGET = cadenes_c
all : $(TARGET)

$(TARGET) : $(TARGET).l
	lex $(TARGET).l
	gcc -Wall lex.yy.c -o $(TARGET) -ll

clean:
	rm -f *~ lex.yy.c $(TARGET)


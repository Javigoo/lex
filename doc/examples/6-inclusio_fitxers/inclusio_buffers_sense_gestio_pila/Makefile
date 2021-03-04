
TARGET = preprocessador
all : $(TARGET)

$(TARGET) : $(TARGET).l
	flex $(TARGET).l
	gcc -Wall lex.yy.c -o $(TARGET) -ll

clean:
	rm -f *~ lex.yy.c $(TARGET)


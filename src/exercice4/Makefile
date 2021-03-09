
TARGET = exercice4
all : $(TARGET)

$(TARGET) : $(TARGET).l
	flex $(TARGET).l
	gcc -Wall lex.yy.c -o $(TARGET)

clean:
	rm -f *~ lex.yy.c $(TARGET)

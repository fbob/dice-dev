 
exists(/usr/lib/libboost_python-py33.so) {
    INCLUDEPATH += /usr/include/python3.3m
    LIBS += -lboost_python-py33 -lpython3.3m
}

exists(/usr/lib/x86_64-linux-gnu/libboost_python-py33.so) {
    INCLUDEPATH += /usr/include/python3.3m
    LIBPATH += /usr/lib/x86_64-linux-gnu
    LIBS += -lboost_python-py33 -lpython3.3m
}

exists(/usr/lib/x86_64-linux-gnu/libboost_python-py34.so) {
    INCLUDEPATH += /usr/include/python3.4m
    LIBPATH += /usr/lib/x86_64-linux-gnu
    LIBS += -lboost_python-py34 -lpython3.4m
}

exists(/usr/lib/libboost_python3.so) {
    LIBS += -lboost_python3
}

exists(/usr/include/python3.3m) {
    INCLUDEPATH += /usr/include/python3.3m
    LIBS += -lpython3.3m
}

exists(/usr/include/python3.4m) {
    INCLUDEPATH += /usr/include/python3.4m
    LIBS += -lpython3.4m
}

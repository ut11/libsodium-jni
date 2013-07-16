if [ -z "$JAVA_HOME" ]; then
    echo "ERROR You should set JAVA_HOME"
    echo "Exiting!"
    exit 1
fi


C_INCLUDE_PATH="${JAVA_HOME}/include:${JAVA_HOME}/include/linux:/System/Library/Frameworks/JavaVM.framework/Headers"
export C_INCLUDE_PATH

rm *.java
rm *.c
rm *.so

#swig -java sodium.i
swig -java -package org.abstractj.kalium -outdir ../src/main/java/org/abstractj/kalium sodium.i


jnilib=libtestjni.so
destlib=/usr/lib
if uname -a | grep -q -i darwin; then
  jnilib=libtestjni.jnilib
  destlib=/usr/lib/java
fi
echo $jnilib
echo $destlib
gcc sodium_wrap.c -shared -fPIC -L/usr/lib -lsodium -o $jnilib
sudo rm /usr/lib/libtestjni.so 
sudo cp libtestjni.so $destlib

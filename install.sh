#!/bin/bash

go install github.com/tomnomnom/waybackurls@latest
sudo cp ~/go/bin/waybackurls /usr/local/bin/

go install github.com/tomnomnom/qsreplace@latest
sudo cp ~/go/bin/qsreplace /usr/local/bin/

go install github.com/ferreiraklet/airixss@latest
sudo cp ~/go/bin/airixss /usr/local/bin/

git clone https://github.com/ameenmaali/urldedupe.git
cd urldedupe
sudo apt install cmake g++ -y
cmake CMakeLists.txt
make
ls
sudo cp urldedupe /usr/local/bin/
cd ..
rm -rf urldedupe

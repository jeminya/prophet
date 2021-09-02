FROM nwtgck/llvm-clang:3.6.2

# Dependencies
RUN apt update && apt upgrade -y
RUN apt install build-essential checkinstall zlib1g-dev -y

# Build openssl
WORKDIR /usr/local/src/
RUN sudo wget https://www.openssl.org/source/openssl-1.1.1c.tar.gz
RUN tar -xf openssl-1.1.1c.tar.gz
WORKDIR /usr/local/src/openssl-1.1.1c
RUN ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared zlib
RUN make
RUN make test
RUN make install
WORKDIR /etc/ld.so.conf.d/
RUN echo '/usr/local/ssl/lib' > openssl-1.1.1c.conf
RUN ldconfig -v
RUN mv /usr/bin/c_rehash /usr/bin/c_rehash.backup
RUN mv /usr/bin/openssl /usr/bin/openssl.backup
ENV PATH="/usr/local/llvm/llvm-3.6.2/bin:${PATH}:/usr/local/ssl/bin"

# Build python
RUN apt update
RUN apt install -y software-properties-common libncurses5-dev libgdbm-dev libnss3-dev \
                libssl-dev libreadline-dev libffi-dev wget curl libbz2-dev
WORKDIR /usr/local/src
RUN wget https://www.python.org/ftp/python/3.9.1/Python-3.9.1.tgz
RUN tar -xvzf Python-3.9.1.tgz
WORKDIR /usr/local/src/Python-3.9.1
RUN ./configure --with-openssl=/usr/local/ssl
RUN make altinstall

# Install pip
RUN curl https://bootstrap.pypa.io/pip/get-pip.py --output get-pip.py
RUN /usr/local/bin/python3.9 get-pip.py 
RUN pip install --upgrade pip

# Install Mercurial
RUN pip install --upgrade Mercurial

# Dependencies
RUN apt install -y autoconf libtool libexplain-dev curl libtinfo-dev \
                lib32z1 bison flex subversion git unzip python texinfo autopoint gettext

# Get Prophet source code
RUN mkdir -p /home/workspace
WORKDIR /home/workspace
RUN git clone https://github.com/jeminya/prophet.git

# Build Prophet
WORKDIR /home/workspace/prophet
RUN chmod +x tools/*.py
RUN autoreconf -i
RUN ./configure
RUN make CXXFLAGS='-w -fno-rtti'
RUN make install
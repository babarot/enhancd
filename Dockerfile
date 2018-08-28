FROM bash:3.2

RUN apk update && \
    apk add --no-cache --virtual .build-deps git wget build-base && \
    git clone https://github.com/jhawthorn/fzy && \
    cd fzy && make && make install && cd .. && \
    wget https://github.com/junegunn/fzf-bin/releases/download/0.17.4/fzf-0.17.4-linux_amd64.tgz && \
    tar xzvf fzf-0.17.4-linux_amd64.tgz && \
    install -m 0755 fzf /bin && \
    git clone https://github.com/b4b4r07/enhancd.git && \
    apk del .build-deps

RUN echo "source /enhancd/init.sh" | tee /etc/bashrc
CMD bash --rcfile /etc/bashrc

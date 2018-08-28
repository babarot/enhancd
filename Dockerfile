FROM bash:3.2

ENV FZF_VERSION 0.17.4

RUN apk update && \
    apk add --no-cache --virtual .build-deps git wget build-base && \
    git clone https://github.com/jhawthorn/fzy && \
    cd fzy && make && make install && cd .. && \
    wget https://github.com/junegunn/fzf-bin/releases/download/${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tgz && \
    tar xzvf fzf-${FZF_VERSION}-linux_amd64.tgz && \
    install -m 0755 fzf /bin && rm fzf fzf-${FZF_VERSION}-linux_amd64.tgz && \
    git clone https://github.com/b4b4r07/enhancd.git && \
    apk del .build-deps

RUN echo "source /enhancd/init.sh" | tee /etc/bashrc
CMD bash --rcfile /etc/bashrc

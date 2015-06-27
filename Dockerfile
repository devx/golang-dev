# WORK IN PROGRESS
# TODO: fix editorconfig issue in vimified
FROM alpine:3.2
MAINTAINER Victor Palma <victor.palma@rackspace.com>

RUN echo "@edge http://dl-4.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories

RUN apk add --update ca-certificates@edge go@edge git@edge zsh@edge vim@edge

# GO LANG Specific environment variables
ENV GOPATH /go
ENV GOBIN /go/bin
ENV PATH $GOPATH/bin:$PATH

RUN mkdir -p /go/src /go/bin /go/pkg

# You can change or remove after this to make it your own

# install  oh-my-zsh
RUN cd /root; git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git .oh-my-zsh;  \
    cp /root/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# install vimified
RUN cd /root; git clone git://github.com/zaiste/vimified.git; \
    ln -sfn vimified/ /root/.vim; \
    ln -sfn vimified/vimrc /root/.vimrc; \
    cd vimified; \
    mkdir bundle ; \
    mkdir -p tmp/backup tmp/swap tmp/undo ; \
    git clone https://github.com/gmarik/vundle.git bundle/vundle ; \
    echo "let g:vimified_packages = ['coding', 'go', 'color']" > local.vimrc

RUN vim +BundleInstall +qall 2&> /dev/null

# Additional dev tools


# Define working directory.
WORKDIR /go

# Add custom .dot files
ADD zshrc /root/.zshrc

CMD ["/bin/zsh"]